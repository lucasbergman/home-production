import collections
import dataclasses
import getpass
import json
import re
import typing
import urllib.parse
import urllib.request


@dataclasses.dataclass(frozen=True)
class Config:
    # The name of the image; this will be the key in the generated HCL map
    name: str

    # In Docker Hub, images are referred to as a namespace and a repo name
    # separated by '/', or just a repo name some "official" images such as
    # nginx; in the second case, namespace is None
    namespace: typing.Optional[str]
    repo: str

    # The "meta"-label such as "stable" or "latest" that points to the release
    # line we want to track; if this isn't given, then we use the most recent
    # image whose label matches label_expr
    metalabel: typing.Optional[str]

    # A regular expression that labels we use have to match; this is a way to
    # exclude rc or test images
    label_expr: str


def getlabel(imagejson, config: Config):
    results = imagejson["results"]
    targetdigest = None
    labelmap = collections.defaultdict(list)
    posslabels = []

    for result in results:
        for image in result["images"]:
            if "digest" not in image:
                continue
            if image["architecture"] != "amd64":
                continue
            labelmap[image["digest"]].append(result["name"])
            if config.metalabel is not None:
                if result["name"] == config.metalabel:
                    targetdigest = image["digest"]
            posslabels.append(result["name"])
    if config.metalabel is not None:
        assert targetdigest is not None, "Cannot find target digest for %s/%s" % (
            config.namespace,
            config.repo,
        )
    else:
        assert targetdigest is None
        assert len(posslabels) > 0

    if targetdigest is None:
        for label in posslabels:
            if re.match(config.label_expr, label) is not None:
                return label
        return None

    for label in labelmap[targetdigest]:
        if re.match(config.label_expr, label) is not None:
            return label
    return None


def gettags(token: str, config: Config):
    # The namespace part of the URL becomes the magic value "library" for
    # officially supported images
    ns = "library" if config.namespace is None else urllib.parse.quote(config.namespace)

    repo = urllib.parse.quote(config.repo)
    url = (
        "https://hub.docker.com/v2/repositories/%s/%s/tags"
        "?page_size=100&status=active&currently_tagged=true" % (ns, repo)
    )
    req = urllib.request.Request(url)
    req.add_header("content-type", "application/json")
    req.add_header("authorization", "JWT %s" % (token,))
    with urllib.request.urlopen(req) as resp:
        assert resp.status == 200
        return json.loads(resp.read())


def gettoken(username: str, password: str) -> str:
    authdataobj = {"username": username, "password": password}
    authdata = json.dumps(authdataobj).encode("utf-8")
    req = urllib.request.Request("https://hub.docker.com/v2/users/login", data=authdata)
    req.add_header("content-type", "application/json")
    with urllib.request.urlopen(req) as resp:
        assert resp.status == 200
        return json.loads(resp.read())["token"]


def tohcl(configs: typing.List[Config], labelmap: typing.Dict[Config, str]):
    result = ""
    result += "# -*- mode: hcl -*-\n"
    result += "images = {\n"
    for config in configs:
        namestr = "%s%s" % (
            "%s/" % (config.namespace,) if config.namespace is not None else "",
            config.repo,
        )
        result += "    %s = {\n" % (config.name,)
        result += '        name = "%s"\n' % (namestr,)
        result += '        version = "%s"\n' % (labelmap[config],)
        result += "    }\n"
    result += "}\n"
    return result


if __name__ == "__main__":
    # TODO: Move to external config
    configs = [
        Config("nginx", None, "nginx", "mainline", r"^\d+\.\d+\.\d+$"),
        Config("grafana", "grafana", "grafana", "latest", r"^[\d\.]+$"),
        Config(
            "homeassistant",
            "homeassistant",
            "home-assistant",
            "stable",
            r"^\d+\.\d+\.\d+$",
        ),
        Config("plex", "linuxserver", "plex", "latest", r"^\d+\.\d+\."),
        Config("prom_alertmanager", "prom", "alertmanager", "latest", r"^v[\d\.]+$"),
        Config("prom_prometheus", "prom", "prometheus", "latest", r"^v[\d\.]+$"),
        Config("unifi", "linuxserver", "unifi-controller", "latest", r"^\d+\.\d+\."),
    ]

    username = getpass.getpass(prompt="Docker Hub user name: ")
    password = getpass.getpass(prompt="Docker Hub password: ")
    token = gettoken(username, password)
    labelmap = {}
    for config in configs:
        imagejson = gettags(token, config)
        label = getlabel(imagejson, config)
        assert label is not None
        labelmap[config] = label
    print(tohcl(configs, labelmap))

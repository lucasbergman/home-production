load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_python",
    sha256 = "954aa89b491be4a083304a2cb838019c8b8c3720a7abb9c4cb81ac7a24230cea",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.4.0/rules_python-0.4.0.tar.gz",
)

load("@rules_python//python:pip.bzl", "pip_install")

pip_install(
    name = "gcloud_deps",
    requirements = "//tools:gcloud-requirements.txt",
)

pip_install(
    name = "pytest_deps",
    requirements = "//tools:pytest-requirements.txt",
)

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "4349f2b0b45c860dd2ffe18802e9f79183806af93ce5921fb12cbd6c07ab69a8",
    strip_prefix = "rules_docker-0.21.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.21.0/rules_docker-v0.21.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)

container_pull(
    name = "alpine_amd64",
    digest = "sha256:4ff3ca91275773af45cb4b0834e12b7eb47d1c18f770a0b151381cd227f4c253",
    registry = "index.docker.io",
    repository = "alpine",
    tag = "3.16",
)

container_pull(
    name = "golang_alpine_amd64",
    digest = "sha256:725f8fd50191209a4c4a00def1d93c4193c4d0a1c2900139daf8f742480f3367",
    registry = "index.docker.io",
    repository = "golang",
    tag = "1.18.3-alpine3.16",
)

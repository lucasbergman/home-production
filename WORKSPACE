load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_python",
    sha256 = "aa96a691d3a8177f3215b14b0edc9641787abaaa30363a080165d06ab65e1161",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.0.1/rules_python-0.0.1.tar.gz",
)

load("@rules_python//python:repositories.bzl", "py_repositories")

py_repositories()
rules_python_external_version = "825ca18f003285cb09a32d64169eb465e0387fd1"
http_archive(
    name = "rules_python_external",
    sha256 = "5219eafc1f25c3d97b181b7a489a9c48606a2e15caea29653274e440112f82ce",
    strip_prefix = "rules_python_external-{version}".format(version = rules_python_external_version),
    url = "https://github.com/dillon-giacoppo/rules_python_external/archive/{version}.zip".format(version = rules_python_external_version),
)

load("@rules_python_external//:repositories.bzl", "rules_python_external_dependencies")
rules_python_external_dependencies()
load("@rules_python_external//:defs.bzl", "pip_install")

pip_install(
    name = "gcloud_deps",
    requirements = "//tools:gcloud-requirements.txt",
)

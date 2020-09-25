load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_python",
    sha256 = "b5668cde8bb6e3515057ef465a35ad712214962f0b3a314e551204266c7be90c",
    strip_prefix = "rules_python-0.0.2",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.0.2/rules_python-0.0.2.tar.gz",
)

http_archive(
    name = "rules_python_external",
    sha256 = "c7d43551d44c7ca8bb1360c1076be228a0561c8abbdea7eb73e279b83773f51c",
    strip_prefix = "rules_python_external-8029ddb56227d97cd052ff034929b7790a63a133",
    url = "https://github.com/dillon-giacoppo/rules_python_external/archive/8029ddb56227d97cd052ff034929b7790a63a133.zip",
)

load("@rules_python_external//:repositories.bzl", "rules_python_external_dependencies")
load("@rules_python_external//:defs.bzl", "pip_install")

rules_python_external_dependencies()

pip_install(
    name = "gcloud_deps",
    requirements = "//tools:gcloud-requirements.txt",
)

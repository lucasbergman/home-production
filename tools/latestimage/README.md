Use this tool to automatically generate HCL for the container images we need
to run the house jobs. Minimum survival commands:

```shell
$ cd house/jobs
$ bazel run //tools/latestimage > images.auto.tfvars
```

# Assets

This directory sets up assets on public cloud services that can be (or must
be) in place before machine configuration happens.

## Prerequisites

Base requirements are [Terraform](https://www.terraform.io/) and occasionally
the `gcloud` and `gsutil` commands from the [Google Cloud SDK command-line
tools](https://cloud.google.com/sdk). I'm likely to add the
[Bazel](https://bazel.build/) build system later.

## Initial Setup

Terraform has to store its state in Google Cloud Storage. If you're starting
from scratch you'll have to create the storage bucket for Terraform to use:

```shell
# Check that our Terraform state storage bucket exists already:
$ gsutil ls -b -p bergmans-services gs://bergmans-services-assets
gs://bergmans-services-assets/

# If it doesn't exist, create it like this (make sure the project ID and
# bucket name match the values in base.tf):
$ gsutil mb -p bergmans-services -b on --pap enforced gs://bergmans-services-assets

# The -b and --pap options nail down bucket security; the first turns on
# "uniform bucket access" and the second turns on "public access prevention"
# so it can't accidentally be exposed over the internet.
```

Run `terraform init` if you haven't before.

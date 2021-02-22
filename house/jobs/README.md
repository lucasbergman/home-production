Once the host has its basic packages and filesystem set up, this directory is
used to deploy jobs on the host. Specifically it:

1. Adds some policies to Vault to allow the Nomad server to access secrets
2. Deploys a bunch of jobs on Nomad

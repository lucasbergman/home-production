#!/bin/bash
# <UDF name="creds" label="base64-JSON-encoded GCP credentials" example="ewogIC..." default="">
set -e
exec &> /root/stackscript.log

/usr/bin/install -m 640 -o 0 -g 0 /dev/null /etc/gcp-instance-creds.json
echo -n "$CREDS" | /usr/bin/base64 --decode > /etc/gcp-instance-creds.json

export DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical
/usr/bin/apt-get --quiet --assume-yes update
/usr/bin/apt-get --quiet --assume-yes \
    --option "Dpkg::Options::=--force-confdef" \
    --option "Dpkg::Options::=--force-confnew" \
    upgrade

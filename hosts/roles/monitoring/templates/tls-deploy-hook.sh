#!/bin/bash
set -e

if [[ $(systemctl show --property=SubState --value nginx.service) = running ]]; then
    systemctl --quiet reload nginx.service
fi

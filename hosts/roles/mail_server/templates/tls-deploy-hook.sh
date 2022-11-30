#!/bin/bash
set -e

for svc in dovecot postfix; do
    if [[ $(systemctl show --property=SubState --value "$svc".service) = running ]]; then
        systemctl --quiet restart "$svc".service
    fi
done

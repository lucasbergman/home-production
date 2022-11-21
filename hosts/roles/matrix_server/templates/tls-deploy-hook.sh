#!/bin/bash
set -e

if [[ $(systemctl show --property=SubState --value matrix-synapse.service) = running ]]; then
    systemctl --quiet restart matrix-synapse.service
fi

#!/bin/bash
set -e

setfacl -m u:mumble-server:rX /etc/letsencrypt/live
setfacl -m u:mumble-server:rX /etc/letsencrypt/archive
setfacl --recursive -m u:mumble-server:rX /etc/letsencrypt/live/{{ mumble_server_tls_host }}
setfacl --recursive -m u:mumble-server:rX /etc/letsencrypt/archive/{{ mumble_server_tls_host }}

# The Mumble server doesn't have a proper systemd unit set up, even in 2022;
# it's just using sysv init compatibility. And anecdotally the server seems to
# fork and die with exit code zero (!) if its configuration is bogus, so
# systemd can't really keep it running reliably. So, we have to resort to
# querying its state this way until I get that fixed.
if [[ $(systemctl show --property=SubState --value mumble-server.service) = dead ]]; then
    systemctl --quiet start mumble-server.service
else
    systemctl --quiet restart mumble-server.service
fi

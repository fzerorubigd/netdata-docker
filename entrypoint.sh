#!/usr/bin/env bash
set -eo pipefail

# First simply call for iniset to set any variables
/bin/iniset
# fix permissions due to netdata running as root
chown root:root /usr/share/netdata/web/ -R
echo -n "" > /usr/share/netdata/web/version.txt

if [ "$1" = 'bash' ]; then
    exec /bin/bash
else
    exec /usr/sbin/netdata -D -u root -s /host $@
fi;
#!/usr/bin/env bash

set -eo pipefail

# Run iniset
/bin/iniset

# Fix permissions:
chown netdata:netdata /usr/share/netdata/web/ -R

echo -n "" > /usr/share/netdata/web/version.txt

# Insert configs from ENV to /etc/netdata/health_alarm_notify.conf
# This ENVs should be start with "ENV_" prifix
# For example: ENV_SEND_SLACK="YES"
for EACH_ENV in $(env | grep "^ENV"); do
    ENV_VAR=$(echo ${EACH_ENV} | cut -d"_" -f2-)
    echo "${ENV_VAR}" >> /etc/netdata/health_alarm_notify.conf
done

if [ "$1" = 'bash' ]; then
    exec /bin/bash
else
    exec /usr/sbin/netdata -D -u netdata -s /host $@
fi


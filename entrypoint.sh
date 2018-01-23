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
    ENV_VAR=$(echo ${EACH_ENV} | cut -d"_" -f2- | cut -d"=" -f1)
    ENV_NEW_VALUE=$(echo ${EACH_ENV} | cut -d'=' -f2- | sed "s/\"//g")
    COMMAND_OUTPUT=$(grep "^${ENV_VAR}" /etc/netdata/health_alarm_notify.conf | head --lines=1)
    RETURN_CODE=$(echo $?)
    if [[ ${RETURN_CODE} == 0 ]]; then
        ENV_OLD_VALUE=$(echo $COMMAND_OUTPUT | cut -d"=" -f2- | sed "s/\"//g")
        if [[ "${ENV_NEW_VALUE}" != "${END_OLD_VALUE}" ]]; then
            NEW_ENV_VAR="${ENV_VAR}=\"${ENV_NEW_VALUE}\""
            sed -i -e "s|${COMMAND_OUTPUT}|${NEW_ENV_VAR}|g" /etc/netdata/health_alarm_notify.conf
        fi
    else
        echo "${ENV_VAR}=\"${ENV_NEW_VALUE}\"" >> /etc/netdata/health_alarm_notify.conf
    fi
done

if [ "$1" = 'bash' ]; then
    exec /bin/bash
else
    exec /usr/sbin/netdata -D -u netdata -s /host $@
fi


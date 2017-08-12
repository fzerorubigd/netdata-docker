#!/usr/bin/env bash
set -eo pipefail

# First simply call for iniset to set any variables
/bin/iniset

# Following code are code from https://github.com/titpetric/netdata
# fix permissions due to netdata running as root
chown netdata:netdata /usr/share/netdata/web/ -R
echo -n "" > /usr/share/netdata/web/version.txt

if [[ $SLACK_WEBHOOK_URL ]]; then
	sed -i -e "s@SLACK_WEBHOOK_URL=\"\"@SLACK_WEBHOOK_URL=\"${SLACK_WEBHOOK_URL}\"@" /etc/netdata/health_alarm_notify.conf
fi

if [[ $SLACK_CHANNEL ]]; then
	sed -i -e "s@DEFAULT_RECIPIENT_SLACK=\"\"@DEFAULT_RECIPIENT_SLACK=\"${SLACK_CHANNEL}\"@" /etc/netdata/health_alarm_notify.conf
fi

if [[ $TELEGRAM_BOT_TOKEN ]]; then
	sed -i -e "s@TELEGRAM_BOT_TOKEN=\"\"@TELEGRAM_BOT_TOKEN=\"${TELEGRAM_BOT_TOKEN}\"@" /etc/netdata/health_alarm_notify.conf
fi

if [[ $TELEGRAM_CHAT_ID ]]; then
	sed -i -e "s@DEFAULT_RECIPIENT_TELEGRAM=\"\"@DEFAULT_RECIPIENT_TELEGRAM=\"${TELEGRAM_CHAT_ID}\"@" /etc/netdata/health_alarm_notify.conf
fi

if [[ $PUSHBULLET_ACCESS_TOKEN ]]; then
	sed -i -e "s@PUSHBULLET_ACCESS_TOKEN=\"\"@PUSHBULLET_ACCESS_TOKEN=\"${PUSHBULLET_ACCESS_TOKEN}\"@" /etc/netdata/health_alarm_notify.conf
fi

if [[ $PUSHBULLET_DEFAULT_EMAIL ]]; then
	sed -i -e "s#DEFAULT_RECIPIENT_PUSHBULLET=\"\"#DEFAULT_RECIPIENT_PUSHBULLET=\"${PUSHBULLET_DEFAULT_EMAIL}\"#" /etc/netdata/health_alarm_notify.conf
fi

if [[ $NETDATA_IP ]]; then
	NETDATA_ARGS="${NETDATA_ARGS} -i ${NETDATA_IP}"
fi

if [ "$1" = 'bash' ]; then
    exec /bin/bash
else
    exec /usr/sbin/netdata -D -u netdata -s /host $@
fi;

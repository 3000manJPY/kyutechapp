#!/bin/sh
# start-cron.sh

#rsyslogd
crond
#touch /var/log/cron.log
printenv | awk '{print "export " $1}' > /root/env.sh
#tail -f /var/log/syslog /var/log/cron.log



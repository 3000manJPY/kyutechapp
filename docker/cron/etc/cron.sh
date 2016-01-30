#!/bin/sh
. /root/env.sh


`cd /kyutechapp && RAILS_ENV=production bundle exec rake cron:kit_i --silent >> /kyutechapp/log/cron.log 6>&1`



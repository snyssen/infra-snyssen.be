#! /bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
echo 'Cron started, running ytdl-sub...'
curl --retry 5 -o /dev/null https://hc-ping.com/{{ ytdl_sub__healthcheck_id }}/start
ytdl-sub sub --config /config/config.yaml /config/subscriptions.yaml
curl --retry 5 -o /dev/null https://hc-ping.com/{{ ytdl_sub__healthcheck_id }}/$?

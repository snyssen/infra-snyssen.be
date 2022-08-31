#!/bin/sh

set -e

# Possible actions: error, pre-backup, post-backup
case "${1}" in
"error")
	echo "Pinging error healthcheck endpoint"
	curl --retry 3 https://hc-ping.com/"${HEALTHCHECK_ID}"/1
	;;
"pre-backup")
	echo "Pinging start healthcheck endpoint"
	curl --retry 3 https://hc-ping.com/"${HEALTHCHECK_ID}"/start
	;;
"post-backup")
	echo "Pinging success healthcheck endpoint"
	curl --retry 3 https://hc-ping.com/"${HEALTHCHECK_ID}"/0
	;;
*) ;;
esac

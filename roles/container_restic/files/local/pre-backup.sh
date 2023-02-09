#! /bin/sh
curl --retry 3 https://hc-ping.com/"${HEALTHCHECK_ID}"/start
awake "${BACKUP_SERVER_MAC_ADDRESS}" # TODO: Set as variable
# Try to connect to metrics endpoint up to 10 times with a large timeout (2s) and check if HTTP 200 status is returned
# If command fails, echo the error and ping healthcheck
(curl --retry 10 --connect-timeout 2 -s -D - "http://${BACKUP_SERVER_DOMAIN}:8000/metrics" -o /dev/null 2>/dev/null | head -n1 | grep 200) \
    || (RESULT="$?" && echo "${RESULT}: Failed to start backup server" && curl --retry 3 https://hc-ping.com/"${HEALTHCHECK_ID}"/"${RESULT}")

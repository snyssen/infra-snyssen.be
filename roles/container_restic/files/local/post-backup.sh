#! /bin/sh
curl --retry 3 https://hc-ping.com/"${HEALTHCHECK_ID}"/"$1" # $1 is the status code returned by the restic command
# ssh -i /home/backup/.ssh/backup_rsa -o "StrictHostKeyChecking no" "backup@${BACKUP_SERVER_DOMAIN}" "sudo poweroff"

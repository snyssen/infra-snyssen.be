#! /bin/sh

test_if_up() {
    curl -m 15 -s -D - "http://${BACKUP_SERVER_DOMAIN}:8000/metrics" -o /dev/null 2>/dev/null | head -n1 | grep 200
}

curl --retry 3 https://hc-ping.com/"${HEALTHCHECK_ID}"/start

echo "Waking up ${BACKUP_SERVER_DOMAIN} (mac addr: ${BACKUP_SERVER_MAC_ADDRESS})..."
awake "${BACKUP_SERVER_MAC_ADDRESS}"

# Try to connect to metrics endpoint up to 10 times with a large timeout (30s) and check if HTTP 200 status is returned
# If command fails, echo the error and ping healthcheck
echo "Testing if ${BACKUP_SERVER_DOMAIN} is up..."
RETRY_COUNT=1
while ! test_if_up && [ "${RETRY_COUNT}" -le 10 ]; do
    echo "Attempt ${RETRY_COUNT} failed. Retrying in 30 seconds..."
    RETRY_COUNT=$((RETRY_COUNT+1))
    sleep 30
done

if [ "${RETRY_COUNT}" -ge 10 ]; then
    echo "Failed to connect to ${BACKUP_SERVER_DOMAIN} after ${RETRY_COUNT} attempts. Reporting failure and exiting..."
    curl --retry 3 "https://hc-ping.com/${HEALTHCHECK_ID}/1"
    exit 1;
fi

echo "${BACKUP_SERVER_DOMAIN} ready, commencing backup!"
echo "=================================================="

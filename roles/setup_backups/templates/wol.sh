#! /bin/sh

test_if_up() {
    curl -m 15 -s -D - "http://{{ backups__local_domain }}:8000/metrics" -o /dev/null 2>/dev/null | head -n1 | grep 200
}

echo "Waking up {{ backups__local_domain }} (mac addr: {{ backup_server_mac_address }})..."
wakeonlan "{{ backup_server_mac_address }}"

# Try to connect to metrics endpoint up to 10 times with a large timeout (30s) and check if HTTP 200 status is returned
# If command fails, echo the error and ping healthcheck
echo "Testing if {{ backups__local_domain }} is up..."
RETRY_COUNT=1
while ! test_if_up && [ "${RETRY_COUNT}" -le 10 ]; do
    echo "Attempt ${RETRY_COUNT} failed. Retrying in 30 seconds..."
    RETRY_COUNT=$((RETRY_COUNT+1))
    sleep 30
done

if [ "${RETRY_COUNT}" -ge 10 ]; then
    echo "Failed to connect to {{ backups__local_domain }} after ${RETRY_COUNT} attempts. Reporting failure and exiting..."
    exit 1;
fi

echo "{{ backups__local_domain }} ready!"
echo "=================================================="

#!/usr/bin/env bash

set -xe

# Start ssh daemon
/usr/sbin/sshd -f /etc/ssh/sshd_config

# Initialize ~/.ssh
cat <<< $PUBLIC_KEY > ~/.ssh/authorized_keys

# Setup runpodctl
echo "apiKey = \"$RUNPOD_API_KEY\"" > ~/.runpod/config.toml

# Keep the pod alive
touch .ready
while find . -maxdepth 1 -type f -mmin -$KEEP_ALIVE_MINS | grep -q .; do
    sleep 60;
done

# Remove the pod
runpodctl remove pod $RUNPOD_POD_ID

# Wait for shutdown
sleep inf

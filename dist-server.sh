#!/bin/bash -x

CONFIG_FILE=/etc/sccache.conf
CONFIG_TEMPLATE=/opt/config.toml.tmpl
TAILSCALE_SOCKET=/tmp/tailscaled.sock


get_tailscale_ip() {
    curl --unix-socket $TAILSCALE_SOCKET -H "Host: local-tailscaled.sock" http://localhost/localapi/v0/status | jq .Self.TailscaleIPs[0] -r
}

# export PUBLIC_ADDR=$(get_tailscale_ip)

# # while is "null"

# while [ "$PUBLIC_ADDR" == "null" ]; do
#     echo "Waiting for tailscale to start..."
#     sleep 1
#     export PUBLIC_ADDR=$(get_tailscale_ip)
# done


ip addr show

REQUIRED_ENVS=(
    "SERVER_TOKEN"
    "SCHEDULER_URL"
    "PUBLIC_ADDR"
)

export PUBLIC_ADDR="$PUBLIC_ADDR:10600"
# shellcheck disable=SC2068
for env in ${REQUIRED_ENVS[@]}; do
    if [ -z "${!env}" ]; then
        echo "Missing required environment variable $env"
        exit 1
    fi
done

# We need to somehow get the tailscale IP address of this container

envsubst <$CONFIG_TEMPLATE > $CONFIG_FILE

sccache-dist server --config $CONFIG_FILE

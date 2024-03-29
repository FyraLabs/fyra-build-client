#!/bin/bash -xeu

ZIRCON_SCHEDULER="zircon-scheduler"

echo "Welcome to the Fyra Buildsys Setup script!"

echo "Checking for requirements..."

# check if git repo is up to date
if ! git diff-index --quiet HEAD --; then
    echo "Git repo is not up to date!"
    # pull and run the script again
    git pull
    exec $0
fi

check_tailscale() {
    if ! command -v tailscale &>/dev/null; then
        echo "tailscale could not be found"
        echo "Please install tailscale and try again"
        exit 1
    fi
}

check_tailnet() {
    if ! tailscale ip -4 $ZIRCON_SCHEDULER &>/dev/null; then
        echo "tailscale could not find $ZIRCON_SCHEDULER"
        echo "Please make sure you are connected to the correct tailnet"
        exit 1
    fi
}

check_docker() {
    if ! command -v docker &>/dev/null; then
        echo "docker could not be found"
        echo "Please install docker and try again"
        exit 1
    fi
}

check_docker_compose() {
    # "docker compose" v2
    if ! sh -c "docker compose version" &>/dev/null; then
        echo "docker compose v2 could not be found"
        echo "Please install docker compose v2 and try again"
        exit 1
    fi
}

check() {
    check_tailscale
    check_tailnet
    check_docker
    check_docker_compose
}

check

echo "Requirements met!"

echo "Starting setup..."

# Disable firewalls so it wont cause problems with docker

# sudo systemctl disable --now firewalld || true
# sudo systemctl disable --now ufw || true

SCHEDULER_ADDR=$(tailscale ip -4 $ZIRCON_SCHEDULER)
PUBLIC_ADDR=$(tailscale ip -4)

echo """
SCHEDULER_ADDR=$SCHEDULER_ADDR
PUBLIC_ADDR=$PUBLIC_ADDR
NETNAME=zircon
""" >.env

# check if the compose is running

if docker compose ps | grep -q "builder"; then
    echo "Builder is already running!"
    # Pull and restart

    docker compose pull
    docker compose up -d
else
    echo "Builder is not running, starting it now..."
    docker compose pull
    systemctl disable --now iceccd || true
    docker compose up -d
fi

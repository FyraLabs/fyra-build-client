# Fyra Build Cluster Server

This repository contains an easy to deploy build cluster node.

## Requirements

- A tailnet
- A server with docker installed
- docker-compose
- a fast CPU (optional)

## Getting Started

1. Install Docker and Docker Compose

2. Join the tailnet on the host machine

3. Run `tailscale ip` to get the IP address of the host machine, take note of this IP address, becuase we will be using this as the `PUBLIC_ADDR` environment variable in the next step.

4. Copy `docker-compose.yml.example` from this repo to `docker-compose.yml` and edit it to your needs
5. Run `docker-compose up -d` to start the build cluster node

## Quickstart

```bash
# set these envars please

TS_KEY=<tskey>
COMPOSE_DIR="~/fyra-build-cluster"
SCHEDULER_URL="http://scheduler"
SERVER_TOKEN="super-secret-token"

tailscale up --authkey $TS_KEY

PUBLIC_ADDR=$(tailscale ip -4)

mkdir -p $COMPOSE_DIR

pushd $COMPOSE_DIR

curl https://github.com/FyraLabs/fyra-build-client/raw/main/docker-compose.yml.example -o docker-compose.yml

echo "PUBLIC_ADDR=$PUBLIC_ADDR" >> .env
echo "SCHEDULER_URL=$SCHEDULER_URL" >> .env
echo "SERVER_TOKEN=$SERVER_TOKEN" >> .env

nano docker-compose.yml

docker compose up -d
```

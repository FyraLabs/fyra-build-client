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

3. Clone this repository

4. Run `./update.sh` script to simply add your node to the cluster!

## Updating

Run `./update.sh` script to update your node to the latest version!

The compose file also has [watchtower](https://containrrr.dev/watchtower/) enabled, for automatic updates.

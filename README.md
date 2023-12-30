# Fyra Build Cluster Server

This repository contains an easy to deploy build cluster node.

## Requirements

- A tailnet
- A server with docker installed
- docker-compose
- a fast CPU (optional)

## Getting Started

1. Install Docker and Docker Compose

2. Set up a tailnet where the sccache cluster will run

3. Set up a sccache-dist server

4. Create a Docker Compose file, see example in [docker-compose.yml](docker-compose.yml.example)

5. Run `docker-compose up -d`

6. Set up your build system to use the sccache cluster

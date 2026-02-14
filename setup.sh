#!/usr/bin/env bash
set -e
export HOST_UID=$(id -u)
export HOST_GID=$(id -g)
mkdir -p ../MarvinOS_Data
docker compose run --rm configure_env
docker compose up -d
docker compose logs -f
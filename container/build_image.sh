#!/usr/bin/env sh

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
podman build \
    -t apollo-forge-base \
    --build-arg UID="$(id -u)" \
    --build-arg GID="$(id -g)" \
    "$BASE_DIR"

#!/usr/bin/env sh

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
podman build -t apollo-env-base "$BASE_DIR"

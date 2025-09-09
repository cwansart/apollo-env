#!/usr/bin/env sh

set -e

ROOT_DIR="$(cd $(dirname "$0") && pwd)"
PACKAGES_DIR="$ROOT_DIR/packages"
TARGET_DIR="$ROOT_DIR/rootfs"

if [ -z "$1" ]; then
    echo "Usage: $0 <project-name>"
    exit 1
fi

PACKAGE_PATH="$1"
PACKAGE_SCRIPT="$PACKAGES_DIR/$PACKAGE_PATH.sh"

shift
BUILD_ARGS="$@"

if [ ! -f "$PACKAGE_SCRIPT" ]; then
    echo "Error: Build script '$PACKAGE_SCRIPT' does not exist"
    exit 1
fi

echo "Start build container for $PACKAGE_PATH"
podman run -it --rm \
    -v "$TARGET_DIR":/apollo:U \
    -v "$PACKAGES_DIR":/packages:ro \
    apollo-forge-base \
    "/packages/$PACKAGE_PATH.sh" "$BUILD_ARGS"


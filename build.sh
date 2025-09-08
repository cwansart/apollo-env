#!/usr/bin/env sh

set -e

ROOT_DIR="$(cd $(dirname "$0") && pwd)"
PACKAGES_DIR="$ROOT_DIR/packages"
TARGET_DIR="$ROOT_DIR/rootfs"

if [ -z "$1" ]; then
    echo "Usage: $0 <project-name>"
    exit 1
fi

PACKAGE_NAME="$1"
PACKAGE_SCRIPT="$PACKAGES_DIR/$PROJECT_NAME.sh"

shift
BUILD_ARGS="$@"

if [ ! -e "$PACKAGE_SCRIPT" ]; then
    echo "Error: Build script '$PROJECT_NAME' does not exist in '$PACKAGES_DIR'."
    exit 1
fi

mkdir -p "$ROOTFS_DIR/src"

podman run -it --rm \
    -v "$ROOTFS_DIR":/apollo:U \
    -v "$PACKAGE_SCRIPT":/apollo/build.sh:ro \
    apollo-forge-base /apollo/build.sh "$BUILD_ARGS"


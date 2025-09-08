#!/usr/bin/env sh

set -e

ROOT_DIR="$(cd $(dirname "$0")/.. && pwd)"
ROOTFS_DIR="$ROOT_DIR/rootfs/"

if [ "$1" = "--clean" ]; then
    echo "Cleaning rootfs"
    rm -rf "$ROOTFS_DIR"
    
fi

if ! command -v podman > /dev/null 2>&1; then
    echo "Error: podman is not installed."
    exit 1
fi


mkdir -p "$ROOTFS_DIR"

echo "Build base image"
$ROOT_DIR/container/build.sh

echo "Start bootstrapping for base"
$ROOT_DIR/build.sh binutils
$ROOT_DIR/build.sh gcc-pass1
$ROOT_DIR/build.sh glibc
$ROOT_DIR/build.sh gcc-pass2

echo "Building base system done"


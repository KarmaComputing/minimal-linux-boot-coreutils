#!/bin/bash

set -exu

# We will
#
# - Empty ./build-dir (to build from scratch)
# - Build linux kernel
# - Build busybox
# - Build musl
# - Build openssh statically (using musl)
# - iproute2 is built into busybox

SCRIPT_START_DIR=$PWD
BUILD_DIR=$(realpath -s ./build-dir)
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"/build-artifacts
BUILD_ARTIFACTS_DIR="$BUILD_DIR"/build-artifacts

cd "$BUILD_DIR"

# Build linux kernel
BUILD_ARTIFACTS_DIR=$BUILD_ARTIFACTS_DIR ../build-kernel.sh

cd "$BUILD_DIR"
# Build busybox
BUILD_ARTIFACTS_DIR=$BUILD_ARTIFACTS_DIR ../build-busybox.sh

# Build musl
../build-musl.sh
cd "$BUILD_DIR"

# Build openssh
BUILD_ARTIFACTS_DIR=$BUILD_ARTIFACTS_DIR ../build-openssh-statically.sh
cd "$BUILD_DIR"

cd "$SCRIPT_START_DIR"

./create-scratch-space.sh
./build-rootfs.sh

echo If all is wel, you\'re now good to run the vm in qemu
echo see ./run-qemu.sh

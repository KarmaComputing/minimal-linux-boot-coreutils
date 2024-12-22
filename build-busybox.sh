#!/bin/bash

set -eux

INITAL_WORKING_DIR=$PWD

git clone git://git.busybox.net/busybox

cd busybox
git checkout 1_37_0
make defconfig
echo CONFIG_STATIC=y >> .config
sed -i 's/CONFIG_TC=y/# CONFIG_TC is not set/g' .config
make -j$(nproc)

mkdir "$BUILD_ARTIFACTS_DIR"/busybox
cp ./busybox "$BUILD_ARTIFACTS_DIR"/busybox

cd $INITAL_WORKING_DIR

#!/bin/bash

set -eux

INITAL_WORKING_DIR=$PWD

mkdir linux-kernel
cd linux-kernel
wget https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.9.tar.xz

tar xf linux-6.9.tar.xz
cd linux-6.9
mkdir -p $BUILD_ARTIFACTS_DIR/linux-kernel
make defconfig
make -j$(nproc)
cp ./arch/x86_64/boot/bzImage $BUILD_ARTIFACTS_DIR/linux-kernel


cd $INITAL_WORKING_DIR

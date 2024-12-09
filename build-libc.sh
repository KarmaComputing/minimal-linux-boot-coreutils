#!/bin/bash

set -xu

SCRATCH_SPACE_DIR=$1

INITAL_WORKING_DIR=$PWD

git clone https://sourceware.org/git/glibc.git
cd glibc
git checkout release/2.40/master
mkdir glibc-build
cd glibc-build
mkdir out
../configure --prefix=$(pwd)/out
make
make install

# Copy built libc objects/files over into scratch space
cp -r -n ./out/* $SCRATCH_SPACE_DIR

cd $INITAL_WORKING_DIR

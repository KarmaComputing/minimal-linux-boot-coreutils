#!/bin/bash

set -x

INITAL_WORKING_DIR=$PWD

cd coreutils
git checkout v9.5
./bootstrap
./configure LDFLAGS="-static"
make 
find src/ -executable -maxdepth 1


cd $INITAL_WORKING_DIR

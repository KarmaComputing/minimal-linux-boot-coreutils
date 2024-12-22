#!/bin/bash
# Via https://wiki.musl-libc.org/getting-started.html

set -xu

INITAL_WORKING_DIR=$PWD

git clone git://git.musl-libc.org/musl
cd musl/
git checkout v1.2.5
./configure --prefix=$HOME/musl --exec-prefix=$HOME/bin --syslibdir=$HOME/musl/lib --disable-shared

make
make install


cd $INITAL_WORKING_DIR

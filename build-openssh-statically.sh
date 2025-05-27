#!/bin/bash

set -eux

echo $BUILD_ARTIFACTS_DIR

# 1. clone openssh-portable
rm -rf openssh-portable
git clone https://github.com/openssh/openssh-portable
cd openssh-portable
git checkout V_9_9_P1
autoconf

# Note this uses only the **experimental** internal (reduced) cryp algos
# built-into openssh. TODO actuall include libcrypto
CC="musl-gcc -static" ./configure --prefix=/usr/bin --sysconfdir=/etc/ssh --without-zlib --without-openssl
make -j$(nproc)

# Copy over openssh binaries to build artifacts dir
mkdir -p $BUILD_ARTIFACTS_DIR/openssh

echo $PWD

for sshUtility in $(find ./ -maxdepth 1 -type f -executable | grep -E -v '(\.sh|\.in|\.rc|\.sub|\.sample|\.status|\.guess|configure|fixpaths|install-sh|mkinstalldirs|fixalgorithms)'); do
    echo Copying over "$sshUtility"
      cp "$sshUtility" $BUILD_ARTIFACTS_DIR/openssh
    done

cp $(find ./ -name sshd_config) $BUILD_ARTIFACTS_DIR/openssh


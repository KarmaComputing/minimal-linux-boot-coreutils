#!/bin/bash

set -eux
INITAL_WORKING_DIR=$PWD
SCRATCH_DIR=./scratch-space
BUILD_ARTIFACTS_FOLDER=../build-dir/build-artifacts

rm -rf "$SCRATCH_DIR"
mkdir "$SCRATCH_DIR"

cd $SCRATCH_DIR


mkdir bin dev proc sys etc root usr var
mkdir -p usr/bin/libexec # (sshd-session by (default?) compiles into /usr/bin/libexec
mkdir -p etc/ssh
mkdir -p var/run # (otherwise sshd cannot write its pid file)

# Crate users/groups

echo 'root:x:0:' > ./etc/group

# Copy over busybox
cp "$BUILD_ARTIFACTS_FOLDER"/busybox/busybox ./bin
cd ./bin
for utility in $(./busybox --list); do
  ln -s ./busybox ./$utility
done
cd -

# ssh/sshd etc bootstraping

# Copy over default sshd_config config
cp "$BUILD_ARTIFACTS_FOLDER"/openssh/sshd_config ./etc/ssh/sshd_config

for sshUtility in $(find "$BUILD_ARTIFACTS_FOLDER"/openssh -maxdepth 1 -type f -executable | grep -E -v '(\.sh|\.in|\.rc|\.sub|\.sample|\.status|\.guess|configure|fixpaths|install-sh|mkinstalldirs|fixalgorithms)'); do

  echo Copying over "$sshUtility"
  cp "$sshUtility" ./usr/bin
done
 mv ./usr/bin/sshd-session ./usr/bin/libexec

# Bootstrap ssh users/config setup

cd - && cd ../
echo $PWD

# Layout minimal user accounts
echo 'root:x:0:0:root:/root:/bin/sh' > ./etc/passwd
# Without sshd user, you get 'Privilege separation user sshd does not exist'
echo 'sshd:x:128:65534::/run/sshd:/usr/sbin/nologin' >> ./etc/passwd

echo 'root:*:19216:0:99999:7:::' > ./etc/shadow

echo 'echo 'root:x:0:' > ./etc/groups'
mkdir var/empty  # TODO Missing privilege separation directory: /var/empty (sshd wants it)
# NOTE ownership of /var/empty is altered during init


# TODO generate host keys (ssh-keygen -A)

cd $INITAL_WORKING_DIR

./create-init.sh

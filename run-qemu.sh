#!/bin/bash

set -eux

qemu-system-x86_64 -kernel vmlinuz-lts -initrd rootfs.cpio.gz --append "init=/usr/bin/init"

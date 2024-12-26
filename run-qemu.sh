#!/bin/bash

set -eux

qemu-system-x86_64 -enable-kvm -kernel ./build-dir/linux-kernel/linux-6.9/arch/x86/boot/bzImage -initrd rootfs.cpio.gz --append "console=ttyS0 init=/init ip=192.168.10.2:192.168.10.1:192.168.10.1:255.255.255.0::eth0:off" -nographic \
  -netdev tap,id=net0,ifname=tap-ssh-node-0,script=no,downscript=no\
  -device e1000,netdev=net0

# -icount 10,align=on

# Example: Record the output terminal of the bootup:
# timeout --preserve-status 20 script -c ./run-qemu.sh output.log

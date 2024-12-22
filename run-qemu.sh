#!/bin/bash

set -eux

qemu-system-x86_64 -kernel ./build-dir/linux-kernel/linux-6.9/arch/x86/boot/bzImage -initrd rootfs.cpio.gz --append "console=ttyS0 init=/init" -nographic # -icount 10,align=on

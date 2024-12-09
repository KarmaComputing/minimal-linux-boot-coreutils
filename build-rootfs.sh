#!/bin/bash

set -eux

cd scratch-space

find . | cpio -o -H newc | gzip > ../rootfs.cpio.gz

cd -

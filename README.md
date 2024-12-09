# Minimal boot linux coreutils bash glibc

![qemu showing boot into minimal linux](./img/boot-qemu-example.png)

Goal is to have mimimal but realistic node with network capabilities build in (`ip`) and bootstrapped (similar to [alpine's netbot](https://boot.alpinelinux.org/) ([example](https://github.com/KarmaComputing/server-bootstrap/blob/494089caa2c88bbf37a739aa96561231d5847be5/.github/workflows/build-alpine-netboot-image-zfs.yml#L1))). [Clearlinux](https://github.com/clearlinux/distribution) is interesting. This is using glibc over musl (which alpine uses).


## The process in a nutshell

- Given a built linux kernel (e.g. `vmlinuz-lts`)
- Clone and build all the various packages you want
- Write an `init` script
- Build all the binaries + `init` script into a initramfs
- Run/boot with qemu



TODO: add [iproute2](https://github.com/iproute2/iproute2) for minimal routing.

## Things you need to build

- git clone & build GNU `bash` is in it's own repo
- git clone & build coreutils (`ls` , `date` , `touch` etc(`mount` is not in here- who knew)
- To get `mount` you need to build util-linux https://en.wikipedia.org/wiki/Util-linux
- is `ls` failing, did you forget to include `/usr/lib/x86_64-linux-gnu/libcap.so.2`? See `mkchroot.sh` helper from https://landley.net/writing/rootfs-programming.html

- Don't forget to `mount` linux virtual filesystems (oh wait, did you forget to build util-linux into your init?

Example built rootfs:
```
ls -lh rootfs.cpio.gz 
-rw-rw-r-- 1 chris chris 16M Dec  8 23:40 rootfs.cpio.gz
```

# What does this repo not include (yet)

- Full clone/compile instructions
- Automated ci

### How do I build statically coreutils, do I even need to?

See https://lists.gnu.org/archive/html/coreutils/2019-04/msg00001.html

## `ls` , `cat` and `date` etc won't run without libc!

git clone https://sourceware.org/git/glibc.git

# Reading
See also

https://wiki.gentoo.org/wiki/Custom_Initramfs
https://unix.stackexchange.com/a/305406
https://landley.net/writing/rootfs-howto.html
https://landley.net/writing/rootfs-programming.html

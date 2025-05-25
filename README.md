# Minimal build & boot linux kernel + coreutils (via busybox), openssh & iputils

![qemu showing boot into minimal linux](./img/boot-qemu-example.png)

Goal is to have mimimal but realistic node with network capabilities build in (`ip`) and bootstrapped (similar to [alpine's netbot](https://boot.alpinelinux.org/) ([example](https://github.com/KarmaComputing/server-bootstrap/blob/494089caa2c88bbf37a739aa96561231d5847be5/.github/workflows/build-alpine-netboot-image-zfs.yml#L1))). [Clearlinux](https://github.com/clearlinux/distribution) is interesting. This is using musl (which alpine uses) rather than glibc to support staticaly built binaries more easily.


## The process in a nutshell

- Given a built linux kernel (e.g. `vmlinuz-lts`)
- Clone and build all the various packages you want
- Write an `init` script
- Build all the binaries + `init` script into a initramfs
- Run/boot with qemu
- Rememebr busybox needs to be static build (see .config)
  - <strike>dropbear needs at least a `dropbear_rsa_host_key` key config or will not start see [gist](https://gist.github.com/mad4j/7983719) </strike>
  - Prefering openssh for end user compatability (statically built)

### How do I extract an `initramfs` / `initrd` gz cpio archive, view it's `init` script and repackage?

> Situation: How do I make a change to the `init` script without going through the whole process of re-building? I've built `initramfs` using [`build-all.sh`](https://github.com/KarmaComputing/minimal-linux-boot-coreutils/blob/c64027b54b12d488f83cef75b5fbfee3d444e661/build-all.sh#L1) but I want to make a quick change to the `init` script (generated in [`create-init.sh`](https://github.com/KarmaComputing/minimal-linux-boot-coreutils/blob/c64027b54b12d488f83cef75b5fbfee3d444e661/create-init.sh#L1), called by [create-scratch-space](https://github.com/KarmaComputing/minimal-linux-boot-coreutils/blob/c64027b54b12d488f83cef75b5fbfee3d444e661/create-scratch-space.sh#L71).

For a faster feedback loop, sometimes you want to speed up debugging your `rootfs.cpio.gz` init script which is inside your (initramfs / initrd) image- which is typically a gzipped, `cpio` archive. The bootloader extracts and loads this `initramfs` / `initrd` filesystem, calling your `init` script first. In this repo example, we [pass](https://github.com/KarmaComputing/minimal-linux-boot-coreutils/blob/c64027b54b12d488f83cef75b5fbfee3d444e661/run-qemu.sh#L5C144-L5C154) `init=/init` to the kernel args. During boot the `init` file
(which is stored in the root (`/`) of the `initramfs` image, is ran first. Distributions can use this to perform initial setup, such as ensuring
a minimal valid linux directory structure (`/dev`, `proc` etc) and handle other boot-time kernel arguments such as `ip=` to set boot time network ip addressing.

To play around quicky with an already *built* `initramfs` / `initrd` image (for reference, [here's where we _build_ the initramfs image](https://github.com/KarmaComputing/minimal-linux-boot-coreutils/blob/c64027b54b12d488f83cef75b5fbfee3d444e661/build-rootfs.sh#L7)). But building a brand new image etc takes time, for instance, we [compile `busybox` and `openssh`](https://github.com/KarmaComputing/minimal-linux-boot-coreutils/blob/c64027b54b12d488f83cef75b5fbfee3d444e661/build-all.sh#L26-L35) into our`initramfs`. 

To extract the end product (`rootfs.cpio.gz`) you can do the following:
Goal: Extract `rootfs.cpio.gz` `initramfs` file into a specified directory without clobbering my actual system's paths (remember `initramfs` contains a full system directory layout with `/usr`, `/dev` , `/bin` etc- you don't want to overrite your laptop's system files!):
```
mkdir out;
zcat initramfs-lts | cpio -D ./out -idmv --no-absolute-filenames;
ls -l rootfs.cpio.gz
```
Above, you'll not be able to inspect the contents of your built `initramfs`. Take a look at your init script!
```
less out/init
```
Perhaps you want to make a change (such as add an `echo` or debug statement to your `init` script.

#### How to I repack my `initramfs`?

We've come full circle, taking inspiration from [build-rootfs.sh](https://github.com/KarmaComputing/minimal-linux-boot-coreutils/blob/c64027b54b12d488f83cef75b5fbfee3d444e661/build-rootfs.sh#L7) we can re-backage our extracted `initramfs` using `cpio` and `gzip` over our `out` folder:

```
cd out # make sure you're in your extracted initramfs folder
find . | cpio -o -H newc | gzip > ../my-new-rootfs.cpio.gz
```

You then might want to re-run your `qemu` debugging process: See [](https://github.com/KarmaComputing/minimal-linux-boot-coreutils/blob/c64027b54b12d488f83cef75b5fbfee3d444e661/run-qemu.sh#L5)- remembering to change the `-initrd rootfs.cpio.gz` argument.

<strike>TODO: add [iproute2](https://github.com/iproute2/iproute2) for minimal routing.</strike>

## Things you need to build

See [./build-all.sh](./build-all.sh)

# What does this repo not include (yet)

- Automated ci

<strike>### How do I build statically coreutils, do I even need to?

See https://lists.gnu.org/archive/html/coreutils/2019-04/msg00001.html </strike> switched to using `musl`.


# Reading
See also

https://wiki.gentoo.org/wiki/Custom_Initramfs
https://unix.stackexchange.com/a/305406
https://landley.net/writing/rootfs-howto.html
https://landley.net/writing/rootfs-programming.html
- https://unix.stackexchange.com/questions/193066/how-to-unlock-account-for-public-key-ssh-authorization-but-not-for-password-aut
- https://stackoverflow.com/a/79151188
- https://z49x2vmq.github.io/2020/12/24/linux-tiny-qemu/

> "Stuff like this is slowly becoming a lost art" [src](https://www.linuxquestions.org/questions/linux-general-1/bin-bash-as-primary-init-4175543547/#post5367386) ooopse.


TODO: kernel inital ram disk support https://stackoverflow.com/questions/14430551/qemu-boot-error-swapper-used-greatest-stack-depth
TODO READ: https://bbs.archlinux.org/viewtopic.php?pid=1378903#p1378903

## Notes

> "busybox qemu /bin/sh: can't access tty; job control turned off"
> https://github.com/brgl/busybox/blob/master/shell/cttyhack.c

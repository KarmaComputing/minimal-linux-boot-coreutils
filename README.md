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



TODO: add [iproute2](https://github.com/iproute2/iproute2) for minimal routing.

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

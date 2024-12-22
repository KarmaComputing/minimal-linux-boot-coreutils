#!/bin/sh

set -eux

INIT_FILE_PATH=scratch-space/init

echo "#!/bin/busybox sh" > $INIT_FILE_PATH
echo 'echo YOLOOooooooooooooooooooooooooooo' >> $INIT_FILE_PATH
echo 'echo YOLOOooooooooooooooooooooooooooo' >> $INIT_FILE_PATH
echo 'echo YOLOOooooooooooooooooooooooooooo' >> $INIT_FILE_PATH
echo 'echo YOLOOooooooooooooooooooooooooooo' >> $INIT_FILE_PATH
echo 'echo YOLOOooooooooooooooooooooooooooo' >> $INIT_FILE_PATH
echo 'mount -t sysfs sysfs /sys' >> $INIT_FILE_PATH
echo 'mount -t proc proc /proc' >> $INIT_FILE_PATH
# (sshd needs openpty: No such file or directory )
echo 'mount -t devtmpfs udev /dev' >> $INIT_FILE_PATH
echo 'mkdir /dev/pts' >> $INIT_FILE_PATH
echo 'mount -t devpts devpts /dev/pts' >> $INIT_FILE_PATH
echo 'sysctl -w kernel.printk="2 4 1 7"' >> $INIT_FILE_PATH
echo 'chown -R root:root /var/empty' >> $INIT_FILE_PATH
echo 'chmod -R 400 /var/empty' >> $INIT_FILE_PATH

echo 'echo Bringing up loopback interface' >> $INIT_FILE_PATH
echo 'ip link set lo up' >> $INIT_FILE_PATH
echo 'ip addr show lo' >> $INIT_FILE_PATH

echo 'echo Generating ssh host keys' >> $INIT_FILE_PATH
echo 'ssh-keygen -A' >> $INIT_FILE_PATH
echo 'ls -l /etc/ssh' >> $INIT_FILE_PATH

echo 'echo Starting sshd' >> $INIT_FILE_PATH
echo '/usr/bin/sshd -E ssh_log' >> $INIT_FILE_PATH

# Curious? See https://github.com/brgl/busybox/blob/master/shell/cttyhack.c
echo 'setsid cttyhack /bin/sh' >> $INIT_FILE_PATH

chmod +x $INIT_FILE_PATH


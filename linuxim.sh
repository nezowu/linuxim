#!/system/bin/sh
#name_script=linuxim

export MNT=/data/local/tmp/linux
export HOME=/root
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/system/bin:/system/xbin
export TERM=linux
export USER=root
export LD_PRELOAD=''
export LD_LIBRARY_PATH=''

if [ ! -d "$MNT" ]; then
	mkdir -p /data/local/tmp/linux
fi

mount -o loop -t ext4 /storage/sdcard1/debian.img $MNT
mount -t proc   proc    $MNT/proc
mount -t sysfs  sysfs   $MNT/sys
#mount -o bind /dev $MNT/dev
mount -t devpts devpts  $MNT/dev/pts
mount -o bind /sdcard $MNT/sdcard
busybox sysctl -w net.ipv4.ip_forward=1

chroot $MNT /bin/bash -l
for pid in `busybox lsof | busybox grep $mnt | busybox sed -e's/  / /g' | busybox cut -d' ' -f2`; do busybox kill -9 $pid >/dev/null 2>&1; done
sleep 5
umount $MNT/dev/pts
#umount $MNt/dev
umount $MNT/sys
umount $MNT/proc
umount $MNT/sdcard
umount $MNT

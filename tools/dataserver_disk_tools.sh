# This is tool for dataservers partition, mount.
# Author: Jing Yu, Siang Jin

#!/bin/bash
#Create the disk mount directory.
seq -f"disk%02g" 0 23 | xargs -i mkdir -p /data/{}
echo "#Mount disk" >> /etc/fstab
# fdisk ,formating and create the file system
fdisk_fun() {
fdisk  $1 << EOF
g
w
EOF
sleep 1
mkfs.ext4 ${1} << EOF
y
EOF
sleep 5
}
j=0
echo which disk is the os using?
read os_disk
 for i in `fdisk -l | grep "Disk" | grep "/dev" | awk '{print $2}' | awk -F: '{print $1}' | grep "sd" |grep -v $os_disk |sort -n `
    do
        fdisk_fun $i
#    do fdisk_fun $i > /dev/null 2>&1
        D_UUID=`blkid | grep $i | awk -F \" '{print $2}'`
        echo "/dev/disk/by-uuid/$D_UUID  /data/disk$j     ext4 defaults 0 0 " >> /etc/fstab
        j=$(($j+1))
done

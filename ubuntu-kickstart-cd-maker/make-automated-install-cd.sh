#!/bin/bash

# edit these 3 variables if you want to try another distro. create an md5sum
# file with something like 
#   md5sum $ISO > $ISO.MD5SUM

ISO=ubuntu-16.04.5-server-amd64.iso
OUTPUT=autoinstall-ubuntu-16.04.5-server-amd64.iso
URL=http://releases.ubuntu.com/16.04/ubuntu-16.04.5-server-amd64.iso
TXT_CFG=txt.cfg

# ISO=ubuntu-18.04.1-server-amd64.iso
# OUTPUT=autoinstall-ubuntu-18.04.1-server-amd64.iso
# URL=http://cdimage.ubuntu.com/ubuntu/releases/18.04/release/ubuntu-18.04.1-server-amd64.iso
# TXT_CFG=txt.cfg

MOUNT=iso-mount-dir
WORK=iso-work-dir

# if we don't have iso or it doesnt' match md5sum, fetch it
if [ ! -f $ISO ]  || !  md5sum -c $ISO.MD5SUM 
then
    rm -f $ISO
	wget $URL
    # if we still don't gots it, die
    if [ ! -f $ISO ]  || !  md5sum -c $ISO.MD5SUM 
    then
        echo "Could not download iso?"
        exit 1
    fi
fi

# clean up after interruptted runs.  if this fails, it's because the mount
# point is still mounted, so manually unmount please.
rm -rf $MOUNT $WORK

# make mount point, mount it with sudo, copy over contents because ISO's
# can only be mounted readonly
mkdir -p $MOUNT $WORK
sudo mount -o ro,loop $ISO $MOUNT
cp -rT $MOUNT $WORK
chmod -R a+w $WORK

# copy files over to image
cp ks.cfg $WORK/
cp $TXT_CFG $WORK/isolinux/txt.cfg
cp isolinux.cfg $WORK/isolinux/

echo 'd-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true' > $WORK/preseed/ubuntu-server.seed

# magic mkiso incantation
mkisofs -D -r -V “AUTOINSTALL” -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o $OUTPUT $WORK

# clean up after ourselves
sudo umount $MOUNT
rm -rf $MOUNT $WORK


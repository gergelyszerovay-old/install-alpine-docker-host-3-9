#!/bin/sh
cp -f ./repositories /etc/apk/repositories

apk update
apk upgrade

apk add mc virtualbox-guest-additions virtualbox-guest-modules-virt docker py-pip samba findmnt

# docker install
pip install docker-compose
rc-update add docker boot
mkdir /etc/docker/
cp -f ./daemon.json /etc/docker/daemon.json

# add Linux user
(echo user; echo user) | adduser -u 1000 user

# create mount dirs
mkdir /mnt/docker-persistent-volumes
mkdir /mnt/docker
mkdir /mnt/virtualbox-shared-folder

cat ./fstab >> /etc/fstab

mount /dev/sdb
mount /dev/sdc

mkdir /mnt/docker-persistent-volumes/user
chown user:user /mnt/docker-persistent-volumes/user

# samba
cp -f ./smb.conf /etc/samba/smb.conf
(echo user; echo user) | smbpasswd -a user
rc-update add samba
rc-service samba start

# docker start
rc-service docker start

# clean up
rm -f /var/cache/apk/*


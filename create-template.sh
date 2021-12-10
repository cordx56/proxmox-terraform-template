#!/bin/bash -eux

IMAGE=${IMAGE:-"https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"}
NAME=${NAME:-"ubuntu-server-focal"}
VM_ID=${VM_ID:-"9000"}
STORAGE=${STORAGE:-"local-btrfs"}

wget $IMAGE
sudo qm create $VM_ID --name $NAME
sudo qm importdisk $VM_ID $(basename $IMAGE) $STORAGE
sudo qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 ${STORAGE}:${VM_ID}/vm-${VM_ID}-disk-0.raw
sudo qm set $VM_ID --ide2 $STORAGE:cloudinit
sudo qm set $VM_ID --serial0 socket --vga serial0
sudo qm template $VM_ID

#!/bin/bash

qm list | grep 9000 > /dev/null
if [[ $? -eq 0 ]]; then
    exit 0
else
    wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img \
    && qm create 9000 --memory 2048 --net0 virtio,bridge=vmbr0 \
    && qm importdisk 9000 focal-server-cloudimg-amd64.img ceph-storage \
    && qm set 9000 --scsihw virtio-scsi-pci --scsi0 ceph-storage:vm-9000-disk-0 \
    && qm set 9000 --ide2 ceph-storage:cloudinit \
    && qm set 9000 --boot c --bootdisk scsi0 \
    && qm set 9000 --serial0 socket --vga serial0 \
    && qm set 9000 --name ci-ubuntu-template \
    && qm template 9000
fi

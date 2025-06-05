#!/bin/bash

set -e

DISK="/dev/nvme0n1"
PART="${DISK}p6"

# 파티션 생성 (type: 8e00 - Linux LVM)
sgdisk -n 6:0:0 -t 6:8e00 "$DISK"

# 새 파티션 인식
partprobe "$DISK"

# 약간의 대기 (디바이스 등장 기다림)
sleep 2

# PV, VG, LV 확장
pvcreate "$PART"
vgextend rootvg "$PART"
lvextend -l +80%FREE /dev/mapper/rootvg-rootlv
xfs_growfs /

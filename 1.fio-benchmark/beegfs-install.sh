#!/bin/bash
#
# this script requires docker to be install

INTERFACE_NAME=$1
DISK_PATH=$2
DISK_MOUNT_PATH=/mnt/beegfs-server

mkdir -p $DISK_MOUNT_PATH
yes|mkfs.ext4 $DISK_PATH
mount $DISK_PATH $DISK_MOUNT_PATH

if [[ $? -ne 0 ]]; then
  echo "couldn't mount the disk"
  exit 1
fi

export beegfs_connInterfacesList=$INTERFACE_NAME
export beegfs_sysMgmtdHost=`ip a | grep $INTERFACE_NAME | grep inet | head -n1 | awk '{print$2}' | cut -d '/' -f1`

docker run \
  --name="beegfs-mgmtd" \
  --privileged \
  --network="host" \
  --volume=mgmtd:/mnt/mgmt_tgt_mgmt01 \
  --env beegfs_setup_1="beegfs-setup-mgmtd -p /mnt/mgmt_tgt_mgmt01 -C -S mgmt_tgt_mgmt01" \
  -d beegfs/beegfs-mgmtd:latest \
  storeAllowFirstRunInit=false \
  connDisableAuthentication=true \
  connInterfacesList=$beegfs_connInterfacesList \
  storeMgmtdDirectory=/mnt/mgmt_tgt_mgmt01

docker run \
  --name="beegfs-meta" \
  --privileged \
  --network="host" \
  --volume=meta01:/mnt/meta_01_tgt_0101 \
  --env beegfs_setup_1="beegfs-setup-meta -C -p /mnt/meta_01_tgt_0101 -s 1 -S meta_01" \
  -d beegfs/beegfs-meta:latest \
  sysMgmtdHost=$beegfs_sysMgmtdHost \
  storeAllowFirstRunInit=false \
  connDisableAuthentication=true \
  connInterfacesList=$beegfs_connInterfacesList \
  storeMetaDirectory=/mnt/meta_01_tgt_0101

docker run \
  --name="beegfs-storage" \
  --privileged --network="host" \
  --volume="${DISK_MOUNT_PATH}/stor_01_tgt_101:/mnt/stor_01_tgt_101" \
  --env beegfs_setup_1="beegfs-setup-storage -C -p /mnt/stor_01_tgt_101 -s 1 -S stor_01_tgt_101 -i 101" \
  -d beegfs/beegfs-storage:latest \
  sysMgmtdHost=$beegfs_sysMgmtdHost \
  storeAllowFirstRunInit=false connDisableAuthentication=true \
  connInterfacesList=$beegfs_connInterfacesList \
  storeStorageDirectory=/mnt/stor_01_tgt_101

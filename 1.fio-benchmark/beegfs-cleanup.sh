#!/bin/bash

DISK_MOUNT_PATH=/mnt/beegfs-server

docker stop `docker ps -a --format '{{.Names}}' | grep beegfs`
docker rm `docker ps -a --format '{{.Names}}' | grep beegfs`
docker volume rm `docker volume ls --format '{{.Name}}' | grep beegfs`
umount $DISK_MOUNT_PATH || true

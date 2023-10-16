#! /bin/bash

PFS_NAME=$1
DISK=$2
REPEAT=$3
TARGET_FILE=$4

mkdir -p out
cd out
for i in `seq 1 $REPEAT`
do 
  ./fio.sh ${PFS_NAME}-${DISK}-${i} $TARGET_FILE
done

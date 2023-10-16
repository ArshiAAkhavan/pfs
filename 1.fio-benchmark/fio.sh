#! /bin/bash

BENCH_NAME=$1
FILE_PATH=$2

fio --filename=$FILE_PATH --direct=1 --rw=read --bs=4M --ioengine=libaio --iodepth=8 --numjobs=1 --size=20G --group_reporting --name=iops_test_job --eta-newline=1 --output=$BENCH_NAME-sequential-read.txt

fio --filename=$FILE_PATH --direct=1 --rw=write --bs=4M --ioengine=libaio --iodepth=8 --numjobs=1 --size=20G --group_reporting --name=iops_test_job --eta-newline=1 --output=$BENCH_NAME-sequential-write.txt

fio --filename=$FILE_PATH --random_distribution=zipf:1.2 --direct=1 --rw=randread --io_size=1G --bs=4K --ioengine=libaio --iodepth=16 --numjobs=16 --size=20G --group_reporting --name=iops_test_job --eta-newline=1 --output=$BENCH_NAME-random-read.txt

fio --filename=$FILE_PATH --random_distribution=zipf:1.2 --direct=1 --rw=randwrite --io_size=1G --bs=4K --ioengine=libaio --iodepth=16 --numjobs=16 --size=20G --group_reporting --name=iops_test_job --eta-newline=1 --output=$BENCH_NAME-random-write.txt

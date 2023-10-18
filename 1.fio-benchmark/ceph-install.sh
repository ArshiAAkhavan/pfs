#!/bin/bash

MON_IP=$1

cat << EOF > intial-ceph.conf 
[global]
osd crush chooseleaf type = 0
osd pool default size = 1
EOF

cephadm bootstrap --single-host-defaults --config initial-ceph.conf --mon-ip $MON_IP


echo "please go to https://$MON_IP:8443 and register host"

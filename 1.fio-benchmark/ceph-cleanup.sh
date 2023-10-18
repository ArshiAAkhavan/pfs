#!/bin/bash

ceph mgr module disable cephadm
cephadm rm-cluster --force --zap-osds --fsid $(ceph fsid)

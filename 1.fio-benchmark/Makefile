beegfs-server: DISK_PATH INTERFACE_NAME beegfs-cleanup
	./beegfs-install.sh $(INTERFACE_NAME) $(DISK_PATH)

beegfs-cleanup:
	./beegfs-cleanup.sh

/mnt/beegfs/f20g:
	systemctl restart beegfs-client
	dd if=/dev/urandom of=/mnt/beegfs/f20g bs=10M count=2000

beegfs-bench: DISK_NAME /mnt/beegfs/f20g 
	./repeat-bench.sh beegfs $(DISK_NAME) 20 /mnt/beegfs/f20g


ceph-server: MON_IP
	./ceph-install.sh $(MON_IP)

ceph-mount-fs: DISK_PATH
	wipefs -a $(DISK_PATH)
	ceph orch daemon add osd $$(hostnamectl hostname):$(DISK_PATH)
	ceph fs volume create benchfs
	mkdir -p /mnt/cephfs
	mount -t ceph admin@$$(ceph fsid).benchfs=/ /mnt/cephfs

/mnt/cephfs/f20g: 
	dd if=/dev/urandom of=/mnt/cephfs/f20g bs=10M count=2000
	
cephfs-bench: DISK_NAME /mnt/cephfs/f20g
	./repeat-bench.sh ceph $(DISK_NAME) 20 /mnt/cephfs/f20g

MON_IP:
	$(if $(value MON_IP),,$(error MON_IP var is empty))

DISK_NAME:
	$(if $(value DISK_NAME),,$(error DISK_NAME var is empty))

DISK_PATH:
	$(if $(value DISK_PATH),,$(error DISK_PATH var is empty))

INTERFACE_NAME:
	$(if $(value INTERFACE_NAME),,$(error INTERFACE_NAME var is empty))


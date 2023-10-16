beegfs-server: DISK_PATH INTERFACE_NAME
	./beegfs-cleanup.sh
	./beegfs-install.sh $(INTERFACE_NAME) $(DISK_PATH)

beegfs-cleanup:
	./beegfs-cleanup.sh

beegfs-fallocate-target: /mnt/beegfs/f20g
	systemctl restart beegfs-client
	dd if=/dev/urandom of=/mnt/beegfs/f20g bs=10M count=2000

beegfs-bench: DISK_NAME beegfs-fallocate-target
	./repeat-bench.sh beegfs $(DISK_NAME) 20 /mnt/beegfs/f20g


cephfs-fallocate-target: 
	dd if=/dev/urandom of=/mnt/cephfs/f20g bs=10M count=2000
	
cephfs-bench: DISK_NAME cephfs-fallocate-target
	./repeat-bench.sh ceph $(DISK_NAME) 20 /mnt/cephfs/f20g

DISK_NAME:
	$(if $(value DISK_NAME),,$(error DISK_NAME var is empty))

DISK_PATH:
	$(if $(value DISK_PATH),,$(error DISK_PATH var is empty))

INTERFACE_NAME:
	$(if $(value INTERFACE_NAME),,$(error INTERFACE_NAME var is empty))


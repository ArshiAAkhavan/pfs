beegfs-server:
	./beegfs-cleanup.sh
	./beegfs-install.sh $(INTERFACE_NAME) $(DISK_PATH)

beegfs-cleanup:
	./beegfs-cleanup.sh

beegfs-fallocate-target: /mnt/beegfs/f20g
	systemctl restart beegfs-client
	dd if=/dev/urandom of=/mnt/beegfs/f20g bs=10M count=2000

beegfs-bench: beegfs-fallocate-target
	./repeat-bench.sh beegfs $(DISK_NAME) 20 /mnt/beegfs/f20g


cephfs-fallocate-target: 
	dd if=/dev/urandom of=/mnt/cephfs/f20g bs=10M count=2000
	
cephfs-bench: cephfs-fallocate-target
	./repeat-bench.sh ceph $(DISK_NAME) 20 /mnt/ceph/f20g

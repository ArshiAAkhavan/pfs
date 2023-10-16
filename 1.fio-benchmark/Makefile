beegfs-server:
	./beegfs-cleanup.sh
	./beegfs-install.sh $(INTERFACE_NAME) $(DISK_PATH)

beegfs-cleanup:
	./beegfs-cleanup.sh

beegfs-bench:
	systemctl restart beegfs-client
	dd if=/dev/urandom of=/mnt/beegfs/f20g bs=4M count=5000
	./repeat-bench.sh beegfs $(DISK_NAME) 20 /mnt/beegfs/f20g

beegfs-server:
	./beegfs-cleanup.sh
	./beegfs-install.sh $(INTERFACE_NAME) $(DISK_PATH)

beegfs-cleanup:
	./beegfs-cleanup.sh

beegfs-bench:
	systemctl restart beegfs-client
	dd if=/dev/urandom of=/mnt/beegfs/f20g bs=1M count=20000
	./repeat-bench.sh beegfs sdb 20 /mnt/beegfs/f20g

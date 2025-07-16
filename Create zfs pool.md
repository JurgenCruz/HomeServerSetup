# Create ZFS pool

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20zfs%20pool.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20zfs%20pool.es.md)

Now we will configure the ZFS pool and its datasets. If you have 3 to 4 disks, `raidz` is recommended. If you have 5 to 6 disks, `raidz2` is recommended. Less than 3 disks is not recommended since the only possible redundancy would be with 2 disks in mirror mode with only one redundancy disk and only 50% capacity. For more than 6 discs it is recommended that you make 2 or more pools. Directories will also be prepared for the configuration of the containers in the OS partition, that is, on the SSD. This provides better performance in their execution. The container configuration will be backed up to the hard drives once a day.

## Steps

1. After logging in, assume `root` by running `sudo -i`.
2. Run: `./scripts/generate_zfs_key.sh`. A hex key will be generated in `/keys/Tank.dat`. It is recommended that you back up this key in a safe place because if the SSD fails and the key is lost, the data in the pool will be lost forever.
3. Run: `./scripts/create_zfs_pool.sh raidz2 /dev/disk/by-id/disk1 /dev/disk/by-id/disk2 /dev/disk/by-id/disk3 /dev/disk/by-id/disk4 /dev/disk/by-id/disk5 /dev/disk/by-id/disk6`. Adjust the parameters to choose the appropriate type of `raidz`. It is advisable to use disk names by id, uuid or label. **Do not use the disk name** (for example /dev/sda) as these can change after a reboot and the pool will not work.
4. Execute: `./scripts/create_zfs_datasets.sh`. Enter the names of the users you wish to create Samba shares for one by one. Datasets will be created with the username in capital letters, for example `Tank/USER1`. Additionally, it will create a `Tank/Apps` dataset to back up the container configuration, a `Tank/MediaCenter` dataset to store the media files and a `Tank/NextCloud` dataset to store backup files. The datasets that will be used as Samba shares will be configured so that SELinux allows access to them by Samba.
5. Run: `./scripts/create_app_folders.sh` to generate the container directories on the SSD.
6. Run: `./scripts/generate_dataset_mount_units.sh`. This will generate Systemd units that will mount the datasets in `Tank` automatically after loading the key upon rebooting the server. Run this command `cat /etc/zfs/zfs-list.cache/Tank` to verify that the cache file is not empty. If it is empty, try running the script again as it means the cache and units were not generated.

> [!TIP]
> To adjust the max size of ZFS ARC, use the command `echo {size_in_bytes} > /sys/module/zfs/parameters/zfs_arc_max` replacing `{size_in_bytes}` with the size in bytes you wish to set. To make the change permanent, execute the command `echo "options zfs zfs_arc_max={size_in_bytes}" > /etc/modprobe.d/zfs.conf && dracut --force`.

> [!Caution]
> Assigning a very high value can cause instability in the system, only change it if you know what you are doing.

[<img width="33.3%" src="buttons/prev-Configure zfs.svg" alt="Configure ZFS">](Configure%20zfs.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Configure shares.svg" alt="Configure shares">](Configure%20shares.md)

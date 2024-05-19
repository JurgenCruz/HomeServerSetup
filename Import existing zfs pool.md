# Import existing ZFS pool

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Import%20existing%20zfs%20pool.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Import%20existing%20zfs%20pool.es.md)

There might be times you will want to import an existing ZFS pool. For example, after an OS reinstallation. This is how to do it.

## Steps

1. After logging in, assume `root` by running `sudo -i`.
2. Create the keys directory: `mkdir /keys`. It is assumed that this address is the same one used before reinstalling the OS and that the pool will look for the key in the same directory. Adjust the address if not.
3. Copy the key from another computer: `scp user@host:/path/to/keyfile /keys/Tank.dat`. Change `{user@host:/path/to/keyfile}` to the address of the key on the computer containing the backup. If you prefer, you can also use a USB stick to transfer the key backup.
4. Import the existing pools: `zpool import -d /dev/disk/by-id -a`. If the pool was not exported before, try using `-f` to force the import.
5. Mount all datasets and load the key if necessary: `zfs mount -al`.
6. Restore the container folders from the hard drives to the SSD: `rsync -avz /mnt/Tank/Apps/ /Apps/`.
7. Run: `./scripts/generate_dataset_mount_units.sh`. This will generate Systemd units that will mount the datasets in `Tank` automatically after loading the key upon rebooting the server. Run this command `cat /etc/zfs/zfs-list.cache/Tank` to verify that the cache file is not empty. If it is empty, try running the script again as it means the cache and units were not generated.

> [!NOTE]
> After import, there will be certain steps in the guide that you can skip. For example if certain directories or files already existed. It is left to the reader's discretion to see which steps are no longer necessary.

> [!TIP]
> To adjust the max size of ZFS ARC use the command `echo {size_in_bytes} > /sys/module/zfs/parameters/zfs_arc_max` replacing `{size_in_bytes}` with the size in bytes you wish to set. To make the change permanent execute the command `echo "options zfs zfs_arc_max={size_in_bytes}" > /etc/modprobe.d/zfs.conf && dracut --force`.

> [!Caution]
> Assigning a very high value can cause instability in the system, only change it if you know what you are doing.

[<img width="33.3%" src="buttons/prev-Configure zfs.svg" alt="Configure ZFS">](Configure%20zfs.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Configure shares.svg" alt="Configure shares">](Configure%20shares.md)

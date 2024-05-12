# Configure ZFS

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20zfs.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20zfs.es.md)

Now we will configure the ZFS pool and its datasets. If you have 3 to 4 disks, `raidz` is recommended. If you have 5 to 6 disks, `raidz2` is recommended. Less than 3 disks is not recommended since the only possible redundancy would be with 2 disks in mirror mode with only one redundancy disk and only 50% capacity. For more than 6 discs it is recommended that you make 2 or more pools. Directories will also be prepared for the configuration of the containers in the OS partition, that is, on the SSD. This provides better performance in their execution. The container configuration will be backed up to the hard drives once a day.

## Steps

1. After logging in, assume `root` by running `sudo -i`.
2. Depending on whether this is your first installation, a reinstallation, or a hard drive migration, complete the appropriate steps.
    - A) First installation: an encryption key will be generated and a new disk pool will be created.
        1. Run: `./scripts/generate_zfs_key.sh`. A hex key will be generated in `/keys/Tank.dat`. It is recommended that you back up this key in a safe place because if the SSD fails and the key is lost, the data in the pool will be lost forever.
        2. Run: `./scripts/create_zfs_pool.sh raidz2 /dev/disk/by-id/disk1 /dev/disk/by-id/disk2 /dev/disk/by-id/disk3 /dev/disk/by- id/disk4 /dev/disk/by-id/disk5 /dev/disk/by-id/disk6`. Adjust the parameters to choose the appropriate type of `raidz`. It is advisable to use disk names by id, uuid or label. **Do not use the disk name** (for example /dev/sda) as these can change after a reboot and the pool will not work.
        3. Execute: `printf "nasj\nnask" | ./scripts/create_zfs_datasets.sh`. Datasets will be created with the user name in capital letters, for example `Tank/NASJ`. Additionally, it will create a `Tank/Apps` dataset to backup the container configuration and a `Tank/MediaCenter` dataset to store the media files. The datasets that will be used as Samba shares will be configured so that SELinux allows access to them by Samba.
        4. Run: `./scripts/create_app_folders.sh` to generate the container directories on the SSD.
    - B) OS reinstallation: the encryption key will be restored and the existing pool will be imported.
        1. Create the keys directory: `mkdir /keys`. It is assumed that this address is the same one used before reinstalling the OS and that the pool will look for the key in the same directory. Adjust the address if not.
        2. Copy the key from another computer: `scp user@host:/path/to/keyfile /keys/Tank.dat`. Change `{user@host:/path/to/keyfile}` to the address of the key on the computer containing the backup. If you prefer, you can also use a USB stick to transfer the key backup.
        3. Import the existing pools: `zpool import -d /dev/disk/by-id -a`. If the pool was not exported before, try using `-f` to force the import.
        4. Mount all datasets and load the key if necessary: `zfs mount -al`.
        5. Restore the container folders from the hard drives to the SSD: `rsync -avz /mnt/Tank/Apps/ /Apps/`.
    - C) Migrate to new hard drives: It is assumed that the new pool will use the same key as the previous one and that it is already in place.
        1. Run: `./scripts/migrate_pool.sh Tank raidz2 /dev/disk/by-id/disk1 /dev/disk/by-id/disk2 /dev/disk/by-id/disk3 /dev/disk/by -id/disk4 /dev/disk/by-id/disk5 /dev/disk/by-id/disk6`. `Tank` is the name of the current pool. It is the same name used by the script that initially creates the pool. The other parameters are the same as for `create_zfs_pool.sh`. See information in option A).
        2. Mount all datasets and load the key if necessary: `zfs mount -al`.
3. Run: `./scripts/generate_dataset_mount_units.sh`. This will generate Systemd units that will mount the datasets in `Tank` automatically after loading the key upon rebooting the server. Run this command `cat /etc/zfs/zfs-list.cache/Tank` to verify that the cache file is not empty. If it is empty, try running the script again as it means the cache and units were not generated.

> [!NOTE]
> If you performed a migration or reinstallation, there will be certain steps in the guide that you can skip. For example if certain directories or files already existed. It is left to the reader's discretion to see which steps are no longer necessary.

> [!TIP]
> To adjust the max size of ZFS ARC use the command `echo {size_in_bytes} > /sys/module/zfs/parameters/zfs_arc_max` replacing `{size_in_bytes}` with the size in bytes you wish to set. To make the change permanent execute the command `echo "options zfs zfs_arc_max={size_in_bytes}" > /etc/modprobe.d/zfs.conf && dracut --force`.

> [!Caution]
> Assigning a very high value can cause instability in the system, only change it if you know what you are doing.

[<img width="50%" src="buttons/prev-Install zfs.svg" alt="Install ZFS">](Install%20zfs.md)[<img width="50%" src="buttons/next-Configure hosts network.svg" alt="Configure host's network">](Configure%20hosts%20network.md)

<details><summary>Index</summary>

1. [Objective](Objective.md)
2. [Motivation](Motivation.md)
3. [Features](Features.md)
4. [Design and justification](Design%20and%20justification.md)
5. [Minimum prerequisites](Minimum%20prerequisites.md)
6. [Guide](Guide.md)
    1. [Install Fedora Server](Install%20fedora%20server.md)
    2. [Configure Secure Boot](Configure%20secure%20boot.md)
    3. [Install and configure Zsh (Optional)](Install%20and%20configure%20zsh%20optional.md)
    4. [Configure users](Configure%20users.md)
    5. [Install ZFS](Install%20zfs.md)
    6. [Configure ZFS](Configure%20zfs.md)
    7. [Configure host's network](Configure%20hosts%20network.md)
    8. [Configure shares](Configure%20shares.md)
    9. [Register DDNS](Register%20ddns.md)
    10. [Install Docker](Install%20docker.md)
    11. [Create Docker stack](Create%20docker%20stack.md)
    12. [Configure applications](Configure%20applications.md)
    13. [Configure scheduled tasks](Configure%20scheduled%20tasks.md)
    14. [Configure public external traffic](Configure%20public%20external%20traffic.md)
    15. [Configure private external traffic](Configure%20private%20external%20traffic.md)
    16. [Install Cockpit](Install%20cockpit.md)
7. [Glossary](Glossary.md)

</details>

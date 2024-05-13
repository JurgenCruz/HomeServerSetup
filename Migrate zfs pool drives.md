# Migrate ZFS pool drives

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Migrate%20zfs%20pool%20drives.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Migrate%20zfs%20pool%20drives.es.md)

If you want to migrate your pool to other disks, maybe to larger ones, you can follow the following steps. If you have 3 to 4 disks, `raidz` is recommended. If you have 5 to 6 disks, `raidz2` is recommended. Less than 3 disks is not recommended since the only possible redundancy would be with 2 disks in mirror mode with only one redundancy disk and only 50% capacity. For more than 6 discs it is recommended that you make 2 or more pools.

## Steps

1. After logging in, assume `root` by running `sudo -i`.
2. Run: `./scripts/migrate_pool.sh Tank raidz2 /dev/disk/by-id/disk1 /dev/disk/by-id/disk2 /dev/disk/by-id/disk3 /dev/disk/by -id/disk4 /dev/disk/by-id/disk5 /dev/disk/by-id/disk6`. It is assumed that the new pool will use the same key as the previous one and that it is already in place. `Tank` is the name of the current pool. It is the same name used by the script that initially creates the pool. The other parameters are the same as for `create_zfs_pool.sh`. See information in section `Create ZFS pool`.
3. Mount all datasets and load the key if necessary: `zfs mount -al`.
4. Run: `./scripts/generate_dataset_mount_units.sh`. This will generate Systemd units that will mount the datasets in `Tank` automatically after loading the key upon rebooting the server. Run this command `cat /etc/zfs/zfs-list.cache/Tank` to verify that the cache file is not empty. If it is empty, try running the script again as it means the cache and units were not generated.

> [!NOTE]
> After migration, there will be certain steps in the guide that you can skip. For example if certain directories or files already existed. It is left to the reader's discretion to see which steps are no longer necessary.

> [!TIP]
> To adjust the max size of ZFS ARC use the command `echo {size_in_bytes} > /sys/module/zfs/parameters/zfs_arc_max` replacing `{size_in_bytes}` with the size in bytes you wish to set. To make the change permanent execute the command `echo "options zfs zfs_arc_max={size_in_bytes}" > /etc/modprobe.d/zfs.conf && dracut --force`.

> [!Caution]
> Assigning a very high value can cause instability in the system, only change it if you know what you are doing.

[<img width="50%" src="buttons/prev-Configure zfs.svg" alt="Configure ZFS">](Configure%20zfs.md)[<img width="50%" src="buttons/next-Configure hosts network.svg" alt="Configure host's network">](Configure%20hosts%20network.md)

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

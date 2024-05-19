# Install ZFS

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Install%20zfs.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Install%20zfs.es.md)

Since ZFS is a kernel module, it means that it also has to pass the Secure Boot check. We will install ZFS and register the key used to sign it in the Secure Boot boot chain. This registration requires restarting the server and navigating a wizard as explained later.

## Steps

1. Run: `./scripts/zfs_setup.sh`. The script will ask you to enter a password. This password will be used one time on the next reboot to add the signature to the Secure Boot chain. You can use a temporary password or you can reuse your user's password if you wish.
2. Reboot with: `reboot`.
3. A blue screen with a menu will appear. Select the following options:
    1. "Enroll MOK".
    2. "Continue."
    3. "Yes."
    4. Enter the password you defined in the first step.
    5. "OK."
    6. "Reboot".

[<img width="33.3%" src="buttons/prev-Configure users.svg" alt="Configure users">](Configure%20users.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Configure zfs.svg" alt="Configure ZFS">](Configure%20zfs.md)

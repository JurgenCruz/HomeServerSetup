# Install ZFS

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

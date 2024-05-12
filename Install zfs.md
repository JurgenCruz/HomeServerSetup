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

[<img width="50%" src="buttons/prev-Configure users.svg" alt="Configure users">](Configure%20users.md)[<img width="50%" src="buttons/next-Configure zfs.svg" alt="Configure ZFS">](Configure%20zfs.md)

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

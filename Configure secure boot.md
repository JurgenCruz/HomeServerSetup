# Configure Secure Boot

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20secure%20boot.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20secure%20boot.es.md)

Secure Boot will be configured with owner keys and a password will be set to the BIOS to prevent its deactivation.

## Steps

1. Turn on the server and enter the BIOS (usually with the `F2` key).
2. Configure Secure Boot in "Setup" mode, save and reboot.
3. After logging in with `admin`, run: `sudo ./scripts/secureboot.sh`.
4. If there were no errors, then run `reboot` to reboot and enter the BIOS again.
5. Exit "Setup" mode and enable Secure Boot.
6. Set a password to the BIOS, save and reboot.
7. After logging in with `admin`, run: `sbctl status`. The message should say that it is installed and Secure Boot is enabled.

[<img width="50%" src="buttons/prev-Install fedora server.svg" alt="Install Fedora Server">](Install%20fedora%20server.md)[<img width="50%" src="buttons/next-Install and configure zsh optional.svg" alt="Install and configure Zsh (Optional)">](Install%20and%20configure%20zsh%20optional.md)

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

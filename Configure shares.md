# Configure shares

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20shares.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20shares.es.md)

Samba will be installed, Samba shares will be configured, user passwords will be created that are separate from Linux passwords (you can use the same passwords as Linux if you like), and the firewall will be configured to allow the Samba service to the local network.

## Steps

1. Run: `./scripts/smb_setup.sh`. Installs Samba service.
2. Run: `./scripts/set_samba_passwords.sh`. Enter the username and set a password for it. This guide assumes that passwords will be set for 3 users: `mediacenter`, `nasj` and `nask`.
3. Copy the preconfigured Samba server configuration with 3 shares for the users from the previous step: `cp ./files/smb.conf /etc/samba`.
4. Edit the file: `nano /etc/samba/smb.conf`. You can change the names of the shares (eg \[NASJ\]), and the `path` and `valid users` properties. The guide assumes that the local network is in the range 192.168.1.0/24. If your network is different, then also change the `allow hosts` property so that it has the correct range of your local network. Save and exit with `Ctrl + X, Y, Enter`.
5. Run: `./scripts/smb_firewalld_services.sh`. Configure Firewalld by opening the ports for Samba and then enable the Samba service.

[<img width="50%" src="buttons/prev-Configure hosts network.svg" alt="Configure host's network">](Configure%20hosts%20network.md)[<img width="50%" src="buttons/next-Register ddns.svg" alt="Register DDNS">](Register%20ddns.md)

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

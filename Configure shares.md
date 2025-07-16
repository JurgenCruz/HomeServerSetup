# Configure shares

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20shares.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20shares.es.md)

Samba will be installed, Samba shares will be configured, user passwords will be created that are separate from Linux passwords (you can use the same passwords as Linux if you like), and the firewall will be configured to allow the Samba service to the local network.

## Steps

1. Run: `./scripts/smb_setup.sh`. Installs Samba service.
2. Run: `./scripts/set_samba_passwords.sh`. Enter a username and set a password for it. The script will keep asking for more users. Enter as many users you wish to have access to Samba service. This guide assumes that a password will be set for at least 1 user: `mediacenter`.
3. Copy the preconfigured Samba server configuration with 1 share for the user from the previous step: `cp ./files/smb.conf /etc/samba`.
4. Edit the file: `nano /etc/samba/smb.conf`. You can add new shares by copying the existing `[MediaCenter]` one and changing the name and the `path` and `valid users` properties. The guide assumes that the local network is in the range 192.168.1.0/24. If your network is different, then also change the `allow hosts` property so that it has the correct range of your local network. Save and exit with `Ctrl + X, Y, Enter`.
5. Run: `./scripts/smb_firewalld_services.sh`. Configure Firewalld by opening the ports for Samba and then enable the Samba service.

[<img width="33.3%" src="buttons/prev-Configure zfs.svg" alt="Configure ZFS">](Configure%20zfs.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Install docker.svg" alt="Install Docker">](Install%20docker.md)

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

[<img width="33.3%" src="buttons/prev-Configure zfs.svg" alt="Configure ZFS">](Configure%20zfs.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Install docker.svg" alt="Install Docker">](Install%20docker.md)

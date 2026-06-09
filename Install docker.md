# Install Docker

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Install%20docker.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Install%20docker.es.md)

We will install Docker as our container engine with IPv6 support; optionally we will install Nvidia drivers and "Nvidia Container Toolkit"; and we will configure SELinux to secure Docker.

## Steps

1. Run: `./scripts/docker_setup.sh admin`. Adds the Docker repository, installs it, enables the service, and adds the `admin` user to the `docker` group.
2. Open https://simpledns.plus/private-ipv6 and write down the `Combined/CID` and remove the last block. For example `fda6:80d8:cf96:a065::/64` becomes `fda6:80d8:cf96::/64`.
3. Edit the script: `nano ./scripts/selinux_setup.sh`.
4. Replace the `fixed-cidr-v6` value with the CIDR you just generated through the website. Save and exit with `Ctrl + X, Y, Enter`.
5. Run: `./scripts/selinux_setup.sh`. Enables SELinux in Docker; restarts the Docker service for the changes to take effect; enables the flag that allows containers to manage the network and use the GPU; and installs the SELinux policies. These are required for some containers to be able to access Samba files and interact with WireGuard and for rsync to be able to back up the apps.
6. Optional: If you have a relatively modern Nvidia card, run: `./scripts/nvidia_setup.sh`. Adds "RPM Fusion" and Nvidia repositories to install the driver and "Nvidia Container Toolkit" for Docker. It also registers the "Akmods" key in the Secure Boot chain. It is necessary to reboot and repeat the key enrollment process as we did with ZFS. After rebooting and logging in, don't forget to assume `root` with `sudo -i`. One optimization you can do is to modify the Nvidia Runtime configuration with: `nano /etc/nvidia-container-runtime/config.toml` and uncomment the line `no-cgroups = false`. Press Ctrl + S to save and Ctrl + X to exit nano.
7. Run: `./scripts/create_dockhand_folder.sh` to generate the container directory on the SSD.
8. Edit the stack file: `nano ./files/dockhand-stack.yml`.
9. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
10. Replace the XXX with the `uid` and `gid` of the user `mediacenter`. You can use `id mediacenter` to get the `uid` and `gid`.
11. Replace the YYY with the `gid` of the group `docker`. You can use `getent group | grep docker` to get the `gid`. This will allow the container to control Docker through the Docker socket.
12. Save and exit with `Ctrl + X, Y, Enter`.
13. Run: `./scripts/run_dockhand.sh`. This runs a Dockhand container and will listen on port `3000`.
14. Configure Dockhand from the browser.
    1. Access Dockhand through http://server.lan:3000.
    2. Navigate to "Settings" > "Authentication" > "Users".
    3. Generate a random password and create user `admin`. Bitwarden is recommended again for this.
    4. Go back to "Authentication" > "General" tab and enable "Authentication".
    5. Refresh the page and login with the new user.
    6. Navigate to "Settings" > "Notifications" and click "Add channel" button.
    7. "Name": "Gotify".
    8. "Type": "Apprise (Webhooks)".
    9. "URL": "gotifys://hostname/{token}". The {token} is a placeholder which will be replaced later in the guide.
    10. Click "Add" button.
    11. Navigate to "Settings" > "Environments".
    12. Click "Add environment" button.
    13. "Name": "local".
    14. "Connection type": "Unix socket".
    15. "Socket path": "/var/run/docker.sock".
    16. Navigate to "Security" tab and enable "Vulnerability scanning".
    17. Navigate to "Notifications" tab and enable the "Gotify" channel.
    18. Click "Add" button.

[<img width="33.3%" src="buttons/prev-Configure shares.svg" alt="Configure shares">](Configure%20shares.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Create shared networks stack.svg" alt="Create shared networks stack">](Create%20shared%20networks%20stack.md)

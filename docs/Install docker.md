# Install Docker

We will install Docker as our container engine with IPv6 support; optionally we will install Nvidia drivers and "Nvidia Container Toolkit"; and we will configure SELinux to secure Docker.

## Steps

1. Run: `./scripts/docker_setup.sh admin`. Adds the Docker repository, installs it, enables the service, and adds the `admin` user to the `docker` group.
2. Open https://simpledns.plus/private-ipv6 and write down the `Combined/CID` and remove the last block. For example `fda6:80d8:cf96:a065::/64` becomes `fda6:80d8:cf96::/64`.
3. Edit the script: `nano ./scripts/selinux_setup.sh`.
4. Replace the `fixed-cidr-v6` value with the CIDR you just generated through the website. Save and exit with `Ctrl + X, Y, Enter`.
5. Run: `./scripts/selinux_setup.sh`. Enables SELinux in Docker; restarts the Docker service for the changes to take effect; enables the flag that allows containers to manage the network and use the GPU; and installs the SELinux policies. These are required for some containers to be able to access Samba files and interact with WireGuard and for rsync to be able to back up the apps.
6. Optional: If you have a relatively modern Nvidia card, run: `./scripts/nvidia_setup.sh`. Adds "RPM Fusion" and Nvidia repositories to install the driver and "Nvidia Container Toolkit" for Docker. It also registers the "Akmods" key in the Secure Boot chain. It is necessary to reboot and repeat the key enrollment process as we did with ZFS. After rebooting and logging in, don't forget to assume `root` with `sudo -i`. One optimization you can do is to modify the Nvidia Runtime configuration with: `nano /etc/nvidia-container-runtime/config.toml` and uncomment the line `no-cgroups = false`. Press Ctrl + S to save and Ctrl + X to exit nano.
7. Run: `./scripts/create_arcane_folder.sh` to generate the container directory on the SSD.
8. Run: `openssl rand -hex 32` and copy the generated key.
9. Edit the stack file: `nano ./files/arcane-stack.yml`.
10. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
11. Replace the XXX with the `uid` and `gid` of the user `mediacenter`. You can use `id mediacenter` to get the `uid` and `gid`.
12. Replace the {key} with the one generated with the openssl command.
13. Save and exit with `Ctrl + X, Y, Enter`.
14. Run: `./scripts/run_arcane.sh`. This runs an Arcane container and will listen on port `3552`.
15. Configure Arcane from the browser.
    1. Access Arcane through http://server.lan:3552.
    2. Login with username `arcane` and password `arcane-admin`.
    3. Generate a random password and change the password. Bitwarden is recommended again for this.
    4. Navigate to "Settings" > "Notifications > Gotify" and enable it.
    5. "Server Host": "gotify.myhome.duckdns.org".
    6. "Application Token": "{token}". The {token} is a placeholder which will be replaced later in the guide.
    7. "Priority": 5.
    8. Click "Save" button at the top.
    9. Navigate to "Environments".
    10. Click "local".
    11. Navigate to "Automation" tab and enable "Vulnerability Scan".

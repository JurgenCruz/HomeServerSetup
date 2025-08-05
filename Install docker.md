# Install Docker

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Install%20docker.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Install%20docker.es.md)

We will install Docker as our container engine; optionally we will install Nvidia drivers and "Nvidia Container Toolkit"; and we will configure SELinux to secure Docker.

## Steps

1. Run: `./scripts/docker_setup.sh admin`. Adds the Docker repository, installs it, enables the service, and adds the `admin` user to the `docker` group.
2. Run: `./scripts/selinux_setup.sh`. Enables SELinux in Docker; restarts the Docker service for the changes to take effect; enables the flag that allows containers to manage the network and use the GPU; and installs the SELinux policies. These are required for some containers to be able to access Samba files and interact with WireGuard and for rsync to be able to back up the apps.
3. Optional: If you have a relatively modern Nvidia card, run: `./scripts/nvidia_setup.sh`. Adds "RPM Fusion" and Nvidia repositories to install the driver and "Nvidia Container Toolkit" for Docker. It also registers the "Akmods" key in the Secure Boot chain. It is necessary to reboot and repeat the key enrollment process as we did with ZFS. After rebooting and logging in, don't forget to assume `root` with `sudo -i`.
4. Run: `./scripts/create_portainer_folder.sh` to generate the container directory on the SSD.
5. Run: `./scripts/run_portainer.sh`. This runs a Portainer Community Edition container and will listen on port `9443`.
6. Configure Portainer from the browser.
    1. Access Portainer through https://server.lan:9443. If you get a security alert, you can accept the risk since Portainer uses a self-signed SSL certificate.
    2. Set a random password and create user `admin`. Bitwarden is recommended again for this.
    3. Navigate to "Environments" > "local" and change "Public IP" with the server's hostname `server.lan`.

[<img width="33.3%" src="buttons/prev-Configure shares.svg" alt="Configure shares">](Configure%20shares.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Create shared networks stack.svg" alt="Create shared networks stack">](Create%20shared%20networks%20stack.md)

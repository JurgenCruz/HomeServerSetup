# Install Docker

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Install%20docker.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Install%20docker.es.md)

We will install Docker as our container engine; optionally we will install Nvidia drivers and "Nvidia Container Toolkit"; and we will configure SELinux to secure Docker.

## Steps

1. Run: `./scripts/docker_setup.sh admin`. Adds the Docker repository, installs it, enables the service, and adds the `admin` user to the `docker` group.
2. Run: `./scripts/selinux_setup.sh`. Enables SELinux in Docker; restarts the Docker service for the changes to take effect; enables the flag that allows containers to manage the network and use the GPU; and installs the SELinux policies. These are required for some containers to be able to access Samba files and interact with WireGuard and for rsync to be able to backup the apps.
3. Optional: If you have a relatively modern Nvidia card, run: `./scripts/nvidia_setup.sh`. Adds "RPM Fusion" and Nvidia repositories to install the driver and "Nvidia Container Toolkit" for Docker. It also registers the "Akmods" key in the Secure Boot chain. It is necessary to reboot and repeat the key enrollment process as we did with ZFS. After rebooting and logging in, don't forget to assume `root` with `sudo -i`.

[<img width="50%" src="buttons/prev-Register ddns.svg" alt="Register DDNS">](Register%20ddns.md)[<img width="50%" src="buttons/next-Create docker stack.svg" alt="Create Docker stack">](Create%20docker%20stack.md)

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

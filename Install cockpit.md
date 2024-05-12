# Install Cockpit

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Install%20cockpit.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Install%20cockpit.es.md)

Finally we will install Cockpit with some plugins and configure the firewall to allow the Cockpit service to the local network.

## Steps

1. Run: `./scripts/cockpit_setup.sh`. Installs Cockpit and its plugins and configures Firewalld to allow Cockpit on the network.
2. To test that it worked, access Cockpit through https://server.lan:9090. Use your `admin` credentials.

**Congratulations! You now have your home server up and running and ready to go!**

[<img width="50%" src="buttons/prev-Configure private external traffic.svg" alt="Configure private external traffic">](Configure%20private%20external%20traffic.md)[<img width="50%" src="buttons/next-Glossary.svg" alt="Glossary">](Glossary.md)

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

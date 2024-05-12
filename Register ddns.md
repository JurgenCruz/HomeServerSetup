# Register DDNS

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Register%20ddns.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Register%20ddns.es.md)

If you do not plan to access your server outside of your local network, or if you have a static public IP and your own domain, you can skip this section.

This guide will use the DuckDNS.org service as DDNS in order to map a subdomain to our server. We will register a subdomain on DuckDNS.org and configure our server to update the IP on DuckDNS.org.

## Steps

1. Register a subdomain on DuckDNS.org.
    1. Access and create an account at https://www.duckdns.org/.
    2. Register a subdomain of your preference. Write down the generated token because we are going to need it next.
2. Copy the script that updates the DDNS with our public IP to `sbin`: `cp ./scripts/duck.sh /usr/local/sbin/`.
3. Edit the script: `nano /usr/local/sbin/duch.sh`. Replace `XXX` with the subdomain we registered and `YYY` with the token we generated during registration. Save and exit with `Ctrl + X, Y, Enter`.
4. We change the permissions of the script so that only `root` can access it: `chmod 700 /usr/local/sbin/duck.sh`. The script contains our token, which is the only thing that allows only us to change the IP to which the subdomain points, hence the importance of securing it.

[<img width="50%" src="buttons/prev-Configure shares.svg" alt="Configure shares">](Configure%20shares.md)[<img width="50%" src="buttons/next-Install docker.svg" alt="Install Docker">](Install%20docker.md)

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

# Configure users

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20users.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20users.es.md)

Apart from the `admin` user, a user that we will call `mediacenter` is necessary to manage access to Media Center files and manage the AAR application ecosystem. You also need one user for each Samba share you want to make. The guide will use 2 example Samba shares and thus, 2 users: `nasj` and `nask`. The user `admin` will be added to the groups of each created user so that it also have access to the files.

## Steps

1. Assume the `root` role by running `sudo -i`.
2. We create users `nasj`, `nask` and `mediacenter` and add `admin` to their groups: `printf "nasj\nnask\nmediacenter" | ./scripts/users_setup.sh admin`.

[<img width="50%" src="buttons/prev-Install and configure zsh optional.svg" alt="Install and configure Zsh (Optional)">](Install%20and%20configure%20zsh%20optional.md)[<img width="50%" src="buttons/next-Install zfs.svg" alt="Install ZFS">](Install%20zfs.md)

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

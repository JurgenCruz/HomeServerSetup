# Minimum prerequisites

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Minimum%20prerequisites.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Minimum%20prerequisites.es.md)

- An old computer no more than 7 years old.
- An SSD for the OS.
- At least 3 HDDs of the same size of at least 6 TB. Recommended 6 HDDs of 8 TB.
- Minimum 8GB of RAM. All the RAM that the motherboard can support is recommended since ZFS can use the RAM as cache for better performance.
- Internet connection. If you want to watch media away from home, a good upload speed is recommended.
- A USB stick of at least 1 GB for the Fedora Server ISO.
- An anonymous VPN provider for bittorrent. Mulvad is recommended as it does not require any information to use the service and the only information exposed is the IP. Payment can be made with Monero for even greater privacy.
- Optional: 2.5 Gb Ethernet network card. If the motherboard already has an Ethernet port of at least 1 Gb, it can be skipped unless better data transfer performance is desired. The guide assumes that you connected the server to the router through this Ethernet port.
- Optional: Video card capable of video encoding/decoding for hardware acceleration. The guide will assume an Nvidia video card.
- Optional: HBA card in "passthrough" mode (i.e. not hardware RAID). If your motherboard has enough ports for all drives, it is not necessary. It is important to check the motherboard manual and see if it supports the video card, the network card (if it is not integrated) and the HBA at the same time, both physically (it has enough slots for the cards) and logically (it supports the multiple slots at the same time. Some motherboards can only have a certain combination of slots working at the same time).
- The guide assumes that the user is familiar with their motherboard manual and BIOS and has correctly configured the BIOS for their hardware.

[<img width="50%" src="buttons/prev-Design and justification.svg" alt="Design and justification">](Design%20and%20justification.md)[<img width="50%" src="buttons/next-Guide.svg" alt="Guide">](Guide.md)

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

# NAS, Media Center and Home Automation Server

[![en](https://img.shields.io/badge/lang-en-blue.svg)](README.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](README.es.md)

This is a guide on how to set up a home server from scratch. If you are not familiar with a concept, the guide provides a glossary at the end of the guide for your convenience.

## Index

1. [Objective](Objective.md)
2. [Motivation](Motivation.md)
3. [Features](Features.md)
4. [Design and justification](Design%20and%20justification.md)
5. [Minimum prerequisites](Minimum%20prerequisites.md)
6. [Guide](Guide.md)
    1. [Install Fedora Server](Install%20fedora%20server.md)
    2. [Configure Secure Boot](Configure%20secure%20boot.md)
    3. [Install and configure Zsh (Optional)](Install%20and%20configure%20zsh%20optional.md)
    4. [Install Cockpit](Install%20cockpit.md)
    5. [Register DDNS (Optional)](Register%20ddns%20optional.md)
    6. [Configure users](Configure%20users.md)
    7. [Install ZFS](Install%20zfs.md)
    8. [Configure ZFS](Configure%20zfs.md)
        1. [Create ZFS pool](Create%20zfs%20pool.md)
        2. [Import existing ZFS pool](Import%20existing%20zfs%20pool.md)
        3. [Migrate ZFS pool drives](Migrate%20zfs%20pool%20drives.md)
    9. [Configure shares](Configure%20shares.md)
    10. [Install Docker](Install%20docker.md)
    11. [Create shared networks stack](Create%20shared%20networks%20stack.md)
    12. [Create and configure Nextcloud stack](Create%20and%20configure%20nextcloud%20stack.md)
    13. [Create and configure Home Assistant stack](Create%20and%20configure%20home%20assistant%20stack.md)
    14. [Create and configure private external traffic stack (Optional)](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.md)
    15. [Create and configure arr applications stack](Create%20and%20configure%20arr%20applications%20stack.md)
    16. [Configure DNS](Configure%20dns.md)
        1. [Configure router DNS](Configure%20router%20dns.md)
        2. [Configure Technitium DNS](Configure%20technitium%20dns.md)
            1. [Configure router DHCP](Configure%20router%20dhcp.md)
            2. [Configure Technitium DHCP](Configure%20technitium%20dhcp.md)
    17. [Create and configure public external traffic stack (Optional)](Create%20and%20configure%20public%20external%20traffic%20stack%20optional.md)
    18. [Configure scheduled tasks](Configure%20scheduled%20tasks.md)
7. [Glossary](Glossary.md)

[<img width="100%" src="buttons/next-Objective.svg" alt="Objective">](Objective.md)

## Buy me a coffee

You can always buy me a coffee here:

[![PayPal](https://img.shields.io/badge/PayPal-Donate-blue.svg?logo=paypal&style=for-the-badge)](https://www.paypal.com/donate/?business=AKVCM878H36R6&no_recurring=0&item_name=Buy+me+a+coffee&currency_code=USD)
[![Ko-Fi](https://img.shields.io/badge/Ko--fi-Donate-blue.svg?logo=kofi&style=for-the-badge)](https://ko-fi.com/jurgencruz)

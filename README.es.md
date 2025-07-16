# Servidor NAS, Media Center y Home Automation

[![en](https://img.shields.io/badge/lang-en-blue.svg)](README.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](README.es.md)

Esta es una guía de como configurar un servidor casero desde cero. Si usted no está familiarizado con algún concepto, la guía provee un glosario al final de la misma para su conveniencia.

## Indice

1. [Objetivo](Objective.es.md)
2. [Motivación](Motivation.es.md)
3. [Características](Features.es.md)
4. [Diseño y justificación](Design%20and%20justification.es.md)
5. [Prerequisitos mínimos](Minimum%20prerequisites.es.md)
6. [Guía](Guide.es.md)
    1. [Instalar Fedora Server](Install%20fedora%20server.es.md)
    2. [Configurar Secure Boot](Configure%20secure%20boot.es.md)
    3. [Instalar y configurar Zsh (Opcional)](Install%20and%20configure%20zsh%20optional.es.md)
    4. [Instalar Cockpit](Install%20cockpit.es.md)
    5. [Registrar DDNS (Opcional)](Register%20ddns%20optional.es.md)
    6. [Configurar usuarios](Configure%20users.es.md)
    7. [Instalar ZFS](Install%20zfs.es.md)
    8. [Configurar ZFS](Configure%20zfs.es.md)
        1. [Crear alberca ZFS](Create%20zfs%20pool.es.md)
        2. [Importar alberca ZFS existente](Import%20existing%20zfs%20pool.es.md)
        3. [Migrar discos de la alberca ZFS](Migrate%20zfs%20pool%20drives.es.md)
    9. [Configurar shares](Configure%20shares.es.md)
    10. [Instalar Docker](Install%20docker.es.md)
    11. [Crear stack de redes compartidas](Create%20shared%20networks%20stack.es.md)
    12. [Crear y configurar stack de Nextcloud](Create%20and%20configure%20nextcloud%20stack.es.md)
    13. [Crear y configurar stack de Home Assistant](Create%20and%20configure%20home%20assistant%20stack.es.md)
    14. [Crear y configurar stack de tráfico externo privado (Opcional)](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.es.md)
    15. [Crear y configurar stack de aplicaciones arr](Create%20and%20configure%20arr%20applications%20stack.es.md)
    16. [Configurar DNS](Configure%20dns.es.md)
        1. [Configurar DNS del router](Configure%20router%20dns.es.md)
        2. [Configurar DNS de Technitium](Configure%20technitium%20dns.es.md)
            1. [Configurar DHCP del router](Configure%20router%20dhcp.es.md)
            2. [Configurar DHCP de Technitium](Configure%20technitium%20dhcp.es.md)
    17. [Crear y configurar stack de tráfico externo público (Opcional)](Create%20and%20configure%20public%20external%20traffic%20stack%20optional.es.md)
    18. [Configurar tareas programadas](Configure%20scheduled%20tasks.es.md)
7. [Glosario](Glossary.es.md)

[<img width="100%" src="buttons/next-Objective.es.svg" alt="Objetivo">](Objective.es.md)

## Cómpreme un café

Siempre puede invitarme un café aquí:

[![PayPal](https://img.shields.io/badge/PayPal-Donate-blue.svg?logo=paypal&style=for-the-badge)](https://www.paypal.com/donate/?business=AKVCM878H36R6&no_recurring=0&item_name=Buy+me+a+coffee&currency_code=USD)
[![Ko-Fi](https://img.shields.io/badge/Ko--fi-Donate-blue.svg?logo=kofi&style=for-the-badge)](https://ko-fi.com/jurgencruz)

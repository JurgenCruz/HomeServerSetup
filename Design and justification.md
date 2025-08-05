# Design and justification

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Design%20and%20justification.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Design%20and%20justification.es.md)

- Fedora Server: Fedora Server provides a combination of stability and modernity as an operating system. By having a short release cycle we can have access to new technologies and it is not necessary to do a complete update like Debian. At the same time, it is not a rolling release distribution, so we will not have instabilities after updating.
- Entire system encryption: A secure and private system requires avoiding modification and reading of the system without user consent. This is why it is necessary to encrypt data on all media. The OS is encrypted using LUKS with a password, while the hard drives will be encrypted using native ZFS encryption with a key. The key will remain in the encrypted OS partition, such that it cannot be accessed without first unlocking the OS with the password, while also allowing not to require a second password.
- Secure Boot enabled: To ensure the security and privacy of the server, it is necessary to secure the computer's boot chain. This can only be achieved with Secure Boot enabled.
- ZFS File system: ZFS is a robust file system selected for using COW (copy-on-write), RAIDZ feature for disk redundancy, native snapshots, native encryption and compression. It is one of the best options as a file system for a NAS.
- Samba shares for multimedia files: Samba allows remote access to NAS files securely and compatible with multiple operating systems. Allows the use of ACLs to specify file access permissions and ensure privacy.
- Nextcloud for multi-user file backup: Nextcloud allows file access and syncing across multiple devices and supports different users for better privacy.
- Docker as a containerization engine: Docker is the most used and simplest containerization engine. To keep the server accessible, we are going to avoid using other more complex engines such as Kubernetes and Podman.
- Gotify as notifications engine: Gotify allows communication between services and clients through websockets and push notifications with no dependency on third-parties.
- ARR application ecosystem: This group of microservices provides a home entertainment system with access to movies and series that is completely automated and customizable with an intuitive interface and complete control.
- Technitium as DNS and DHCP server: Technitium helps us block domains from advertising, tracking and malware while allowing us to configure split horizon DNS and DHCP in a single service.
- Home Assistant as a home automation system: Home Assistant is free software and completely independent of the cloud, providing privacy, security and complete control of your home.
- Cockpit as server manager: Cockpit provides a one-stop remote server administration through a web browser with a graphical user interface for greater convenience.
- Portainer as a container manager: Although Cockpit has the ability to manage containers, it only supports Podman and not Docker. Portainer allows us to manage containers remotely from a web browser with a graphical interface, instead of the terminal, and is compatible with Docker.
- qBittorrent with VPN: The bittorrent protocol allows access to a very large, distributed, free and, in most cases, public file library. In order to maintain online privacy, a remote anonymous VPN for the bittorrent protocol is necessary.
- WireGuard as protocol for local VPN: To be able to access critical systems remotely, it is necessary not to expose them publicly but through a secure VPN. WireGuard is an open source, modern, secure and efficient VPN protocol and is ideal for creating a personal VPN connected to our local network.
- DuckDNS: DuckDNS offers a free DDNS service that also supports multiple subdomain levels. For example: `myhome.duckdns.org` and `jellyfin.myhome.duckdns.org` will be mapped to the same IP. This is very useful as it allows us to have our own subdomains that the reverse proxy can use in its rules.

[<img width="33.3%" src="buttons/prev-Features.svg" alt="Features">](Features.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Minimum prerequisites.svg" alt="Minimum prerequisites">](Minimum%20prerequisites.md)

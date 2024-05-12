# Create Docker stack

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20docker%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20docker%20stack.es.md)

We will prepare the anonymous VPN configuration file that qBittorrent requires; we will configure the stack; we will configure the firewall to allow the necessary ports; and we will bring the stack up through Portainer. The stack consists of the following containers:

- qBittorrent: Download manager through the bittorrent protocol.
- Sonarr: Series manager.
- Radarr: Movie manager.
- Prowlarr: Search engine manager.
- Bazarr: Subtitle manager.
- Flaresolverr: CAPTCHA solver.
- Jellyfin: Media service.
- Jellyseerr: Media request manager and catalog service.
- Technitium: DNS and DHCP server.
- Nginx Proxy Manager: Reverse Proxy engine and manager.
- Home Assistant: Home automation engine.
- WireGuard: VPN for the local network.

## Steps

1. Copy the anonymous VPN configuration file for bittorrent: `scp user@host:/path/to/vpn.conf /Apps/qbittorrent/wireguard/tun0.conf`. Change `{user@host:/path/to/vpn.conf}` to the address of the file on the computer that contains the file. This file must be provided by your VPN provider if you select WireGuard as the protocol. You can also use a USB stick to transfer the configuration file. If your provider requires using OpenVPN you will have to change the container configuration. For more information read the container's guide: https://github.com/Trigus42/alpine-qbittorrentvpn.
2. If you are going to use a local VPN, run: `./scripts/iptable_setup.sh`. Adds a kernel module at system startup required for WireGuard.
3. Edit the stack file: `nano ./files/docker-compose.yml`.
4. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
5. Replace the XXX with the `uid` and `gid` of the user `mediacenter`. You can use `id mediacenter` to get the `uid` and `gid`.
6. If a GPU is not going to be used, delete the `runtime` and `deploy` sections of the `jellyfin` container.
7. If you are going to use OpenVPN for bittorrent, update the `qbittorrent` container according to the official guide.
8. If you are not going to use a local VPN, remove the `wireguard` container, otherwise replace `myhome` with the subdomain you registered on DuckDNS.org and set the `ALLOWEDIPS` variable in case `192.168 .1.0/24` is not the CIDR range of your local network. Do not remove `10.13.13.0` as it is the internal WireGuard network and you will lose connectivity if you remove it. If you assigned a different IP to Technitium, update the `PEERDNS` variable with the right IP. Do not remove `10.13.13.1` as it is the internal WireGuard DNS and it won't work. The guide assumes 2 clients that will connect to the VPN with the IDs: `phone` and `laptop`. If you require more or fewer clients, add or remove or rename the client IDs as you wish.
9. If you are not going to expose the server to the internet, remove the `nginx` container.
10. Set the `lanvlan` network.
    1. Set the `parent` attribute with the device you used to create the auxiliary macvlan network before. For example`enp1s0`.
    2. Set the `subnet` attribute with your local network's range.
    3. Set the `gateway` attribute with your router's IP.
    4. Set the`ip_range` attribute with your local network's range that the DHCP does not assign. The guide configured Technitium not to assign the first 64 addresses, thus we use a range of 192.168.1.0/27. If you configured your DHCP with another non-assignable range, use that here.
    5. Set the `host` attribute with the server's IP in the auxiliary macvlan network.
11. Set the attribute `ipv4_address` in the `technitium` container with an IP in the non-assignable range of the DHCP. For example 192.168.1.10.
12. Set the attribute `ipv4_address` in the `homeassistant` container with an IP in the non-assignable range of the DHCP. For example 192.168.1.11.
13. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
14. Run: `./scripts/container_firewalld_services.sh`. Configure Firewalld for containers. The script opens the ports for DHCP and DNS for Technitium; the ports for HTTP and HTTPS for Nginx and the port for WireGuard. If you are not going to use any of these services, edit the script and remove any unnecessary rules.
15. Run: `./scripts/run_portainer.sh`. This runs a Portainer Community Edition container and will listen on port `9443`.
16. Configure Portainer from the browser.
    1. Access Portainer through https://192.168.1.253:9443. If you get a security alert, you can accept the risk since Portainer uses a self-signed SSL certificate.
    2. Set a random password and create user `admin`. Bitwarden is recommended again for this.
    3. Click "Get Started" and then select "local."
    4. Select "Stacks" and create a new stack.
    5. Name it "apps" and paste the content of the docker-compose.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Portainer and not in the file.
    6. Navigate to "Environments" > "local" and change "Public IP" with the server's hostname `server.lan`.

[<img width="50%" src="buttons/prev-Install docker.svg" alt="Install Docker">](Install%20docker.md)[<img width="50%" src="buttons/next-Configure applications.svg" alt="Configure applications">](Configure%20applications.md)

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

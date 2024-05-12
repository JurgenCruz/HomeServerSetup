# Configure host's network

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20hosts%20network.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20hosts%20network.es.md)

To prevent connection configurations from being broken in the future, it is useful to assign the server a static IP on the local network. We will configure the server to not use DHCP and assign itself an IP on the network. Also, we will create an auxiliary macvlan network to be able to communicate with Home Assistant which will be in a Docker macvlan. The guide will assume a local network with CIDR range 192.168.1.0/24, with the router at the second to last address (192.168.1.254) and the server at the third to last address (192.168.1.253). If you need to use another range, just replace it with the correct range in the rest of the guide.

## Steps

1. Run: `./scripts/disable_resolved.sh`. We disable the local DNS service "systemd-resolved" to free up the DNS port that Technitium needs.
2. Look for the name of the active physical network device, for example `enp1s0` or `eth0`: `nmcli device status`. If there is more than one physical device, select the one that is connected to the router with the best speed. Replace `enp1s0` in the following commands with the correct device.
3. Assign static IP and CIDR range: `nmcli con mod enp1s0 ipv4.addresses 192.168.1.253/24`. Typically home routers use a CIDR range of `/24` or its equivalent subnet mask `255.255.255.0`. Check your router's manual for more information.
4. Disable DHCP client: `nmcli con mod enp1s0 ipv4.method manual`.
5. Configure the router IP: `nmcli con mod enp1s0 ipv4.gateway 192.168.1.254`. Normally the router assigns itself a static IP which is the second to last IP in the IP range.
6. Configure Technitium as DNS and Cloudflare as fallback DNS: `nmcli con mod enp1s0 ipv4.dns "192.168.1.10 1.1.1.1"`. If you like to use another DNS like Google's, you can change it.
7. Reactivate the device for the changes to take effect: `nmcli con up enp1s0`. This may terminate the SSH session. if so, `ssh` to the server again.
8. Add auxiliary macvlan connection: `nmcli con add con-name macvlan-shim type macvlan ifname macvlan-shim ip4 192.168.1.12/32 dev enp1s0 mode bridge`. `192.168.1.12` is the server's IP inside this auxiliary network. If your local network is in another prefix, adjust this IP to one inside the prefix but outside the DHCP assignable range to avoid collisions.
9. Add route to auxiliary connection to macvlan network: `nmcli con mod macvlan-shim +ipv4.routes "192.168.1.0/27"`. `192.168.1.0/27` is the IP range of the macvlan network which matches with the local network's prefix at the same time it is outside the DHCP assignable IP range.
10. Activate auxiliary connection: `nmcli con up macvlan-shim`.

[<img width="50%" src="buttons/prev-Configure zfs.svg" alt="Configure ZFS">](Configure%20zfs.md)[<img width="50%" src="buttons/next-Configure shares.svg" alt="Configure shares">](Configure%20shares.md)

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

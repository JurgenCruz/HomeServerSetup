# Create shared networks stack

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20shared%20networks%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20shared%20networks%20stack.es.md)

We will create an auxiliary macvlan network to be able to communicate with Home Assistant which will be in a Docker macvlan. The guide will assume a local network with CIDR range 192.168.1.0/24, with the router at the second to last address (192.168.1.254) and the server at the third to last address (192.168.1.253). If you need to use another range, just replace it with the correct range in the rest of the guide. Then, we will configure the shared networks Docker stack and bring the stack up through Portainer. The stack consists of the following networks:

- lanvlan: This is a virtual network that will allow containers to be assigned an IP directly in our LAN without sharing ports with the server.

## Steps

1. Add auxiliary macvlan connection: `nmcli con add con-name macvlan-shim type macvlan ifname macvlan-shim ip4 192.168.1.12/32 dev enp1s0 mode bridge`. `192.168.1.12` is the server's IP inside this auxiliary network. If your local network is in another prefix, adjust this IP to one inside the prefix but outside the DHCP assignable range to avoid collisions.
2. Add route to auxiliary connection to macvlan network: `nmcli con mod macvlan-shim +ipv4.routes "192.168.1.0/27"`. `192.168.1.0/27` is the IP range of the macvlan network which matches with the local network's prefix at the same time it is outside the DHCP assignable IP range.
3. Activate auxiliary connection: `nmcli con up macvlan-shim`.
4. Edit the stack file: `nano ./files/network-stack.yml`.
5. Set the `lanvlan` network.
    1. Set the `parent` attribute with the device you used to create the auxiliary macvlan network before. For example`enp1s0`.
    2. Set the `subnet` attribute with your local network's range.
    3. Set the `gateway` attribute with your router's IP.
    4. Set the`ip_range` attribute with your local network's range that the DHCP does not assign. The guide configured Technitium not to assign the first 64 addresses, thus we use a range of 192.168.1.0/27. If you configured your DHCP with another non-assignable range, use that here.
    5. Set the `host` attribute with the server's IP in the auxiliary macvlan network.
6. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
7. Add stack in Portainer from the browser.
    1. Access Portainer through https://192.168.1.253:9443. If you get a security alert, you can accept the risk since Portainer uses a self-signed SSL certificate.
    2. Click "Get Started" and then select "local."
    3. Select "Stacks" and create a new stack.
    4. Name it "networks" and paste the content of the network-stack.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Portainer and not in the file.

[<img width="33.3%" src="buttons/prev-Install docker.svg" alt="Install Docker">](Install%20docker.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Create and configure home assistant stack.svg" alt="Create and configure Home Assistant stack">](Create%20and%20configure%20home%20assistant%20stack.md)

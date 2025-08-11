# Create and configure private external traffic stack (Optional)

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.es.md)

This guide assumes an OpenWrt router is being used. OpenWrt routers have the possibility of running the local VPN directly from the router. This is better because, not only will it offload some work from the server, it also means that if the server were to go down, the VPN would still work and allow you to connect to your server to troubleshoot. If you don't have a VPN capable router however, you can follow this section to run the VPN from the server. If you have an OpenWrt router, you can follow this guide instead: https://openwrt.org/docs/%20guide-user/services/vpn/wireguard/server#luci_web_interface_instructions

> [!NOTE]
> When following that guide, you can use `10.13.13.1/24` as the subnet instead of `10.0.0.1/24` as the guide recommends so that it matches with this guide. Also, while setting up the `WireGuard Peers`, it is recommended to use a single IP CIDR (e.g. `10.13.13.2/32` instead of `10.0.0.10/24` like the guide suggests) for `Allowed IPs` so a peer gets the same IP assigned everytime. The guide also uses the default `0.0.0.0/0` for `Allowed IPs` during peer configuration generation. If you prefer to have split tunneling like this guide, remove the defaults and instead add `192.168.1.0/24` (use your LAN subnet if different) and `10.13.13.0/24`. Don't forget to change the `endpoint` to `wg.myhome.duckdns.org` when generating the configuration as well.

We will configure the private traffic Docker stack; we will configure the firewall to allow the necessary port; and we will bring the stack up through Portainer. We will do Port Forwarding of port 51820 for WireGuard. Finally, we will configure the clients that are going to connect to it. This can be done in 2 ways: through a QR code or through a `.conf` file. Once connected to this VPN, we will be able to access services that we did not expose publicly with our Reverse Proxy such as Portainer and Cockpit, which are too critical to expose to attacks on the public internet. The stack consists of the following container:

- WireGuard: VPN for the local network.

> [!NOTE]
> WireGuard will be configured with split tunneling. If you want to redirect all client traffic, then you must change the `ALLOWEDIPS` variable in the stack in Portainer to `0.0.0.0/0`.

## Steps

1. Run: `./scripts/create_wireguard_folder.sh` to generate the container directory on the SSD.
2. Run: `./scripts/iptable_setup.sh`. Adds a kernel module at system startup required for WireGuard.
3. Edit the stack file: `nano ./files/private-traffic-stack.yml`.
4. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
5. Replace the XXX with the `uid` and `gid` of the user `mediacenter`. You can use `id mediacenter` to get the `uid` and `gid`.
6. Replace `myhome` with the subdomain you registered on DuckDNS.org and set the `ALLOWEDIPS` variable in case `192.168 .1.0/24` is not the CIDR range of your local network. Do not remove `10.13.13.0` as it is the internal WireGuard network, and you will lose connectivity if you remove it. If you assigned a different IP to your DNS (for example if you used Technitium), update the `PEERDNS` variable with the right IP. Do not remove `10.13.13.1` as it is the internal WireGuard DNS and it won't work. The guide assumes 2 clients that will connect to the VPN with the IDs: `phone` and `laptop`. If you require more or fewer clients, add or remove or rename the client IDs as you wish.
7. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
8. Run: `./scripts/wireguard_firewalld_services.sh`. Configure Firewalld for WireGuard. The script opens the ports for WireGuard.
9. Add stack in Portainer from the browser.
    1. Access Portainer through https://portainer.myhome.duckdns.org.
    2. Click "Get Started" and then select "local."
    3. Select "Stacks" and create a new stack.
    4. Name it "private-traffic" and paste the content of the private-traffic-stack.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Portainer and not in the file.
10. Configure the router. Each router is different, so you will have to consult your manual to be able to do the following step.
    1. Forward port 51820 in UDP to the server.
11. If you want to configure with a QR code, do the following:
    1. Access Portainer on your local network from a device that is not the client you are configuring.
    2. Navigate to `local` > `Containers`.
    3. In the `wireguard` container row press the `exec console` button.
    4. Press `Connect`.
    5. Show the QR code for the client `phone` in the console with: `/app/show-peer phone`.
    6. From the device that will be the `phone` client (your cell phone for example), open the WireGuard application and select `Add tunnel`.
    7. Choose `Scan QR code` and scan the code that was displayed on the console.
    8. If you want to test that it works correctly, disconnect your device from the local network (turn off Wi-Fi for example) and enable the VPN. Try to access an IP on your local network.
12. If you want to configure with a configuration file, do the following (Note: the guide assumes a Linux device that already has the `wireguard-tools` package or equivalent installed. For other OS, please read the WireGuard documentation):
    1. Connect to the server from the device that will be the client with SSH: `ssh admin@server.lan` .
    2. We show the configuration for the `laptop` client: `sudo cat /Apps/wireguard/peer_laptop/peer_laptop.conf`.
    3. Copy the contents of the file to the clipboard.
    4. Return to the client device console with `exit` or open a new console.
    5. We create the configuration file for a virtual network with the name `wg0`: `sudo nano /etc/wireguard/wg0.conf`.
    6. Paste the contents of the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
    7. If you want to test that it works correctly, disconnect your device from the local network (connect to your guest Wi-Fi network or from the public network of a cafe or use your cell phone as a modem) and enable the virtual network `wg0` with : `wg-quick up wg0`. Try to access an IP on your local network.

[<img width="33.3%" src="buttons/prev-Create and configure home assistant stack.svg" alt="Create and configure Home Assistant stack">](Create%20and%20configure%20home%20assistant%20stack.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Configure scheduled tasks.svg" alt="Configure scheduled tasks">](Configure%20scheduled%20tasks.md)
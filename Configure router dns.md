# Configure router DNS

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20router%20dns.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20router%20dns.es.md)

Each router is different, so you might need to read the manual on how to do specific steps. The guide will use an OpenWrt router as an example since it's open source nature aligns with the spirit of this guide.

We will configure our upstream DNS and use DNS-over-HTTPS (DoH) for better privacy; we will configure DHCP IP ranges; we will set a static IP for the server; we will configure the DNS to add the devices with static IP to the `lan` domain; and finally, configure the Split Horizon for our DuckDNS.org subdomain, so it can work inside our LAN.

## Steps

1. Access to your router's portal, for example through https://192.168.1.254. Use your router's IP.
2. Log in with your router's credentials.
3. Configure upstream DNS.
    1. Navigate to "System" > "Software".
    2. Click `Update lists...` button.
    3. Under `Download and install package` input `luci-app-https-dns-proxy`. Click `OK`.
    4. Navigate to "Services" > "HTTPS DNS Proxy". If you don't see it, try rebooting your router.
    5. The plugin comes with Cloudflare and Google DNS preconfigured. Remove Google DNS from the bottom list or choose your provider here.
    6. At the top, make sure that the service is enabled and started. You should see the `Start` and `Enable` buttons disabled. If not, click on them.
    7. Click the `Save & Apply` button.
4. Configure Adblock.
    1. Navigate to "System" > "Software".
    2. Click `Update lists...` button.
    3. Under `Download and install package` input `luci-app-adblock`. Click `OK`.
    4. Navigate to "Services" > "Adblock". If you don't see it, try rebooting your router.
    5. Navigate to "Blocklist Sources" tab.
    6. In `Sources`, select the block lists that you prefer.
    7. Click the `Save & Apply` button.
5. Configure DHCP range.
    1. Navigate to "Network" > "Interfaces".
    2. Edit the `lan` interface.
    3. Navigate to "DHCP Server" tab.
    4. Set `Start` to `64` and `Limit` to `189`.
    5. Click the `Save` button.
    6. Click the `Save & Apply` button.
6. Set static IP for server.
    1. Look for the name of the active physical network device, for example `enp1s0` or `eth0`: `nmcli device status`. If there is more than one physical device, select the one that is connected to the router with the best speed. Replace `enp1s0` in the following commands with the correct device.
    2. Assign static IP and CIDR range: `nmcli con mod enp1s0 ipv4.addresses 192.168.1.253/24`. Typically home routers use a CIDR range of `/24` or its equivalent subnet mask `255.255.255.0`. Check your router's manual for more information.
    3. Disable DHCP client: `nmcli con mod enp1s0 ipv4.method manual`.
    4. Configure the router IP: `nmcli con mod enp1s0 ipv4.gateway 192.168.1.254`. Normally the router assigns itself a static IP which is the second to last IP in the IP range.
    5. Configure the router as DNS and Cloudflare as fallback DNS: `nmcli con mod enp1s0 ipv4.dns "192.168.1.254 1.1.1.1"`. If you like to use another DNS like Google's, you can change it.
    6. Reactivate the device for the changes to take effect: `nmcli con up enp1s0`. This may terminate the SSH session. if so, `ssh` to the server again.
7. Set static IPv6 for server (Optional). Only if your router is using IPv6.
    1. Navigate to "Network" > "DHCP" > "Leases".
    2. Click the `Add` button.
    3. `Hostname`: `server`.
    4. `MAC Addresses`: select the MAC Address of the server from the list.
    5. `IPv4`: `192.168.1.253`.
    6. `DUID/IAIDs`: select the DUID for the server. Make sure the IAID is the one for the main network device and not for the macvlan shim we created before.
    7. `IPv6 Token`: `fffd`.
    8. Click the `Save` button.
    9. Navigate to "Network" > "Interfaces" > "Global network options".
    10. Make sure there is a ULA Prefix set and write it down. if not, you can generate a new one with https://simpledns.plus/private-ipv6 like before.
    11. If you have more than one lan interface (like a guest or iot interface), make sure you set the IPv6 assignment hint to `1` for the `lan` interface.
    12. Click the `Save & Apply` button. Your server should now have an IPv6 address that starts with that ULA prefix and ends with `fffd`. If not, make sure your `lan` interface is allowing ULA in the prefix filter or try resetting the server network to ask for a new IPv6 address.
8. Add services with static IP to the `lan` domain. Since they don't use DHCP, the router won't add them to the hosts list. We have not created Home Assistant service yet, but it will have its IP ready.
    1. Navigate to "Network" > "DHCP and DNS" > "Hostnames".
    2. Click the `Add` button.
    3. `Hostname`: `homeassistant`.
    4. `IP Address`: `192.168.1.11`.
    5. Click the `Save` button.
    6. Click the `Save & Apply` button.
9. Add Split Horizon DNS for our subdomain.
    1. Navigate to "General" tab.
    2. `Addresses`: `/.myhome.duckdns.org/192.168.1.253` & `/.myhome.duckdns.org/XXXX::fffd` where XXXX::fffd is the ULA IPv6 of the server. You can see this address in the "Leases" tab under "Active DHCPv6 Leases". If you don't have IPv6, just use the IPv4 line.
    3. Click the `Save & Apply` button.

[<img width="33.3%" src="buttons/prev-Configure dns.svg" alt="Configure DNS">](Configure%20dns.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Create and configure public external traffic stack optional.svg" alt="Create and configure public external traffic stack">](Create%20and%20configure%20public%20external%20traffic%20stack.md)

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
4. Configure DHCP range.
    1. Navigate to "Network" > "Interfaces".
    2. Edit the `lan` interface.
    3. Navigate to "DHCP Server" tab.
    4. Set `Start` to `64` and `Limit` to `189`.
    5. Click the `Save` button.
    6. Click the `Save & Apply` button.
5. Set static IP for server.
    1. Look for the name of the active physical network device, for example `enp1s0` or `eth0`: `nmcli device status`. If there is more than one physical device, select the one that is connected to the router with the best speed. Replace `enp1s0` in the following commands with the correct device.
    2. Assign static IP and CIDR range: `nmcli con mod enp1s0 ipv4.addresses 192.168.1.253/24`. Typically home routers use a CIDR range of `/24` or its equivalent subnet mask `255.255.255.0`. Check your router's manual for more information.
    3. Disable DHCP client: `nmcli con mod enp1s0 ipv4.method manual`.
    4. Configure the router IP: `nmcli con mod enp1s0 ipv4.gateway 192.168.1.254`. Normally the router assigns itself a static IP which is the second to last IP in the IP range.
    5. Configure the router as DNS and Cloudflare as fallback DNS: `nmcli con mod enp1s0 ipv4.dns "192.168.1.254 1.1.1.1"`. If you like to use another DNS like Google's, you can change it.
    6. Reactivate the device for the changes to take effect: `nmcli con up enp1s0`. This may terminate the SSH session. if so, `ssh` to the server again.
6. Add services with static IP to the `lan` domain. Since they don't use DHCP, the router won't add them to the hosts list.
    1. Navigate to "Network" > "DHCP and DNS" > "Hostnames".
    2. Click the `Add` button.
    3. `Hostname`: `server`.
    4. `IP Address`: `192.168.1.253`.
    5. Click the `Save` button.
    6. Click the `Add` button.
    7. `Hostname`: `homeassistant`.
    8. `IP Address`: `192.168.1.11`.
    9. Click the `Save` button.
    10. Click the `Save & Apply` button.
7. Add Split Horizon DNS for our subdomain.
    1. Navigate to "General" tab.
    2. `Addresses`: `/.myhome.duckdns.org/192.168.1.253`
    3. Click the `Save & Apply` button.

[<img width="33.3%" src="buttons/prev-Configure dns.svg" alt="Configure DNS">](Configure%20dns.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Create and configure public external traffic stack optional.svg" alt="Create and configure public external traffic stack (Optional)">](Create%20and%20configure%20public%20external%20traffic%20stack%20optional.md)

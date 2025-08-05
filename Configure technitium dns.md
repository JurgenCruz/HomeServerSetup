# Configure Technitium DNS

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20technitium%20dns.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20technitium%20dns.es.md)

Technitium is a DNS and DHCP server that runs from a Docker container. We will configure the Technitium DNS Docker stack; we will configure the firewall to allow the necessary ports; and we will bring the stack up through Portainer. Since the DNS will run inside the server, we need to assign the server a static IP on the local network. We will configure the server to not use DHCP and assign itself an IP on the network. The stack consists of the following containers:

- Technitium: DNS and DHCP server.

## Steps

1. Run: `./scripts/create_technitium_folder.sh` to generate the container directory on the SSD.
2. Edit the stack file: `nano ./files/technitium-stack.yml`.
3. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Set the attribute `ipv4_address` in the `technitium` container with an IP in the non-assignable range of the DHCP. For example 192.168.1.10.
5. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
6. Run: `./scripts/dns_firewalld_services.sh`. Configure Firewalld for containers. The script opens the port for DNS for Technitium.
7. Add stack in Portainer from the browser.
    1. Access Portainer through https://server.lan:9443. If you get a security alert, you can accept the risk since Portainer uses a self-signed SSL certificate.
    2. Click "Get Started" and then select "local."
    3. Select "Stacks" and create a new stack.
    4. Name it "technitium" and paste the content of the docker-compose.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Portainer and not in the file.
8. Run: `./scripts/disable_resolved.sh`. We disable the local DNS service "systemd-resolved" to free up the DNS port that Technitium needs.
9. Look for the name of the active physical network device, for example `enp1s0` or `eth0`: `nmcli device status`. If there is more than one physical device, select the one that is connected to the router with the best speed. Replace `enp1s0` in the following commands with the correct device.
10. Assign static IP and CIDR range: `nmcli con mod enp1s0 ipv4.addresses 192.168.1.253/24`. Typically home routers use a CIDR range of `/24` or its equivalent subnet mask `255.255.255.0`. Check your router's manual for more information.
11. Disable DHCP client: `nmcli con mod enp1s0 ipv4.method manual`.
12. Configure the router IP: `nmcli con mod enp1s0 ipv4.gateway 192.168.1.254`. Normally the router assigns itself a static IP which is the second to last IP in the IP range.
13. Configure Technitium as DNS and Cloudflare as fallback DNS: `nmcli con mod enp1s0 ipv4.dns "192.168.1.10 1.1.1.1"`. If you like to use another DNS like Google's, you can change it.
14. Reactivate the device for the changes to take effect: `nmcli con up enp1s0`. This may terminate the SSH session. if so, `ssh` to the server again.
15. Access Technitium through https://192.168.1.10/.
16. Create an admin user and a password. It is again recommended to use Bitwarden for the same.
17. Navigate to `Settings` tab.
18. In the `General` tab, make sure the `Enable DNSSEC Validation` field is enabled.
19. Navigate to `Web Service` tab and enable the `Enable HTTP to HTTPS Redirection` option. The rest of the options should have been configured in the `technitium-stack.yml`.
20. Navigate to `Blocking` tab and configure.
    1. Select `ANY Address` for the `Blocking Type` option.
    2. Add blocklist addresses to the `Allow/Block List URLs` list. Some recommendations of pages where you can get lists: https://easylist.to/ and https://firebog.net/.
21. Navigate to `Proxy & Forwarders` tab and select `Cloudflare (DNS-over-HTTPS)`. It should add to the `Forwarders` list and select `DNS-over-HTTPS` as the `Forwarder Protocol`. If you wish to use a different provider or protocol you can select or configure a different one here.
22. Navigate to `Zones` tab and configure:
    1. Click the `Àdd Zone` button.
    2. `Zone`: `lan`.
    3. Click the `Add` button.
    4. Click the `Add Record` button.
    5. `Name`: `server`. This will configure our server in our `lan` domain since our server has static IP and doesn't use DHCP.
    6. `IPv4 Address`: `192.168.1.253`. Use the static IP you assigned to your server.
    7. Click the `Add Record` button.
    8. `Name`: `homeassistant`. This will configure Home Assistant in our `lan` domain with a static IP since it won't use DHCP. We have not created Home Assistant service yet, but it will have its IP ready.
    9. `IPv4 Address`: `192.168.1.11`. Use the static IP you assigned to Home Assistant in `home-assistant-stack.yml`.
    10. Click the `Add Record` button.
    11. `Name`: `technitium`. This will configure Technitium in our `lan` domain since it doesn't add itself.
    12. `IPv4 Address`: `192.168.1.10`. Use the static IP you assigned to Technitium in `technitium-stack.yml`.
    13. Click the `Back` button.
    14. If you are not going to expose you server to the internet, you can skip the rest of this step.
    15. Click the `Àdd Zone` button.
    16. `Zone`: `myhome.duckdns.org`. Use the subdomain you registered in DuckDNS.org.
    17. Click the `Add` button.
    18. Click the `Add Record` button.
    19. `Name`: `@`. This will configure the root subdomain to point to our server.
    20. `IPv4 Address`: `192.168.1.253`. Use the static IP you assigned to your server.
    21. Click the `Add Record` button.
    22. `Name`: `*`. This will configure a wildcard subdomain to point to our server.
    23. `IPv4 Address`: `192.168.1.253`. Use the static IP you assigned to your server.
    24. Click the `Back` button.
23. If any page is being blocked and you do not want to block it, Navigate to `Allowed` tab and add the domain to the list.

Depending on your hardware the DHCP will be configured differently. Please select the option that matches your situation. If you have control over the DNS that your router's DHCP provides, select `Configure router DHCP`. Otherwise, select `Configure Technitium DHCP`.

[<img width="100%" src="buttons/jump-Configure router dhcp.svg" alt="Configure router DHCP">](Configure%20router%20dhcp.md)
[<img width="100%" src="buttons/jump-Configure technitium dhcp.svg" alt="Configure Technitium DHCP">](Configure%20technitium%20dhcp.md)
[<img width="33.3%" src="buttons/prev-Configure dns.svg" alt="Configure DNS">](Configure%20dns.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Configure router dhcp.svg" alt="Configure router DHCP">](Configure%20router%20dhcp.md)

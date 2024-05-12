# Configure public external traffic

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20public%20external%20traffic.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20public%20external%20traffic.es.md)

If you do not plan to access your server outside of your local network, you can skip this section.

We will do Port Forwarding of the HTTP and HTTPS ports for Nginx and port 51820 for WireGuard; we will disable IPv6 as it would complicate the configuration too much; conditionally we will disable DHCP on the router or configure Technitium as the DHCP DNS; we will configure Nginx to redirect traffic to the containers; and we will allow Nginx to act as a proxy for Home Assistant.

## Steps

1. Configure the router. Each router is different, so you will have to consult your manual to be able to do the following steps.
    1. Forward port 80 and 443 in TCP protocol to the server so that Nginx can reverse proxy the internal services. If you plan to use private VPN with WireGuard, then also forward port 51820 in UDP to the server.
    2. Disable IPv6 because Technitium can only do IPv4 with the established configuration and it is more complex to configure it for IPv6.
    3. If your router allows you to configure the DNS that DHCP assigns to all devices in the house, then use Technitium's IP instead of the one provided by the ISP. Otherwise, you will have to disable DHCP so that Technitium is the DHCP and can assign itself as DNS. You can find Technitium's IP in Portainer if you view the stack in the editor and look at the `technitium` container configuration.
    4. Verify that the Technitium or router's DHCP is working (connect a device to the network and verify that it was assigned an IP in the configured range and that the DNS is the server's IP).
2. Configure proxy hosts in Nginx using DDNS.
    1. Access Nginx through http://server.lan:8181.
    2. Use ` admin@example.com ` and `changeme` as username and password and change the details and password to a secure one. It is again recommended to use Bitwarden for the same.
    3. Navigate to the `SSL Certificates` tab.
    4. Press `Add SSL Certificate`. Select `Let's Encrypt` as certificate provider.
        1. Set up a wildcard domain SSL certificate with Let's Encrypt. For example `*.myhome.duckdns.org` (note the `*` at the beginning of the domain).
        2. You need to enable `Use DNS Challenge`.
        3. Select DuckDNS as the DNS provider.
        4. Replace `your-duckdns-token` with the token you generated on DuckDNS.org
        5. Accept the terms of service and save.
    5. Navigate to the “Proxy Hosts” tab and configure a proxy host for Jellyfin.
        1. In the `Details` tab fill out:
            - "Domain Names": jellyfin.myhome.duckdns.org.
            - "Scheme": http.
            - "Forward Hostname/IP": jellyfin. We can use the container name because Docker has an internal DNS that maps the container name to Docker's internal IP.
            - "Forward Port": 8096. Use the internal port of the container, not the port of the server to which it was mapped. Check the port of each container in the Portainer stack.
            - "BlockCommonExploits": enabled.
            - "Websockets Support": enabled. Jellyfin and Home Assistant need it, the other services don't seem to need it. If you notice any problems with any service when accessing it through Nginx (and not from the direct port), try enabling this option.
        2. In the `SSL` tab fill out:
            - "SSL Certificate": *.myhome.duckdns.org. We use the certificate created in step 4.
            - "Force SSL": enabled.
            - "HTTP/2 Support": enabled.
            - "HSTS Enabled": enabled.
            - "HSTS Subdomains": enabled.
        3. In the `Advanced` tab fill in (Note: this is only necessary for Jellyfin, the other services do not require anything in the `Advanced` tab):
            ```sh
            # Disable buffering when the nginx proxy gets very resource heavy upon streaming
            proxy_buffering off;

            # Proxy main Jellyfin traffic
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_headers_hash_max_size 2048;
            proxy_headers_hash_bucket_size 128;

            #Security/XSS Mitigation Headers
            # NOTE: X-Frame-Options may cause issues with the webOS app
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-XSS-Protection "0";
            add_header X-Content-Type-Options "nosniff";
            ```
        4. Repeat this step for Bazarr, Home Assistant, Jellyseerr, Prowlarr, Radarr, Sonarr and qBittorrent. **Do not expose Portainer or Cockpit with Nginx!**
3. Configure Home Assistant to allow traffic redirected by the Nginx Reverse Proxy.
    1. Edit Home Assistant configuration: `nano /Apps/homeassistant/configuration.yaml`.
    2. Add the following section to the end of the file. We allow proxies from the `172.21.3.0/24` network which is the `nginx` network that we configured in the stack in Portainer.
        ```yml
        http:
            use_x_forwarded_for: true
            trusted_proxies:
                - 172.21.3.0/24
        ```
    3. Save and exit with `Ctrl + X, Y, Enter`.
4. Reload the Home Assistant settings from the UI for the changes to take effect.
    1. Access Home Assistant through http://homeassistant.lan:8123.
    2. Navigate to `Developer tools`.
    3. Press `Restart`.
5. You can test that Nginx works by accessing a service through the URL with its subdomain. For example https://jellyfin.myhome.duckdns.org. Try it from inside your local network to test split horizon DNS and from outside to test DDNS. If you already registered apps in your phone using the local IP, replace it with either the duckdns.org URL or the LAN URL.

[<img width="50%" src="buttons/prev-Configure scheduled tasks.svg" alt="Configure scheduled tasks">](Configure%20scheduled%20tasks.md)[<img width="50%" src="buttons/next-Configure private external traffic.svg" alt="Configure private external traffic">](Configure%20private%20external%20traffic.md)

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

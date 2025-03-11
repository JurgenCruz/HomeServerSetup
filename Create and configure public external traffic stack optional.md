# Create and configure public external traffic stack (Optional)

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20public%20external%20traffic%20stack%20optional.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20public%20external%20traffic%20stack%20optional.es.md)

If you do not plan to access your server outside of your local network, you can skip this section.

We will configure the public traffic Docker stack; we will configure the firewall to allow the necessary ports; we will bring the stack up through Portainer; we will do Port Forwarding of the HTTP and HTTPS ports for Nginx; we will configure Nginx to redirect traffic to the containers; and we will allow Nginx to act as a proxy for Home Assistant. The stack consists of the following containers:

- Nginx Proxy Manager: Reverse Proxy engine and manager.

## Steps

1. Run: `./scripts/create_nginx_folder.sh` to generate the container directory on the SSD.
2. Edit the stack file: `nano ./files/public-traffic-stack.yml`.
3. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
5. Run: `./scripts/public_traffic_firewalld_services.sh`. Configure Firewalld for containers. The script opens the ports for HTTP and HTTPS for Nginx.
6. Add stack in Portainer from the browser.
    1. Access Portainer through https://192.168.1.253:9443. If you get a security alert, you can accept the risk since Portainer uses a self-signed SSL certificate.
    2. Click "Get Started" and then select "local."
    3. Select "Stacks" and create a new stack.
    4. Name it "public-traffic" and paste the content of the public-traffic-stack.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Portainer and not in the file.
7. Configure the router. Each router is different, so you will have to consult your manual to be able to do the following steps.
    1. Forward port 80 and 443 in TCP protocol to the server so that Nginx can reverse proxy the internal services.
8. Configure proxy hosts in Nginx using DDNS.
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
9. Configure Home Assistant to allow traffic redirected by the Nginx Reverse Proxy.
    1. Edit Home Assistant configuration: `nano /Apps/homeassistant/configuration.yaml`.
    2. Add the following section to the end of the file. We allow proxies from the `172.21.3.0/24` network which is the `nginx` network that we configured in the stack in Portainer.
        ```yml
        http:
            use_x_forwarded_for: true
            trusted_proxies:
                - 172.21.1.0/24
        ```
    3. Save and exit with `Ctrl + X, Y, Enter`.
10. Reload the Home Assistant settings from the UI for the changes to take effect.
    1. Access Home Assistant through http://homeassistant.lan:8123.
    2. Navigate to `Developer tools`.
    3. Press `Restart`.
11. You can test that Nginx works by accessing a service through the URL with its subdomain. For example https://jellyfin.myhome.duckdns.org. Try it from inside your local network to test split horizon DNS and from outside to test DDNS. If you already registered apps in your phone using the local IP, replace it with either the duckdns.org URL or the LAN URL.

[<img width="33.3%" src="buttons/prev-Configure dns.svg" alt="Configure DNS">](Configure%20dns.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Configure scheduled tasks.svg" alt="Configure scheduled tasks">](Configure%20scheduled%20tasks.md)

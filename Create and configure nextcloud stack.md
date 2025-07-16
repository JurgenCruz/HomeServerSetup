# Create and configure Nextcloud stack

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20nextcloud%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20nextcloud%20stack.es.md)

We will configure the Nextcloud Docker stack and bring the stack up through Portainer. The stack consists of the following container:

- Nextcloud: File backup and synchronization engine.
- Redis: Memory cache.
- MariaDB: Database.
- Nextcloud-cron: Scheduled tasks' executor.

## Steps

1. Run: `./scripts/create_nextcloud_folder.sh` to generate the container directory on the SSD.
2. Edit the stack file: `nano ./files/nextcloud-stack.yml`.
3. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Replace `NEXTCLOUD_TRUSTED_DOMAINS=server.lan nextcloud.myhome.duckdns.org` with your server hostname and your registered subdomain in DuckDNS.org. If you are not exposing the service to the internet, you can leave only your server hostname.
5. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
6. Add stack in Portainer from the browser.
    1. Access Portainer through https://192.168.1.253:9443. If you get a security alert, you can accept the risk since Portainer uses a self-signed SSL certificate.
    2. Click "Get Started" and then select "local."
    3. Select "Stacks" and create a new stack.
    4. Name it "nextcloud" and paste the content of the nextcloud-stack.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Portainer and not in the file.
7. Access Nextcloud through http://server.lan:10098.
8. Use the following credentials: username `admin`, password `nextcloud`.
9. Use the wizard to complete the setup.
10. Go into the user settings and change the password. It is again recommended to use Bitwarden for the same.
11. You can go into the `Administration settings` and change what you want.
12. Go to `Accounts` and create accounts for your users.
13. Install the Nextcloud client in your devices from this link: https://nextcloud.com/install/.
14. When you configure the client, use one of the domains from step 4 to access.

[<img width="33.3%" src="buttons/prev-Create shared networks stack.svg" alt="Create shared networks stack">](Create%20shared%20networks%20stack.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Create and configure home assistant stack.svg" alt="Create and configure Home Assistant stack">](Create%20and%20configure%20home%20assistant%20stack.md)

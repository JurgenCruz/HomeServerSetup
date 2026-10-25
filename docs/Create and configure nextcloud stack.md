# Create and configure Nextcloud stack

We will configure the Nextcloud Docker stack and bring the stack up through Arcane. The stack consists of the following container:

- Nextcloud: File backup and synchronization engine.
- Redis: Memory cache.
- MariaDB: Database.
- Nextcloud-cron: Scheduled tasks' executor.

## Steps

1. Run: `./scripts/create_nextcloud_folder.sh` to generate the container directory on the SSD.
2. Copy database config file: `cp ./files/my.cnf /Apps/nextcloud/db/config/`. This contains performance optimizations recommended by Nextcloud.
3. Edit the stack file: `nano ./files/nextcloud-stack.yml`.
4. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
5. Replace `NEXTCLOUD_TRUSTED_DOMAINS=server.lan nextcloud.myhome.duckdns.org` with your server hostname and your registered subdomain in DuckDNS.org. If you are not exposing the service to the internet, you can leave only your server hostname.
6. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
7. Add stack in Arcane from the browser.
    1. Access Arcane through https://arcane.myhome.duckdns.org.
    2. Click "Projects" on the left menu and create a new project.
    3. Name it "nextcloud" and paste the content of the nextcloud-stack.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Arcane and not in the file.
8. Access Nextcloud through https://nextcloud.myhome.duckdns.org.
9. Use the following credentials: username `admin`, password `nextcloud`.
10. Use the wizard to complete the setup.
11. Go into the user settings and change the password. It is again recommended to use Bitwarden for the same.
12. You can go into the `Administration settings` and change what you want.
13. Go to `Accounts` and create accounts for your users.
14. Install the Nextcloud client in your devices from this link: https://nextcloud.com/install/.
15. When you configure the client, use one of the domains from step 4 to access.

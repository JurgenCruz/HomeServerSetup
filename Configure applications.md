# Configure applications

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20applications.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20applications.es.md)

The containers should be running now, however, they require some configuration to work with each other.

## Configure Technitium

1. Access Technitium through https://192.168.1.10/.
2. Create an admin user and a password. It is again recommended to use Bitwarden for the same.
3. Configure Technitium as a DHCP server to be able to assign itself as DNS. If your router has the option to change the DNS assigned by DHCP or if you do not plan to expose your server to the internet, skip this step.
    1. Click the `DHCP` tab.
    2. Click the `Scopes` tab.
    3. Click the `Edit` button.
    4. Set the `Starting Address` and `Ending Address` fields with the IP range of your local network. Make sure to leave some IPs unassignable at the beginning of the network. For example if your local network range is 192.168.1.0/24, start at 192.168.1.64.
    5. Set the `Domain Name` field to `lan`.
    6. Set the `Router Address` field with the IP of your router.
    7. Click the `Save` button.
    8. Click the `Enable` button on the `Default` scope row.
4. Navigate to `Settings` tab.
5. In the `General` tab, make sure the `Enable DNSSEC Validation` field is enabled.
6. Navigate to `Web Service` tab and enable the `Enable HTTP to HTTPS Redirection` option. The rest of the options should have been configured in the `docker-compose.yaml`.
7. Navigate to `Blocking` tab and configure.
    1. Select `ANY Address` for the `Blocking Type` option.
    2. Add blocklist addresses to the `Allow/Block List URLs` list. Some recommendations of pages where you can get lists: https://easylist.to/ and https://firebog.net/.
8. Navigate to `Proxy & Forwarders` tab and select `Cloudflare (DNS-over-HTTPS)`. It should add to the `Forwarders` list and select `DNS-over-HTTPS` as the `Forwarder Protocol`. If you wish to use a different provider or protocol you can select or configure a different one here.
9. Navigate to `Zones` tab and configure:
    1. Click the `Àdd Zone` button.
    2. `Zone`: `lan`.
    3. Click the `Add` button.
    4. Click the `Add Record` button.
    5. `Name`: `server`. This will configure our server in our `lan` domain since our server has static IP and doesn't use DHCP.
    6. `IPv4 Address`: `192.168.1.253`. Use the static IP you assigned to your server.
    7. Click the `Add Record` button.
    8. `Name`: `homeassistant`. This will configure Home Assistant in our `lan` domain since it has static IP and doesn't use DHCP.
    9. `IPv4 Address`: `192.168.1.11`. Use the static IP you assigned to Home Assistant in `docker-compose.yaml`.
    10. Click the `Add Record` button.
    11. `Name`: `technitium`. This will configure Technitium in our `lan` domain since it doesn't add itself.
    12. `IPv4 Address`: `192.168.1.10`. Use the static IP you assigned to Technitium in `docker-compose.yaml`.
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
10. If any page is being blocked and you do not want to block it, Navigate to `Allowed` tab and add the domain to the list.

## Configure qBittorrent

1. Access qBittorrent through http://192.168.1.253:10095.
2. Use `admin` and `adminadmin` as username and password.
3. Click the `Options` button.
4. Configure `Downloads` tab. Make the following changes:
    1. "Default Torrent Management Mode" : "Automatic".
    2. "Default Save Path": "/MediaCenter/torrents".
    3. Optional: If you want to save the `.torrent` files in case you need to download something again, you can enable "Copy .torrent files for finished downloads to" and assign: "/MediaCenter/torrents/backup".
5. Configure `Connection` tab. Make the following changes:
    1. Disable "Use UPnP / NAT-PMP port forwarding from my router".
    2. If you like, you can adjust the connection limits.
6. Configure `Speed` tab. Make the following changes:
    1. In the "Alternative Rate Limits" > "Upload" section: Set it to one third of your provider's upload speed.
    2. In the "Alternative Rate Limits" > "Download" section: Set it to one third of your provider's download speed.
    3. Enable "Schedule the use of alternative rate limits".
    4. Choose the time when the Internet is used at home for other things. For example: 08:00 - 01:00 every day.
7. Configure `BitTorrent` tab. Make the following changes:
    1. Disable `Enable Local Peer Discovery to find more peers` since there is nothing local in the container.
    2. If you like to stop seeding after a goal, you can enable and adjust the limits here. For example "When the rate reaches 1".
8. Configure `Web UI` tab. Make the following changes:
    1. Change the password to a more secure one. It is again recommended to use Bitwarden for the same.
    2. Enable "Bypass authentication for clients on localhost".
    3. Enable "Bypass authentication for clients in whitelisted IP subnets".
    4. Add `172.21.0.0/24` to the list below. This will allow containers in Docker's `arr` network to be accessed without a password.
9. Configure `Advanced` tab. Make the following changes:
    1. Ensure that the "Network Interface" is `tun0`. If not it means you are not using your VPN and the traffic will not be anonymous.
    2. Enable "Reannounce to all trackers when IP or port changed".
    3. Enable "Always announce to all trackers in a tier".
    4. Enable "Always announce to all tiers".
10. Save.

## Configure Radarr

1. Access Radarr through http://192.168.1.253:7878.
2. Set password. It is again recommended to use Bitwarden for the same. Leave the authentication method as `Forms` and do not disable authentication.
3. Navigate to "Settings" > "Media Management" and configure.
    1. "Standard Movie Format": `{Movie CleanTitle} {(Release Year)} [imdbid-{ImdbId}] - {Edition Tags }{[Custom Formats]}{[Quality Full]}{[MediaInfo 3D]}{ [MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels}]{MediaInfo AudioLanguages}[{MediaInfo VideoBitDepth}bit][{Mediainfo VideoCodec}]{-Release Group}`.
    2. Click "Add Root Folder" and select "/MediaCenter/media/movies".
4. Navigate to "Settings" > "Download Clients" and configure.
    1. Add new client.
    2. Select "qBittorrent".
    3. "Name": "qBittorrent".
    4. "Host": "qbittorrent".
    5. "Port": "8080".
    6. "Category": "movies".
    7. Click "Test" and then "Save."
5. Navigate to "Settings" > "General".
6. Copy the API Key to a notepad as we will need it later.
7. To configure the "Profiles", "Quality" and "Custom Formats" tabs, it is recommended to use the following guide: https://trash-guides.info/Radarr/

## Configure Sonarr

1. Access Sonarr through http://192.168.1.253:8989.
2. Set password. It is again recommended to use Bitwarden for the same. Leave the authentication method as `Forms` and do not disable authentication.
3. Navigate to "Settings" > "Media Management" and configure.
    1. "Standard Episode Format": `{Series TitleYear} - S{season:00}E{episode:00} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}`.
    2. "Daily Episode Format": `{Series TitleYear} - {Air-Date} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]} {[MediaInfo VideoCodec]}{-Release Group}`.
    3. "Anime Episode Format": `{Series TitleYear} - S{season:00}E{episode:00} - {absolute:000} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}[{MediaInfo VideoBitDepth}bit]{[MediaInfo VideoCodec]}[{Mediainfo AudioCodec} { Mediainfo AudioChannels}]{MediaInfo AudioLanguages}{-Release Group}`.
    4. "Season Folder Format": "Season {season:00}".
    5. Click "Add Root Folder" and select "/MediaCenter/media/tv".
4. Navigate to "Settings" > "Download Clients" and configure.
    1. Add new client.
    2. Select "qBittorrent".
    3. "Name": "qBittorrent".
    4. "Host": "qbittorrent".
    5. "Port": "8080".
    6. "Category": "tv".
    7. Click "Test" and then "Save."
5. Navigate to "Settings" > "General".
6. Copy the API Key to a notepad as we will need it later.
7. To configure the "Profiles", "Quality" and "Custom Formats" tabs, it is recommended to use the following guide: https://trash-guides.info/Sonarr/

## Configure Prowlarr

1. Access Prowlarr through http://192.168.1.253:8989.
2. Set password. It is again recommended to use Bitwarden for the same. Leave the authentication method as `Forms` and do not disable authentication.
3. Navigate to "Settings" > "Indexers" and configure.
    1. Add new proxy.
    2. Select "FlareSolverr".
    3. "Name": "FlareSolverr".
    4. "Tags": "proxy".
    5. "Host": "http://flaresolverr:8191/".
    6. Click "Test" and then "Save."
4. Navigate to "Settings" > "Apps" and configure.
    1. Add new application.
    2. Select "Radarr"
    3. "Name": "Radarr".
    4. "Sync Level": "Full Sync".
    5. "Tags": "radarr".
    6. "Prowlarr Server": "http://prowlarr:9696".
    7. "Radarr Server": "http://radarr:7878".
    8. "API Key": paste the Radarr API Key that we copied before.
    9. Click "Test" and then "Save."
    10. Add new application.
    11. Select "Sonarr"
    12. "Name": "Sonarr".
    13. "Sync Level": "Full Sync".
    14. "Tags": "sonarr".
    15. "Prowlarr Server": "http://prowlarr:9696".
    16. "Sonarr Server": "http://sonarr:8989".
    17. "API Key": paste the Sonarr API Key that we copied before.
    18. Click "Test" and then "Save."
5. Navigate to "Settings" > "Download Clients" and configure.
    1. Add new client.
    2. Select "qBittorrent".
    3. "Name": "qBittorrent".
    4. "Host": "qbittorrent".
    5. "Port": "8080".
    6. "Default Category": "manual".
    7. Click "Test" and then "Save."
6. Navigate to "Indexers" and configure.
    1. Add indexer.
    2. Choose the indexer of your preference.
    3. Configure the indexer to your preference.
    4. "Tags": Add "sonarr" if you want to use this indexer with Sonarr. Add "radarr" if you want to use this indexer with Radarr. Add "proxy" if this indexer requires FlareSolverr.
    5. Click "Test" and then "Save."
    6. Repeat the steps for any other indexers you want. Prowlarr will push the indexers' details to Radarr and Sonarr.

## Configure Bazarr

1. Access Bazarr through http://192.168.1.253:6767.
2. Set password. It is again recommended to use Bitwarden for the same. Leave the authentication method as `Forms` and do not disable authentication.
3. Navigate to "Settings" > "Languages" and configure.
    1. "Languages Filter": Select the languages you are interested in downloading. It's a good idea to have a backup language in case one doesn't exist for your preferred one.
    2. Click "Add New Profile".
    3. "Name": The name of the primary language.
    4. Add primary language and backup languages in the order of your preference.
    5. "Cutoff": Select the primary language.
    6. Save.
    7. If you want other languages, you can repeat adding another profile.
    8. Select the default language for series and movies.
    9. Save.
4. Navigate to "Settings" > "Providers" and configure.
    1. Add the subtitle providers of your choice.
5. Navigate to “Settings” > “Sonarr” and configure.
    1. Enable Sonarr.
    2. "Host" > "Address": "sonarr".
    3. "Host" > "Port": "8989".
    4. "Host" > "API Key": Paste the Sonarr API Key that we copied before.
    5. Click "Test" and then "Save."
6. Navigate to “Settings” > “Radarr” and configure.
    1. Enable Radarr.
    2. "Host" > "Address": "radarr".
    3. "Host" > "Port": "7878".
    4. "Host" > "API Key": Paste the Radarr API Key that we copied before.
    5. Click "Test" and then "Save."
7. To configure other tabs, it is recommended to use the following guide: https://trash-guides.info/Bazarr/

## Configure Jellyfin

1. Access Jellyfin through http://192.168.1.253:8096.
2. Follow the wizard to create a new username and password. It is again recommended to use Bitwarden for the same.
3. Open side panel and navigate to "Administration" > "Dashboard".
4. If you have GPU, navigate to "Playback" and configure.
    1. Select your GPU. The guide will assume "NVidia NVENC".
    2. Enable the codecs that your GPU model supports.
    3. Enable "Enable enhanced NVDEC decoder".
    4. Enable "Enable hardware encoding".
    5. Enable "Allow encoding in HEVC format".
    6. If you like, you can configure other parameters to your liking.
    7. Save.
5. Navigate to "Networking" and configure:
    1. "Known proxies": "nginx".
    2. Save.
6. Navigate to "Plugins" > "Catalog" and configure.
    1. If there will be Anime in your collection, install "AniDB" and "AniList".
    2. Install "TMBd Box Sets", "TVmaze" and "TheTVDB".
7. For the plugins to take effect, restart Jellyfin from Portainer.
8. Navigate to “Libraries” and configure.
    1. Add library.
    2. "Content Type": "Movies".
    3. "Name": "Movies".
    4. "Folders": Add "/MediaCenter/media/movies".
    5. Sort "Metadata downloaders": "TheMovieDb", "AniDB", "AniList", "The Open Movie Database".
    6. Sort "Image fetchers": "TheMovieDb", "The Open Movie Database", "AniDB", "AniList", "Embedded Image Extractor", "Screen Grabber".
    7. Configure the other options to your liking and Save.
    8. Add library.
    9. "Content Type": "Shows".
    10. "Name": "Shows".
    11. "Folders": Add "/MediaCenter/media/tv".
    12. Sort "Metadata downloaders (TV Shows)": "TheTVDB", "TVmaze", "TheMovieDb", "AniDB", "AniList", "The Open Movie Database".
    13. Sort "Metadata downloaders (Seasons)": "TVmaze", "TheMovieDb", "AniDB".
    14. Sort "Metadata downloaders (Episodes)": "TheTVDB", "TVmaze", "TheMovieDb", "AniDB", "The Open Movie Database".
    15. Sort "Image fetchers (TV Shows)": "TheTVDB", "TVmaze", "TheMovieDb", "AniList", "AniDB".
    16. Sort "Image fetchers (Seasons)": "TheTVDB", "TVmaze", "TheMovieDb", "AniDB", "AniList".
    17. Sort "Image fetchers (Episodes)": "TheTVDB", "TVmaze", "TheMovieDb", "The Open Movie Database", "Embedded Image Extractor", "Screen Grabber".
    18. Configure the other options as you like and Save.
9. Navigate to "Users" and configure.
    1. If more people are going to use Jellyfin, Create more users and configure them as you like.
10. Navigate to your profile (User icon top right) > "Subtitles".
    1. "Preferred subtitle language": Your primary language. Save.
    2. You can configure the rest of your profile if you wish.

## Configure Jellyseerr

1. Access Jellyseerr through http://192.168.1.253:5055.
2. Login with Jellyfin.
    1. Click "Use Jellyfin Account".
    2. "Jellyfin URL": "http://jellyfin:8096"
    3. Log in with your username and password.
3. Configure libraries.
    1. Click "Sync Libraries".
    2. Enable "Movies", "Shows" and "Collections".
    3. Click "Start Scan".
    4. Click "Continue".
4. Configure Sonarr and Radarr.
    1. Click "Add Radarr Server".
    2. Enable "Default Server".
    3. "Server Name": "Movies".
    4. "Hostname or IP Address": "radarr".
    5. "Port": "7878".
    6. "API Key": Paste the Radarr API Key that we copied before.
    7. Click on "Test".
    8. "Quality Profile": choose the default quality profile you want to use.
    9. "Root Folder": "/MediaCenter/media/movies".
    10. "Minimum Availability": "Announced."
    11. Enable "Enable Scan".
    12. Save.
    13. Click "Add Sonarr Server".
    14. Enable "Default Server".
    15. "Server Name": "Series".
    16. "Hostname or IP Address": "sonarr".
    17. "Port": "8989".
    18. "API Key": Paste the Sonarr API Key that we copied before.
    19. Click on "Test".
    20. "Quality Profile": choose the default quality profile you want to use.
    21. "Root Folder": "/MediaCenter/media/tv".
    22. "Anime Quality Profile": choose the default quality profile you want to use for Anime. Leave blank if you will not be having anime in your collection.
    23. "Anime Root Folder": "/MediaCenter/media/tv".
    24. Enable "Season Folders".
    25. Enable "Enable Scan".
    26. Save.
5. Import users.
    1. Navigate to "Users".
    2. Click on "Import Jellyfin Users".
    3. You can configure users by clicking "Edit" in the row of the user you want to configure.
6. If you wish to configure more options, Navigate to "Settings" and make the desired changes.

## Configure Home Assistant

1. Access Home Assistant through http://192.168.1.11:8123.
2. Use the wizard to create a user account and password. It is again recommended to use Bitwarden for the same.
3. Configure the name of the Home Assistant instance and your data and preferences with the wizard.
4. Choose whether you want to send usage data to the Home Assistant page.
5. Finish the wizard.
6. Configure Webhook for notifications.
    1. Navigate to "Settings" > "Automations & Scenes".
    2. Click "Create Automation".
    3. Click "Create new Automation".
    4. Click "Add Trigger".
    5. Search for "Webhook" and select.
    6. Name the trigger "A Problem is reported".
    7. Change the webhook id to "notify".
    8. Click on the configuration gear and enable only "POST" and "Only accessible from the local network".
    9. Click "Add Action".
    10. Search for "send persistent notification" and select.
    11. Click on the Action Menu and select "Edit in YAML" and add the following:
        ```yaml
        alias: Notify Web
        service: notify.persistent_notification
        metadata: {}
        data:
            title: Issue found in server!
            message: "Issue in server: {{trigger.json.problem}}"
        ```
    12. If you want to receive notifications on your cell phone, you must first download the application to your cell phone and log in to Home Assistant from it. Then configure the following:
    13. Click "Add Action".
    14. Search for "mobile" and select "Send notification via mobile_app".
    15. Click on the Action Menu and select "Edit in YAML" and add the following:
        ```yaml
        alias: Notify Mobile
        service: notify.mobile_app_{mobile_name}
        metadata: {}
        data:
            title: Issue found in server!
            message: "Issue in server: {{trigger.json.problem}}"
        ```
    16. Save.

[<img width="50%" src="buttons/prev-Create docker stack.svg" alt="Create Docker stack">](Create%20docker%20stack.md)[<img width="50%" src="buttons/next-Configure scheduled tasks.svg" alt="Configure scheduled tasks">](Configure%20scheduled%20tasks.md)

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

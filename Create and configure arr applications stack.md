# Create and configure arr applications stack

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20arr%20applications%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20arr%20applications%20stack.es.md)

We will prepare the anonymous VPN configuration file that qBittorrent requires; we will configure the arr apps Docker stack; and we will bring the stack up through Portainer. The stack consists of the following containers:

- qBittorrent: Download manager through the bittorrent protocol.
- Sonarr: Series manager.
- Radarr: Movie manager.
- Prowlarr: Search engine manager.
- Bazarr: Subtitle manager.
- Flaresolverr: CAPTCHA solver.
- Jellyfin: Media service.
- Jellyseerr: Media request manager and catalog service.

## Create stack

1. Run: `./scripts/create_arr_folders.sh` to generate the container directories on the SSD.
2. Copy the anonymous VPN configuration file for bittorrent: `scp user@host:/path/to/vpn.conf /Apps/qbittorrent/wireguard/tun0.conf`. Change `{user@host:/path/to/vpn.conf}` to the address of the file on the computer that contains the file. This file must be provided by your VPN provider if you select WireGuard as the protocol. You can also use a USB stick to transfer the configuration file. If your provider requires using OpenVPN you will have to change the container configuration. For more information read the container's guide: https://github.com/Trigus42/alpine-qbittorrentvpn.
3. Edit the stack file: `nano ./files/arr-stack.yml`.
4. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
5. Replace the XXX with the `uid` and `gid` of the user `mediacenter`. You can use `id mediacenter` to get the `uid` and `gid`.
6. If a GPU is not going to be used, delete the `runtime` and `deploy` sections of the `jellyfin` container.
7. If you are going to use OpenVPN for bittorrent, update the `qbittorrent` container according to the official guide.
8. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
9. Add stack in Portainer from the browser.
    1. Access Portainer through https://192.168.1.253:9443. If you get a security alert, you can accept the risk since Portainer uses a self-signed SSL certificate.
    2. Click "Get Started" and then select "local."
    3. Select "Stacks" and create a new stack.
    4. Name it "arr" and paste the content of the docker-compose.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Portainer and not in the file.

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
    4. Add `172.21.3.0/24` to the list below. This will allow containers in Docker's `arr` network to be accessed without a password.
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
    1. "Known proxies": "nginx". If you are not going to expose the server to the internet, you can skip this step.
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

[<img width="33.3%" src="buttons/prev-Create and configure private external traffic stack optional.svg" alt="Create and configure private external traffic stack (Optional)">](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Configure dns.svg" alt="Configure DNS">](Configure%20dns.md)

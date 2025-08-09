# Crear y configurar stack de aplicaciones arr

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20arr%20applications%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20arr%20applications%20stack.es.md)

Prepararemos el archivo de configuración de la VPN anónima que requiere qBittorrent; configuraremos el stack de Docker de arr apps; y levantaremos el stack a través de Portainer. El stack consiste de los siguientes contenedores:

- Gotify: Motor de notificaciones.
- qBittorrent: Administrador de descargas a través del protocolo bittorrent.
- Sonarr: Administrador de series.
- Radarr: Administrador de películas.
- Prowlarr: Administrador de motores de búsqueda.
- Bazarr: Administrador de subtítulos.
- Flaresolverr: Solucionador de CAPTCHAs.
- Jellyfin: Servicio de medios.
- Jellyseerr: Administrador de peticiones de medios y servicio de catálogo.

## Crear stack

1. Ejecutar: `./scripts/create_arr_folders.sh` para generar los directorios de los contenedores en el SSD.
2. Copiar el archivo de configuración de la VPN anónima para bittorrent: `scp user@host:/path/to/vpn.conf /Apps/qbittorrent/wireguard/tun0.conf`. Cambiar `{user@host:/path/to/vpn.conf}` por la dirección del archivo en la computadora que contenga el archivo. Este archivo debe ser proporcionado por su proveedor de VPN si selecciona WireGuard como protocolo. También puede usar una memoria USB para transferir el archivo de configuración. Si su proveedor requiere usar OpenVPN tendrá que cambiar la configuración del contenedor. Para más información lea la guía del contenedor: https://github.com/Trigus42/alpine-qbittorrentvpn.
3. Editar el archivo del stack: `nano ./files/arr-stack.yml`.
4. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
5. Reemplazar las XXX con el `uid` y `gid` del usuario `mediacenter`. Se puede usar `id mediacenter` para obtener el `uid` y `gid`.
6. Si no se va a usar GPU, borrar las secciones de `runtime` y `deploy` del contenedor `jellyfin`.
7. Si se va a usar OpenVPN para bittorrent, actualizar el contenedor `qbittorrent` de acuerdo a la guía oficial.
8. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
9. Agregar stack en Portainer desde el navegador.
    1. Acceder a Portainer a través de https://portainer.micasa.duckdns.org.
    2. Darle clic en "Get Started" y luego seleccionar "local".
    3. Seleccionar "Stacks" y crear un nuevo stack.
    4. Ponerle nombre "arr" y pegar el contenido del docker-compose.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Portainer y no en el archivo.

## Configurar Gotify

1. Acceder a Gotify a través de https://gotify.micasa.duckdns.org.
2. Usar `admin` y `admin` como usuario y contraseña.
3. Hacer clic en `Admin` en la parte superior y cambiar la contraseña por una más segura. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
4. Hacer clic en `Apps` en la parte superior y crear 3 Apps:

   |      Name      |         Description          | Priority |
   |:--------------:|:----------------------------:|:--------:|
   | Home Assistant | Home Assistant notifications |    0     |
   |      Arr       |      Aar notifications       |    0     |
   |      NAS       |   NAS system notifications   |    8     |

5. Copiar y anota los tokens generados para cada App.
6. Opcionalmente, puede subir iconos para cada App para distinguir la fuente de la notificación.

> [!TIP]
> Si quiere tener un icono diferente para cada App Arr (o si simplemente quiere tener un control más granular), puede registrar un canal por cada App Arr en vez de un solo canal `Arr`.

## Configurar qBittorrent

1. Acceder a qBittorrent a través de https://qbittorrent.micasa.duckdns.org.
2. Usar `admin` y `adminadmin` como usuario y contraseña.
3. Hacer clic en el botón `Options`.
4. Configurar pestaña `Downloads`. Hacer los siguientes cambios:
    1. "Default Torrent Management Mode" : "Automatic".
    2. "Default Save Path": "/MediaCenter/torrents".
    3. Opcional: Si quiere guardar los archivos `.torrent` por si necesita descargar de nuevo algo puede habilitar "Copy .torrent files for finished downloads to" y asignar: "/MediaCenter/torrents/backup".
5. Configurar pestaña `Connection`. Hacer los siguientes cambios:
    1. Deshabilitar "Use UPnP / NAT-PMP port forwarding from my router".
    2. Si gusta puede ajustar los límites de conexiones.
6. Configurar pestaña `Speed`. Hacer los siguientes cambios:
    1. En la sección de "Alternative Rate Limits" > "Upload": Poner un tercio de la velocidad de subida de su proveedor.
    2. En la sección de "Alternative Rate Limits" > "Download": Poner un tercio de la velocidad de bajada de su proveedor.
    3. Habilitar "Schedule the use of alternative rate limits".
    4. Escoger el horario en el cual se usa el Internet en el hogar para otras cosas. Por ejemplo: 08:00 - 01:00 todos los días.
7. Configurar pestaña `BitTorrent`. Hacer los siguientes cambios:
    1. Deshabilitar `Enable Local Peer Discovery to find more peers` ya que no hay nada local en el contenedor.
    2. Si gusta dejar de ser semilla después de una meta, puede habilitar y ajustar los límites aquí. Por ejemplo "Cuando la taza llegue a 1".
8. Configurar pestaña `Web UI`. Hacer los siguientes cambios:
    1. Cambiar la contraseña por una más segura. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
    2. Habilitar "Bypass authentication for clients on localhost".
    3. Habilitar "Bypass authentication for clients in whitelisted IP subnets".
    4. Agregar `172.21.3.0/24` a la lista debajo. Esto permitirá a los contenedores en la red `arr` de Docker acceder sin contraseña.
9. Configurar pestaña `Advanced`. Hacer los siguientes cambios:
    1. Asegurar que el "Network Interface" sea `tun0`. Si no quiere decir que no está usando su VPN y el tráfico no será anónimo.
    2. Habilitar "Reannounce to all trackers when IP or port changed".
    3. Habilitar "Always announce to all trackers in a tier".
    4. Habilitar "Always announce to all tiers".
10. Guardar.

## Configurar Radarr

1. Acceder a Radarr a través de https://radarr.micasa.duckdns.org.
2. Configurar contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo. Dejar el método de autenticación como `Forms` y no deshabilitar la autenticación.
3. Navegar a "Settings" > "Media Management" y configurar.
    1. "Standard Movie Format": `{Movie CleanTitle} {(Release Year)} [imdbid-{ImdbId}] - {Edition Tags }{[Custom Formats]}{[Quality Full]}{[MediaInfo 3D]}{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels}]{MediaInfo AudioLanguages}[{MediaInfo VideoBitDepth}bit][{Mediainfo VideoCodec}]{-Release Group}`.
    2. Hacer clic en "Add Root Folder" y seleccionar "/MediaCenter/media/movies".
4. Navegar a "Settings" > "Download Clients" y configurar.
    1. Agregar nuevo cliente.
    2. Seleccionar "qBittorrent".
    3. "Name": "qBittorrent".
    4. "Host": "qbittorrent".
    5. "Port": "8080".
    6. "Category": "movies".
    7. Hacer clic en "Test" y luego "Save".
5. Navegar a "Settings" > "Connect" y configurar.
    1. Agregar nueva conexión.
    2. Seleccionar "Gotify".
    3. "Name": "Gotify".
    4. Habilitar los desencadenantes para los que desee recibir notificaciones.
    5. "Gotify Server": "http://gotify".
    6. "App Token": Ingresar el token que se generó en Gotify para las Apps Arr.
    7. Hacer clic en "Test" y luego "Save".
6. Navegar a "Settings" > "General".
7. Copiar el "API Key" a un bloc de notas, ya que lo necesitaremos más tarde.
8. Para configurar las pestañas de "Profiles", "Quality" y "Custom Formats" se recomienda el uso de la siguiente guía: https://trash-guides.info/Radarr/

## Configurar Sonarr

1. Acceder a Sonarr a través de https://sonarr.micasa.duckdns.org.
2. Configurar contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo. Dejar el método de autenticación como `Forms` y no deshabilitar la autenticación.
3. Navegar a "Settings" > "Media Management" y configurar.
    1. "Standard Episode Format": `{Series TitleYear} - S{season:00}E{episode:00} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}`.
    2. "Daily Episode Format": `{Series TitleYear} - {Air-Date} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}`.
    3. "Anime Episode Format": `{Series TitleYear} - S{season:00}E{episode:00} - {absolute:000} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}[{MediaInfo VideoBitDepth}bit]{[MediaInfo VideoCodec]}[{Mediainfo AudioCodec} { Mediainfo AudioChannels}]{MediaInfo AudioLanguages}{-Release Group}`.
    4. "Season Folder Format": "Season {season:00}".
    5. Hacer clic en "Add Root Folder" y seleccionar "/MediaCenter/media/tv".
4. Navegar a "Settings" > "Download Clientes" y configurar.
    1. Agregar nuevo cliente.
    2. Seleccionar "qBittorrent".
    3. "Name": "qBittorrent".
    4. "Host": "qbittorrent".
    5. "Port": "8080".
    6. "Category": "tv".
    7. Hacer clic en "Test" y luego "Save".
5. Navegar a "Settings" > "Connect" y configurar.
    1. Agregar nueva conexión.
    2. Seleccionar "Gotify".
    3. "Name": "Gotify".
    4. Habilitar los desencadenantes para los que desee recibir notificaciones.
    5. "Gotify Server": "http://gotify".
    6. "App Token": Ingresar el token que se generó en Gotify para las Apps Arr.
    7. Hacer clic en "Test" y luego "Save".
6. Navegar a "Settings" > "General".
7. Copiar el "API Key" a un bloc de notas, ya que lo necesitaremos más tarde.
8. Para configurar las pestañas de "Profiles", "Quality" y "Custom Formats" se recomienda el uso de la siguiente guía: https://trash-guides.info/Sonarr/

## Configurar Prowlarr

1. Acceder a Prowlarr a través de https://prowlarr.micasa.duckdns.org.
2. Configurar contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo. Dejar el método de autenticación como `Forms` y no deshabilitar la autenticación.
3. Navegar a "Settings" > "Indexers" y configurar.
    1. Agregar nuevo proxy.
    2. Seleccionar "FlareSolverr".
    3. "Name": "FlareSolverr".
    4. "Tags": "proxy".
    5. "Host": "http://flaresolverr:8191/".
    6. Hacer clic en "Test" y luego "Save".
4. Navegar a "Settings" > "Apps" y configurar.
    1. Agregar nueva aplicación.
    2. Seleccionar "Radarr"
    3. "Name": "Radarr".
    4. "Sync Level": "Full Sync".
    5. "Tags": "radarr".
    6. "Prowlarr Server": "http://prowlarr:9696".
    7. "Radarr Server": "http://radarr:7878".
    8. "API Key": pegar el API Key de Radarr que copiamos antes.
    9. Hacer clic en "Test" y luego "Save".
    10. Agregar nueva aplicación.
    11. Seleccionar "Sonarr"
    12. "Name": "Sonarr".
    13. "Sync Level": "Full Sync".
    14. "Tags": "sonarr".
    15. "Prowlarr Server": "http://prowlarr:9696".
    16. "Sonarr Server": "http://sonarr:8989".
    17. "API Key": pegar el API Key de Sonarr que copiamos antes.
    18. Hacer clic en "Test" y luego "Save".
5. Navegar a "Settings" > "Download Clients" y configurar.
    1. Agregar nuevo cliente.
    2. Seleccionar "qBittorrent".
    3. "Name": "qBittorrent".
    4. "Host": "qbittorrent".
    5. "Port": "8080".
    6. "Default Category": "manual".
    7. Hacer clic en "Test" y luego "Save".
6. Navegar a "Indexers" y configurar.
    1. Agregar indexer.
    2. Escoger el indexer de su preferencia.
    3. Configurar el indexer a su preferencia.
    4. "Tags": Agregar "sonarr" si quiere usar este indexer con Sonarr. Agregar "radarr" si quiere usar este indexer con Radarr. Agregar "proxy" si este indexer necesita de FlareSolverr.
    5. Hacer clic en "Test" y luego "Save".
    6. Repetir los pasos para cualquier otro indexer que desee. Prowlarr empujará los detalles de los indexers a Radarr y Sonarr.
7. Navegar a "Settings" > "Notifications" y configurar.
    1. Agregar nueva conexión.
    2. Seleccionar "Gotify".
    3. "Name": "Gotify".
    4. Habilitar los desencadenantes para los que desee recibir notificaciones.
    5. "Gotify Server": "http://gotify".
    6. "App Token": Ingresar el token que se generó en Gotify para las Apps Arr.
    7. Hacer clic en "Test" y luego "Save".

## Configurar Bazarr

1. Acceder a Bazarr a través de https://bazarr.micasa.duckdns.org.
2. Configurar contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo. Dejar el método de autenticación como `Forms` y no deshabilitar la autenticación.
3. Navegar a "Settings" > "Languages" y configurar.
    1. "Languages Filter": Seleccionar los idiomas que le interese descargar. Es buena idea tener un idioma de respaldo en caso de que no existan para el de su preferencia.
    2. Hacer clic en "Add New Profile".
    3. "Name": El nombre del idioma principal.
    4. Agregar idioma principal e idiomas de respaldo en el orden de su preferencia.
    5. "Cutoff": Seleccionar el idioma principal.
    6. Guardar.
    7. Si desea otros idiomas, puede repetir agregar otro perfil.
    8. Seleccionar el idioma por defecto para series y películas.
    9. Guardar.
4. Navegar a "Settings" > "Providers" y configurar.
    1. Agregar los proveedores de subtítulos de su preferencia.
5. Navegar a "Settings" > "Sonarr" y configurar.
    1. Habilitar Sonarr.
    2. "Host" > "Address": "sonarr".
    3. "Host" > "Port": "8989".
    4. "Host" > "API Key": Pegar el API Key de Sonarr que copiamos antes.
    5. Hacer clic en "Test" y luego "Save".
6. Navegar a "Settings" > "Radarr" y configurar.
    1. Habilitar Radarr.
    2. "Host" > "Address": "radarr".
    3. "Host" > "Port": "7878".
    4. "Host" > "API Key": Pegar el API Key de Radarr que copiamos antes.
    5. Hacer clic en "Test" y luego "Save".
7. Navegar a "Settings" > "Notifications" y configurar.
    1. Agregar nueva conexión.
    2. Seleccionar "Gotify".
    3. "URL": "gotify://gotify/{token}". Reemplazar `{token}` con el token que se generó en Gotify para las Apps Arr.
    4. Hacer clic en "Test" y luego "Save".
    5. Hacer clic en "Save" en la parte superior.
8. Para configurar otras pestañas se recomienda el uso de la siguiente guía: https://trash-guides.info/Bazarr/

## Configurar Jellyfin

1. Acceder a Jellyfin a través de https://jellyfin.micasa.duckdns.org.
2. Seguir el asistente para crear un nuevo usuario y contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
3. Abrir panel lateral y navegar a "Administration" > "Dashboard".
4. Si tiene GPU, navegar a "Playback" y configurar.
    1. Seleccionar su GPU. La guía asumirá "NVidia NVENC".
    2. Habilitar los codecs que su modelo de GPU soporte.
    3. Habilitar "Enable enhanced NVDEC decoder".
    4. Habilitar "Enable hardware encoding".
    5. Habilitar "Allow encoding in HEVC format".
    6. Si gusta puede configurar otros parámetros a su gusto.
    7. Guardar.
5. Navegar a "Networking" y configurar:
    1. "Known proxies": "nginx". Si no se va a exponer el servidor al internet, puede omitir este paso.
    2. Guardar.
6. Navegar a "Plugins" > "Catalog" y configurar.
    1. Si va a haber Anime en su colección, instalar "AniDB" y "AniList".
    2. Instalar "TMBd Box Sets", "TVmaze" y "TheTVDB".
7. Para que los plugins surtan efecto reiniciar Jellyfin desde Portainer.
8. Navegar a "Libraries" y configurar.
    1. Agregar librería.
    2. "Content Type": "Movies".
    3. "Name": "Movies".
    4. "Folders": Agregar "/MediaCenter/media/movies".
    5. Ordenar "Metadata downloaders": "TheMovieDb", "AniDB", "AniList", "The Open Movie Database".
    6. Ordenar "Image fetchers": "TheMovieDb", "The Open Movie Database", "AniDB", "AniList", "Embedded Image Extractor", "Screen Grabber".
    7. Configurar las demás opciones a su gusto y Guardar.
    8. Agregar librería.
    9. "Content Type": "Shows".
    10. "Name": "Shows".
    11. "Folders": Agregar "/MediaCenter/media/tv".
    12. Ordenar "Metadata downloaders (TV Shows)": "TheTVDB", "TVmaze", "TheMovieDb", "AniDB", "AniList", "The Open Movie Database".
    13. Ordenar "Metadata downloaders (Seasons)": "TVmaze", "TheMovieDb", "AniDB".
    14. Ordenar "Metadata downloaders (Episodes)": "TheTVDB", "TVmaze", "TheMovieDb", "AniDB", "The Open Movie Database".
    15. Ordenar "Image fetchers (TV Shows)": "TheTVDB", "TVmaze", "TheMovieDb", "AniList", "AniDB".
    16. Ordenar "Image fetchers (Seasons)": "TheTVDB", "TVmaze", "TheMovieDb", "AniDB", "AniList".
    17. Ordenar "Image fetchers (Episodes)": "TheTVDB", "TVmaze", "TheMovieDb", "The Open Movie Database", "Embedded Image Extractor", "Screen Grabber".
    18. Configurar las demás opciones a su gusto y Guardar.
9. Navegar a "Users" y configurar.
    1. Si más personas van a usar Jellyfin, Crear más usuarios y configurarlos como guste.
10. Navegar a su perfil (Icono de usuario arriba a la derecha) > "Subtitles".
    1. "Preferred subtitle language": Su idioma principal. Guardar.
    2. Puede configurar el resto de su perfil si lo desea.

## Configurar Jellyseerr

1. Acceder a Jellyseerr a través de https://jellyseerr.micasa.duckdns.org.
2. Ingresar con Jellyfin.
    1. Hacer clic en "Use Jellyfin Account".
    2. "Jellyfin URL": "http://jellyfin:8096"
    3. Ingresar con su nombre de usuario y contraseña.
3. Configurar librerías.
    1. Hacer clic en "Sync Libraries".
    2. Habilitar "Movies", "Shows" y "Collections".
    3. Hacer clic en "Start Scan".
    4. Hacer clic en "Continue".
4. Configurar Sonarr y Radarr.
    1. Hacer clic en "Add Radarr Server".
    2. Habilitar "Default Server".
    3. "Server Name": "Movies".
    4. "Hostname or IP Address": "radarr".
    5. "Port": "7878".
    6. "API Key": Pegar el API Key de Radarr que copiamos antes.
    7. Hacer clic en "Test".
    8. "Quality Profile": escoger el perfil de calidad por defecto que quiera usar.
    9. "Root Folder": "/MediaCenter/media/movies".
    10. "Minimum Availability": "Announced".
    11. Habilitar "Enable Scan".
    12. Guardar.
    13. Hacer clic en "Add Sonarr Server".
    14. Habilitar "Default Server".
    15. "Server Name": "Series".
    16. "Hostname or IP Address": "sonarr".
    17. "Port": "8989".
    18. "API Key": Pegar el API Key de Sonarr que copiamos antes.
    19. Hacer clic en "Test".
    20. "Quality Profile": escoger el perfil de calidad por defecto que quiera usar.
    21. "Root Folder": "/MediaCenter/media/tv".
    22. "Anime Quality Profile": escoger el perfil de calidad por defecto que quiera usar para Anime. Dejar en blanco si no va a tener anime en su colección.
    23. "Anime Root Folder": "/MediaCenter/media/tv".
    24. Habilitar "Season Folders".
    25. Habilitar "Enable Scan".
    26. Guardar.
5. Importar usuarios.
    1. Navegar a "Users".
    2. Hacer clic en "Import Jellyfin Users".
    3. Puede configurar los usuarios haciendo clic en "Edit" en la fila del usuario que desee configurar.
6. Navegar a "Settings" > "Notifications" y configurar.
    1. Seleccionar "Gotify".
    2. Habilitar Agente.
    3. "Server URL": "http://gotify".
    4. "Application Token": Ingresar el token que se generó en Gotify para las Apps Arr.
    5. "Priority": 5.
    6. Habilitar los desencadenantes para los que desee recibir notificaciones.
    7. Hacer clic en "Test" y luego "Save Changes".
7. Si desea configurar más opciones, Navegar a "Settings" y hacer los cambios deseados.

[<img width="33.3%" src="buttons/prev-Create and configure nextcloud stack.es.svg" alt="Crear y configurar stack de Nextcloud">](Create%20and%20configure%20nextcloud%20stack.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create and configure home assistant stack.es.svg" alt="Crear y configurar stack de Home Assistant">](Create%20and%20configure%20home%20assistant%20stack.es.md)
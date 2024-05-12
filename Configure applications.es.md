# Configurar aplicaciones

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20applications.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20applications.es.md)

Los contenedores deben estar ejecutándose ahora, sin embargo, requieren cierta configuración para trabajar entre ellos.

## Configurar Technitium

1. Acceder a Technitium a través de https://192.168.1.10/.
2. Crear un usuario admin y una contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
3. Configurar Technitium como servidor DHCP para poder autoasignarse como DNS. Si su router tiene la opción de cambiar el DNS asignado por el DHCP o si no piensa exponer su servidor al internet, omita este paso.
    1. Hacer clic en la pestaña `DHCP`.
    2. Hacer clic en la pestaña `Scopes`.
    3. Hacer clic en el botón `Edit`.
    4. Ajustar los campos `Starting Address` y `Ending Address` con el rango de IPs de su red local. Asegurarse de dejar algunos IPs no asignables al principio de la red. Por ejemplo si el rango de su red local es 192.168.1.0/24, empiece en 192.168.1.64.
    5. Ajustar el campo `Domain Name` a `lan`.
    6. Ajustar el campo `Router Address` con el IP de su router.
    7. Hacer clic en el botón `Save`.
    8. Hacer clic en el botón `Enable` en la fila del scope `Default`.
4. Navegar a la pestaña `Settings`.
5. En la pestaña `General`, asegurarse que el campo `Enable DNSSEC Validation` esté habilitado.
6. Navegar a la pestaña `Web Service` y habilitar la opción `Enable HTTP to HTTPS Redirection`. El resto de las opciones debieron ser configuradas en el `docker-compose.yaml`.
7. Navegar a la pestaña `Blocking` y configurar.
    1. Seleccionar `Any Address` para la opción `Blocking Type`.
    2. Agregar direcciones de listas de bloqueo a la lista de `Allow/Block List URLs`. Algunas recomendaciones de paginas donde conseguir listas: https://easylist.to/ y https://firebog.net/.
8. Navegar a la pestaña `Proxy & Forwarders` y seleccionar `Cloudflare (DNS-over-HTTPS)`. Debería agregar a la lista de `Forwarders` y seleccionar `DNS-over-HTTPS` como el `Forwarder Protocol`. Si desea usar un proveedor o protocolo diferente puede seleccionar o configurar uno diferente aquí.
9. Navegar a la pestaña `Zones` y configurar:
    1. Hacer clic en el botón `Add Zone`.
    2. `Zone`: `lan`.
    3. Hacer clic en el botón `Add`.
    4. Hacer clic en el botón `Add Record`.
    5. `Name`: `server`. Esto configurará nuestro servidor en nuestro dominio `lan` ya que el servidor tiene IP estático y no usa DHCP.
    6. `IPv4 Address`: `192.168.1.253`. Use el IP estático que le asignó al servidor.
    7. Hacer clic en el botón `Add Record`.
    8. `Name`: `homeassistant`. Esto configurará Home Assistant en nuestro dominio `lan` ya que tiene IP estático y no usa DHCP.
    9. `IPv4 Address`: `192.168.1.11`. Use el IP estático que le asignó a Home Assistant en `docker-compose.yaml`.
    10. Hacer clic en el botón `Add Record`.
    11. `Name`: `technitium`. Esto configurará Technitium en nuestro dominio `lan` ya que no se agrega a si mismo.
    12. `IPv4 Address`: `192.168.1.10`. Use el IP estático que le asignó a Technitium en `docker-compose.yaml`.
    13. Hacer clic en el botón `Back`.
    14. Si no va a exponer su servidor al internet, puede omitir el resto de este paso.
    15. Hacer clic en el botón `Add Zone`.
    16. `Zone`: `micasa.duckdns.org`. Use el subdominio que registró en DuckDNS.org.
    17. Hacer clic en el botón `Add`.
    18. Hacer clic en el botón `Add Record`.
    19. `Name`: `@`. Esto configurará la raíz del subdominio a que apunte a nuestro servidor.
    20. `IPv4 Address`: `192.168.1.253`. Use el IP estático que le asignó al servidor.
    21. Hacer clic en el botón `Add Record`.
    22. `Name`: `*`. Esto configurará un subdominio comodín a que apunte a nuestro servidor.
    23. `IPv4 Address`: `192.168.1.253`. Use el IP estático que le asignó al servidor.
    24. Hacer clic en el botón `Back`.
10. Si alguna pagina está siendo bloqueada y no desea bloquearla, Navegar a la pestaña `Allowed` y agregar el dominio a la lista.

## Configurar qBittorrent

1. Acceder a qBittorrent a través de http://192.168.1.253:10095.
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
    1. Cambiar la contraseña por una más seguro. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
    2. Habilitar "Bypass authentication for clients on localhost".
    3. Habilitar "Bypass authentication for clients in whitelisted IP subnets".
    4. Agregar `172.21.0.0/24` a la lista debajo. Esto permitirá a los contenedores en la red `arr` de Docker acceder sin contraseña.
9. Configurar pestaña `Advanced`. Hacer los siguientes cambios:
    1. Asegurar que el "Network Interface" sea `tun0`. Si no quiere decir que no está usando su VPN y el tráfico no será anónimo.
    2. Habilitar "Reannounce to all trackers when IP or port changed".
    3. Habilitar "Always announce to all trackers in a tier".
    4. Habilitar "Always announce to all tiers".
10. Guardar.

## Configurar Radarr

1. Acceder a Radarr a través de http://192.168.1.253:7878.
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
5. Navegar a "Settings" > "General".
6. Copiar el "API Key" a un bloc de notas ya que lo necesitaremos más tarde.
7. Para configurar las pestañas de "Profiles", "Quality" y "Custom Formats" se recomienda el uso de la siguiente guía: https://trash-guides.info/Radarr/

## Configurar Sonarr

1. Acceder a Sonarr a través de http://192.168.1.253:8989.
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
5. Navegar a "Settings" > "General".
6. Copiar el "API Key" a un bloc de notas ya que lo necesitaremos más tarde.
7. Para configurar las pestañas de "Profiles", "Quality" y "Custom Formats" se recomienda el uso de la siguiente guía: https://trash-guides.info/Sonarr/

## Configurar Prowlarr

1. Acceder a Prowlarr a través de http://192.168.1.253:8989.
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

## Configurar Bazarr

1. Acceder a Bazarr a través de http://192.168.1.253:6767.
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
7. Para configurar otras pestañas se recomienda el uso de la siguiente guía: https://trash-guides.info/Bazarr/

## Configurar Jellyfin

1. Acceder a Jellyfin a través de http://192.168.1.253:8096.
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
    1. "Known proxies": "nginx".
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

1. Acceder a Jellyseerr a través de http://192.168.1.253:5055.
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
6. Si desea configurar más opciones, Navegar a "Settings" y hacer los cambios deseados.

## Configurar Home Assistant

1. Acceder a Home Assistant a través de http://192.168.1.11:8123.
2. Usar el asistente para crear una cuenta de usuario y contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
3. Configurar con el asistente nombre de la instancia de Home Assistant y sus datos y preferencias.
4. Escoja si quiere mandar datos de uso a la pagina de Home Assistant.
5. Finalizar el asistente.
6. Configurar Webhook para notificaciones.
    1. Navegar a "Settings" > "Automations & Scenes".
    2. Hacer clic en "Create Automation".
    3. Hacer clic en "Create new Automation".
    4. Hacer clic en "Add Trigger".
    5. Buscar "Webhook" y seleccionar.
    6. Nombrar el trigger "A Problem is reported".
    7. Cambiar el id del webhook a "notify".
    8. Hacer clic en el engrane de configuración y habilitar unicamente "POST" y "Only accessible from the local network".
    9. Hacer clic en "Add Action".
    10. Buscar "send persistent notification" y seleccionar.
    11. Hacer clic en el Menú de la acción y seleccionar "Edit in YAML" y agregar lo siguiente:
        ```yaml
        alias: Notify Web
        service: notify.persistent_notification
        metadata: {}
        data:
            title: Issue found in server!
            message: "Issue in server: {{trigger.json.problem}}"
        ```
    12. Si desea recibir notificaciones en su celular, primero deberá descargar la aplicación a su celular e iniciar sesión en Home Assistant desde él. Después configurar lo siguiente:
    13. Hacer clic en "Add Action".
    14. Buscar "mobile" y seleccionar "Send notification via mobile_app".
    15. Hacer clic en el Menú de la acción y seleccionar "Edit in YAML" y agregar lo siguiente:
        ```yaml
        alias: Notify Mobile
        service: notify.mobile_app_{mobile_name}
        metadata: {}
        data:
            title: Issue found in server!
            message: "Issue in server: {{trigger.json.problem}}"
        ```
    16. Guardar.

[<img width="50%" src="buttons/prev-Create docker stack.es.svg" alt="Crear stack de Docker">](Create%20docker%20stack.es.md)[<img width="50%" src="buttons/next-Configure scheduled tasks.es.svg" alt="Configurar tareas programadas">](Configure%20scheduled%20tasks.es.md)

<details><summary>Indice</summary>

1. [Objetivo](Objective.es.md)
2. [Motivación](Motivation.es.md)
3. [Características](Features.es.md)
4. [Diseño y justificación](Design%20and%20justification.es.md)
5. [Prerequisitos mínimos](Minimum%20prerequisites.es.md)
6. [Guía](Guide.es.md)
    1. [Instalar Fedora Server](Install%20fedora%20server.es.md)
    2. [Configurar Secure Boot](Configure%20secure%20boot.es.md)
    3. [Instalar y configurar Zsh (Opcional)](Install%20and%20configure%20zsh%20optional.es.md)
    4. [Configurar usuarios](Configure%20users.es.md)
    5. [Instalar ZFS](Install%20zfs.es.md)
    6. [Configurar ZFS](Configure%20zfs.es.md)
    7. [Configurar red del anfitrión](Configure%20hosts%20network.es.md)
    8. [Configurar shares](Configure%20shares.es.md)
    9. [Registrar DDNS](Register%20ddns.es.md)
    10. [Instalar Docker](Install%20docker.es.md)
    11. [Crear stack de Docker](Create%20docker%20stack.es.md)
    12. [Configurar aplicaciones](Configure%20applications.es.md)
    13. [Configurar tareas programadas](Configure%20scheduled%20tasks.es.md)
    14. [Configurar tráfico externo público](Configure%20public%20external%20traffic.es.md)
    15. [Configurar tráfico externo privado](Configure%20private%20external%20traffic.es.md)
    16. [Instalar Cockpit](Install%20cockpit.es.md)
7. [Glosario](Glossary.es.md)

</details>

# Crear stack de Docker

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20docker%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20docker%20stack.es.md)

Prepararemos el archivo de configuración de la VPN anónima que requiere qBittorrent; configuraremos el stack; configuraremos el cortafuegos para permitir los puertos necesarios; y levantaremos el stack a través de Portainer. El stack consiste de los siguientes contenedores:

- qBittorrent: Administrador de descargas a través del protocolo bittorrent.
- Sonarr: Administrador de series.
- Radarr: Administrador de películas.
- Prowlarr: Administrador de motores de búsqueda.
- Bazarr: Administrador de subtítulos.
- Flaresolverr: Solucionador de CAPTCHAs.
- Jellyfin: Servicio de medios.
- Jellyseerr: Administrador de peticiones de medios y servicio de catálogo.
- Technitium: Servidor DNS y DHCP.
- Nginx Proxy Manager: Motor y administrador de Reverse Proxy.
- Home Assistant: Motor de automatización del hogar.
- WireGuard: VPN para la red local.

## Pasos

1. Copiar el archivo de configuración de la VPN anónima para bittorrent: `scp user@host:/path/to/vpn.conf /Apps/qbittorrent/wireguard/tun0.conf`. Cambiar `{user@host:/path/to/vpn.conf}` por la dirección del archivo en la computadora que contenga el archivo. Este archivo debe ser proporcionado por su proveedor de VPN si selecciona WireGuard como protocolo. También puede usar una memoria USB para transferir el archivo de configuración. Si su proveedor requiere usar OpenVPN tendrá que cambiar la configuración del contenedor. Para más información lea la guía del contenedor: https://github.com/Trigus42/alpine-qbittorrentvpn.
2. Si se va a usar una VPN local, ejecutar: `./scripts/iptable_setup.sh`. Agrega un módulo de kernel al inicio del sistema necesario para WireGuard.
3. Editar el archivo del stack: `nano ./files/docker-compose.yml`.
4. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
5. Reemplazar las XXX con el `uid` y `gid` del usuario `mediacenter`. Se puede usar `id mediacenter` para obtener el `uid` y `gid`.
6. Si no se va a usar GPU, borrar las secciones de `runtime` y `deploy` del contenedor `jellyfin`.
7. Si se va a usar OpenVPN para bittorrent, actualizar el contenedor `qbittorrent` de acuerdo a la guía oficial.
8. Si no se va a usar una VPN local, quitar el contenedor de `wireguard`, de lo contrario, reemplazar `micasa` por el subdominio que registró en DuckDNS.org y ajustar la variable `ALLOWEDIPS` en caso de que `192.168.1.0/24` no sea el rango CIDR de su red local. No remover `10.13.13.0` ya que es la red interna de WireGuard y perderá conectividad si la remueve. Si asignó un IP diferente a Technitium, ajustar la variable `PEERDNS` con la IP correcta. No remover `10.13.13.1` ya que es el DNS interno de WireGuard y no va a funcionar. La guía asume 2 clientes que se conectaran a la VPN con los IDs: `phone` y `laptop`. Si usted requiere más o menos clientes, agregar o remover o renombrar los IDs de los clientes que desee.
9. Si no se va a exponer el servidor al internet, quitar el contenedor de `nginx`.
10. Ajustar la red `lanvlan`.
    1. Ajustar atributo `parent` con el dispositivo que usó para crear la red macvlan auxiliar anteriormente. Por ejemplo `enp1s0`.
    2. Ajustar atributo `subnet` con el rango de su red local.
    3. Ajustar atributo `gateway` con el IP de su router.
    4. Ajustar atributo `ip_range` con el rango de su red local que el DHCP no asigna. La guía configuró Technitium para no asignar las primeras 64 direcciones, por eso usamos un rango 192.168.1.0/27. Si usted configuró su DHCP con otro rango no asignable, use ese aquí.
    5. Ajustar atributo `host` con el IP del servidor en la red macvlan auxiliar.
11. Ajustar el atributo `ipv4_address` en el contenedor `technitium` con un IP en el rango no asignable por el DHCP. Por ejemplo 192.168.1.10.
12. Ajustar el atributo `ipv4_address` en el contenedor `homeassistant` con un IP en el rango no asignable por el DHCP. Por ejemplo 192.168.1.11.
13. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
14. Ejecutar: `./scripts/container_firewalld_services.sh`. Configura Firewalld para los contenedores. El script abre los puertos para DHCP y DNS para Technitium; los puertos para HTTP y HTTPS para Nginx y el puerto para WireGuard. Si no va a usar alguno de estos servicios, editar el script y remueva las reglas no necesarias.
15. Ejecutar: `./scripts/run_portainer.sh`. Esto ejecuta un contenedor de Portainer Community Edition y escuchará en el puerto `9443`.
16. Configurar Portainer desde el navegador.
    1. Acceder a Portainer a través de https://192.168.1.253:9443. Si sale una alerta de seguridad, puede aceptar el riesgo ya que Portainer usa un certificado de SSL autofirmado.
    2. Establecer una contraseña aleatoria y crear usuario `admin`. Se recomienda Bitwarden nuevamente para esto.
    3. Darle clic en "Get Started" y luego seleccionar "local".
    4. Seleccionar "Stacks" y crear un nuevo stack.
    5. Ponerle nombre "apps" y pegar el contenido del docker-compose.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Portainer y no en el archivo.
    6. Navegar a "Environments" > "local" y cambiar "Public IP" con el hostname del servidor `server.lan`.

[<img width="50%" src="buttons/prev-Install docker.es.svg" alt="Instalar Docker">](Install%20docker.es.md)[<img width="50%" src="buttons/next-Configure applications.es.svg" alt="Configurar aplicaciones">](Configure%20applications.es.md)

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

# Configurar tráfico externo público

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20public%20external%20traffic.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20public%20external%20traffic.es.md)

Si usted no piensa acceder a su servidor fuera de su red local, puede omitir esta sección.

Haremos Port Forwarding de los puertos HTTP y HTTPS para Nginx y el puerto 51820 para WireGuard; deshabilitaremos IPv6 ya que complicaría demasiado la configuración; condicionalmente deshabilitaremos DHCP en el router o configuraremos Technitium como el DNS del DHCP; configuraremos Nginx para redireccionar el trafico a los contenedores; y permitiremos a Nginx actuar como proxy de Home Assistant.

## Pasos

1. Configurar el router. Cada router es diferente, así que tendrá que consultar su manual para poder hacer los pasos siguientes.
    1. Redireccionar el puerto (Port Forwarding) 80 y 443 en protocolo TCP al servidor para que Nginx pueda hacer reverse proxy a los servicios internos. Si piensa usar VPN privada con WireGuard, entonces también redireccionar puerto 51820 en UDP al servidor.
    2. Deshabilitar IPv6 porque Technitium solo puede hacer IPv4 con la configuración establecida y es mas complejo configurarlo para IPv6.
    3. Si su router permite configurar el DNS que el DHCP asigna a todos los dispositivos de la casa, entonces use el IP de Technitium en vez del que el ISP brinda. De lo contrario, tendrá que deshabilitar el DHCP para que Technitium sea el DHCP y pueda auto asignarse como DNS. Puede encontrar el IP de Technitium en Portainer si ve el stack en el editor y ve la configuración del contenedor `technitium`.
    4. Verificar que el DHCP de Technitium o del router esté funcionando (conectar un dispositivo a la red y verificar que se le asignara un IP en el rango configurado y que el DNS sea la IP del servidor).
2. Configurar proxy hosts en Nginx usando el DDNS.
    1. Acceder a Nginx a través de http://server.lan:8181.
    2. Usar `admin@example.com` y `changeme` como usuario y contraseña y modificar los detalles y contraseña por una segura. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
    3. Navegar a la pestaña de `SSL Certificates`.
    4. Presionar `Add SSL Certificate`. Seleccionar `Let's Encrypt` como proveedor de certificados.
        1. Configurar un certificado SSL de "dominio comodín" con Let's Encrypt. Por ejemplo `*.micasa.duckdns.org` (note el `*` al principio del dominio).
        2. Es necesario habilitar `Usar DNS Challenge`.
        3. Seleccionar DuckDNS como proveedor DNS.
        4. Reemplazar `your-duckdns-token` por el token que generó en DuckDNS.org
        5. Aceptar los términos del servicio y guardar.
    5. Navegar a la pestaña de "Proxy Hosts" y configurar un proxy host para Jellyfin.
        1. En la pestaña de `Details` llenar:
            - "Domain Names": jellyfin.micasa.duckdns.org.
            - "Scheme": http.
            - "Forward Hostname/IP": jellyfin. Podemos usar el nombre del contenedor gracias a que Docker tiene un DNS interno que mapea el nombre del contenedor al IP interno de Docker.
            - "Forward Port": 8096. Usar el puerto interno del contenedor, no el puerto del servidor al que fue mapeado. Revise el puerto de cada contenedor en el stack de Portainer.
            - "BlockCommonExploits": activado.
            - "Websockets Support": activado. Jellyfin y Home Assistant lo necesitan, los demás servicios no parecen necesitarlo. Si nota algún problema con algún servicio cuando lo accede a través de Nginx (y no desde el puerto directo), pruebe habilitar esta opción.
        2. En la pestaña de `SSL` llenar:
            - "SSL Certificate": *.micasa.duckdns.org. Usamos el certificado creado en el paso 4.
            - "Force SSL": activado.
            - "HTTP/2 Support": activado.
            - "HSTS Enabled": activado.
            - "HSTS Subdomains": activado.
        3. En la pestaña de `Avanzado` llenar (Nota: esto es solo necesario para Jellyfin, los otros servicios no requieren nada en la pestaña `Avanzado`):
            ```sh
            # Disable buffering when the nginx proxy gets very resource heavy upon streaming
            proxy_buffering off;

            # Proxy main Jellyfin traffic
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_headers_hash_max_size 2048;
            proxy_headers_hash_bucket_size 128;

            # Security / XSS Mitigation Headers
            # NOTE: X-Frame-Options may cause issues with the webOS app
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-XSS-Protection "0";
            add_header X-Content-Type-Options "nosniff";
            ```
        4. Repetir este paso para Bazarr, Home Assistant, Jellyseerr, Prowlarr, Radarr, Sonarr y qBittorrent. **No exponga Portainer ni Cockpit con Nginx!**
3. Configurar Home Assistant para permitir tráfico redireccionado por el Reverse Proxy de Nginx.
    1. Editar la configuración de Home Assistant: `nano /Apps/homeassistant/configuration.yaml`.
    2. Agregar la siguiente sección al final del archivo. Permitimos proxies de la red `172.21.3.0/24` que es la red de `nginx` que configuramos en el stack en Portainer.
        ```yml
        http:
            use_x_forwarded_for: true
            trusted_proxies:
                - 172.21.3.0/24
        ```
    3. Guardar y salir con `Ctrl + X, Y, Enter`.
4. Recargar la configuración de Home Assistant desde el UI para que surtan efecto los cambios.
    1. Acceder a Home Assistant a través de http://homeassistant.lan:8123.
    2. Navegar a `Developer tools`.
    3. Presionar `Restart`.
5. Puede probar que Nginx funciona accediendo a un servicio a través del URL con su subdominio. Por ejemplo https://jellyfin.micasa.duckdns.org. Inténtelo desde adentro de su red local para probar el "split horizon DNS" y desde afuera para probar el DDNS.

[<img width="50%" src="buttons/prev-Configure scheduled tasks.es.svg" alt="Configurar tareas programadas">](Configure%20scheduled%20tasks.es.md)[<img width="50%" src="buttons/next-Configure private external traffic.es.svg" alt="Configurar tráfico externo privado">](Configure%20private%20external%20traffic.es.md)

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

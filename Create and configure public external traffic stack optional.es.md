# Crear y configurar stack de tráfico externo público (Opcional)

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20public%20external%20traffic%20stack%20optional.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20public%20external%20traffic%20stack%20optional.es.md)

Si usted no piensa acceder a su servidor fuera de su red local, puede omitir esta sección.

Configuraremos el stack de Docker de tráfico público; configuraremos el cortafuegos para permitir los puertos necesarios; y levantaremos el stack a través de Portainer; haremos Port Forwarding de los puertos HTTP y HTTPS para Nginx; configuraremos Nginx para redireccionar el trafico a los contenedores; y permitiremos a Nginx actuar como proxy de Home Assistant. El stack consiste de los siguientes contenedores:

- Nginx Proxy Manager: Motor y administrador de Reverse Proxy.

## Pasos

1. Ejecutar: `./scripts/create_nginx_folder.sh` para generar el directorio del contenedor en el SSD.
2. Editar el archivo del stack: `nano ./files/public-traffic-stack.yml`.
3. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
5. Ejecutar: `./scripts/public_traffic_firewalld_services.sh`. Configura Firewalld para los contenedores. El script abre los puertos HTTP y HTTPS para Nginx.
6. Agregar stack en Portainer desde el navegador.
    1. Acceder a Portainer a través de https://192.168.1.253:9443. Si sale una alerta de seguridad, puede aceptar el riesgo ya que Portainer usa un certificado de SSL autofirmado.
    2. Darle clic en "Get Started" y luego seleccionar "local".
    3. Seleccionar "Stacks" y crear un nuevo stack.
    4. Ponerle nombre "public-traffic" y pegar el contenido del public-traffic-stack.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Portainer y no en el archivo.
7. Configurar el router. Cada router es diferente, así que tendrá que consultar su manual para poder hacer los pasos siguientes.
    1. Redireccionar el puerto (Port Forwarding) 80 y 443 en protocolo TCP al servidor para que Nginx pueda hacer reverse proxy a los servicios internos.
8. Configurar proxy hosts en Nginx usando el DDNS.
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
9. Configurar Home Assistant para permitir tráfico redireccionado por el Reverse Proxy de Nginx.
    1. Editar la configuración de Home Assistant: `nano /Apps/homeassistant/configuration.yaml`.
    2. Agregar la siguiente sección al final del archivo. Permitimos proxies de la red `172.21.3.0/24` que es la red de `nginx` que configuramos en el stack en Portainer.
        ```yml
        http:
            use_x_forwarded_for: true
            trusted_proxies:
                - 172.21.3.0/24
        ```
    3. Guardar y salir con `Ctrl + X, Y, Enter`.
10. Recargar la configuración de Home Assistant desde el UI para que surtan efecto los cambios.
    1. Acceder a Home Assistant a través de http://homeassistant.lan:8123.
    2. Navegar a `Developer tools`.
    3. Presionar `Restart`.
11. Puede probar que Nginx funciona accediendo a un servicio a través del URL con su subdominio. Por ejemplo https://jellyfin.micasa.duckdns.org. Inténtelo desde adentro de su red local para probar el "split horizon DNS" y desde afuera para probar el DDNS.

[<img width="33.3%" src="buttons/prev-Configure dns.es.svg" alt="Configurar DNS">](Configure%20dns.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Configure scheduled tasks.es.svg" alt="Configurar tareas programadas">](Configure%20scheduled%20tasks.es.md)

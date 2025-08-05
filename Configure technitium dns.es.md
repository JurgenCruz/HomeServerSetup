# Configurar DNS de Technitium

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20technitium%20dns.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20technitium%20dns.es.md)

Technitium es un servidor DNS y DHCP que se ejecuta desde un contenedor de Docker. Configuraremos el stack de Docker de Technitium DNS; configuraremos el cortafuegos para permitir los puertos necesarios; y levantaremos el stack a través de Portainer. Ya que el DNS va a ejecutarse adentro del servidor, necesitamos asignar al servidor un IP estático en la red local. Configuraremos el servidor para no usar DHCP y asignarse un IP en la red. El stack consiste de los siguientes contenedores:

- Technitium: Servidor DNS y DHCP.

## Pasos

1. Ejecutar: `./scripts/create_technitium_folder.sh` para generar el directorio del contenedor en el SSD.
2. Editar el archivo del stack: `nano ./files/technitium-stack.yml`.
3. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Ajustar el atributo `ipv4_address` en el contenedor `technitium` con un IP en el rango no asignable por el DHCP. Por ejemplo 192.168.1.10.
5. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
6. Ejecutar: `./scripts/dns_firewalld_services.sh`. Configura Firewalld para los contenedores. El script abre el puerto para DNS para Technitium.
7. Agregar stack en Portainer desde el navegador.
    1. Acceder a Portainer a través de https://server.lan:9443. Si sale una alerta de seguridad, puede aceptar el riesgo ya que Portainer usa un certificado de SSL autofirmado.
    2. Darle clic en "Get Started" y luego seleccionar "local".
    3. Seleccionar "Stacks" y crear un nuevo stack.
    4. Ponerle nombre "technitium" y pegar el contenido del docker-compose.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Portainer y no en el archivo.
8. Ejecutar: `./scripts/disable_resolved.sh`. Desactivamos el servicio de DNS local "systemd-resolved" para desocupar el puerto DNS que necesita Technitium.
9. Ver el nombre del dispositivo de red físico activo, por ejemplo `enp1s0` o `eth0`: `nmcli device status`. Si existe más de un dispositivo físico, seleccionar el que esté conectado al router con mejor velocidad. Reemplazar en los comandos siguientes `enp1s0` por el dispositivo correcto.
10. Asignar IP estático y rango CIDR: `nmcli con mod enp1s0 ipv4.addresses 192.168.1.253/24`. Normalmente los routers de hogar usan un rango CIDR de `/24` o su equivalente mascara de subred `255.255.255.0`. Revise el manual de su router para más información.
11. Deshabilitar cliente DHCP: `nmcli con mod enp1s0 ipv4.method manual`.
12. Configurar el IP del router: `nmcli con mod enp1s0 ipv4.gateway 192.168.1.254`. Normalmente el router se asigna un IP estático que es el penúltimo IP del rango de IPs.
13. Configurar Technitium como DNS y Cloudflare como DNS de respaldo: `nmcli con mod enp1s0 ipv4.dns "192.168.1.10 1.1.1.1"`. Si gusta usar otro DNS como el de Google, puede cambiarlo.
14. Reactivar el dispositivo para que surtan efecto los cambios: `nmcli con up enp1s0`. Esto puede terminar la sesión SSH. de ser así, vuelva a hacer `ssh` al servidor.
15. Acceder a Technitium a través de https://192.168.1.10/.
16. Crear un usuario admin y una contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
17. Navegar a la pestaña `Settings`.
18. En la pestaña `General`, asegurarse que el campo `Enable DNSSEC Validation` esté habilitado.
19. Navegar a la pestaña `Web Service` y habilitar la opción `Enable HTTP to HTTPS Redirection`. El resto de las opciones debieron ser configuradas en el `technitium-stack.yml`.
20. Navegar a la pestaña `Blocking` y configurar.
    1. Seleccionar `Any Address` para la opción `Blocking Type`.
    2. Agregar direcciones de listas de bloqueo a la lista de `Allow/Block List URLs`. Algunas recomendaciones de paginas donde conseguir listas: https://easylist.to/ y https://firebog.net/.
21. Navegar a la pestaña `Proxy & Forwarders` y seleccionar `Cloudflare (DNS-over-HTTPS)`. Debería agregar a la lista de `Forwarders` y seleccionar `DNS-over-HTTPS` como el `Forwarder Protocol`. Si desea usar un proveedor o protocolo diferente puede seleccionar o configurar uno diferente aquí.
22. Navegar a la pestaña `Zones` y configurar:
    1. Hacer clic en el botón `Add Zone`.
    2. `Zone`: `lan`.
    3. Hacer clic en el botón `Add`.
    4. Hacer clic en el botón `Add Record`.
    5. `Name`: `server`. Esto configurará nuestro servidor en nuestro dominio `lan` ya que el servidor tiene IP estático y no usa DHCP.
    6. `IPv4 Address`: `192.168.1.253`. Use el IP estático que le asignó al servidor.
    7. Hacer clic en el botón `Add Record`.
    8. `Name`: `homeassistant`. Esto configurará Home Assistant en nuestro dominio `lan` con una IP estática ya que no usará DHCP. Aún no hemos creado el servicio de Home Assistant, pero su IP estará lista.
    9. `IPv4 Address`: `192.168.1.11`. Use el IP estático que le asignó a Home Assistant en `home-assistant-stack.yml`.
    10. Hacer clic en el botón `Add Record`.
    11. `Name`: `technitium`. Esto configurará Technitium en nuestro dominio `lan` ya que no se agrega a si mismo.
    12. `IPv4 Address`: `192.168.1.10`. Use el IP estático que le asignó a Technitium en `technitium-stack.yml`.
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
23. Si alguna pagina está siendo bloqueada y no desea bloquearla, Navegar a la pestaña `Allowed` y agregar el dominio a la lista.

Dependiendo de su hardware, el DHCP se configurará de manera diferente. Por favor seleccione la opción que se ajuste a su situación. Si tiene control sobre del DNS que el DHCP de su router provee, seleccione `Configurar DHCP del router`. De lo contrario, seleccione `Configurar DHCP de Technitium`.

[<img width="100%" src="buttons/jump-Configure router dhcp.es.svg" alt="Configurar DHCP del router">](Configure%20router%20dhcp.es.md)
[<img width="100%" src="buttons/jump-Configure technitium dhcp.es.svg" alt="Configurar DHCP de Technitium">](Configure%20technitium%20dhcp.es.md)
[<img width="33.3%" src="buttons/prev-Configure dns.es.svg" alt="Configurar DNS">](Configure%20dns.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Configure router dhcp.es.svg" alt="Configurar DHCP del router">](Configure%20router%20dhcp.es.md)

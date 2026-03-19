# Configurar DNS del router

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20router%20dns.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20router%20dns.es.md)

Cada router es diferente, asi que tal vez requiera leer el manual para saber como hacer pasos específicos. La guía va a usar un router con OpenWrt como ejemplo, ya que su naturaleza de código abierto se alínea con el espíritu de esta guía.

Configuraremos nuestro DNS ascendente y usaremos DNS-sobre-HTTPS (DoH) para mejor privacidad; configuraremos el rango de IPs del DHCP; estableceremos una IP estática para el servidor; configuraremos el DNS para agregar los dispositivos con IPs estáticas al dominio `lan`; y finalmente, configuraremos el Split Horizon para nuestro subdominio de DuckDNS.org, para poder usarlo desde adentro de nuestra LAN.

## Pasos

1. Acceder al portal del router, por ejemplo a través de https://192.168.1.254. Use el IP de su router.
2. Iniciar sesión con las credenciales del router.
3. Configurar DNS ascendente.
    1. Navegar a "System" > "Software".
    2. Hacer clic en el botón `Update lists...`.
    3. En `Download and install package` ingresar `luci-app-https-dns-proxy`. Hacer clic en `OK`.
    4. Navegar a "Services" > "HTTPS DNS Proxy". Si no lo ve, intente reiniciar el router.
    5. El plugin viene preconfigurado con el DNS de Cloudflare y Google. Remover el DNS de Google de la lista inferior o escoger su proveedor aquí.
    6. En la parte superior, asegurarse que el servicio esté habilitado e iniciado. Debería de ver los botones `Start` y `Enable` deshabilitados. Si no, hacer clic en ellos.
    7. Hacer clic en el botón `Save & Apply`.
4. Configurar Adblock.
    1. Navegar a "System" > "Software".
    2. Hacer clic en el botón `Update lists...`.
    3. En `Download and install package` ingresar `luci-app-adblock`. Hacer clic en `OK`.
    4. Navegar a "Services" > "Adblock". Si no lo ve, intente reiniciar el router.
    5. Navegar a la pestaña de "Blocklist Sources".
    6. En `Sources`, seleccionar las listas de su preferencia.
    7. Hacer clic en el botón `Save & Apply`.
5. Configurar el rango del DHCP.
    1. Navegar a "Network" > "Interfaces".
    2. Editar la interfaz `lan`.
    3. Navegar a la pestaña "DHCP Server".
    4. Establecer `Start` a `64` y `Limit` a `189`.
    5. Hacer clic en el botón `Save`.
    6. Hacer clic en el botón `Save & Apply`.
6. Establecer IP estático para el servidor.
    1. Ver el nombre del dispositivo de red físico activo, por ejemplo `enp1s0` o `eth0`: `nmcli device status`. Si existe más de un dispositivo físico, seleccionar el que esté conectado al router con mejor velocidad. Reemplazar en los comandos siguientes `enp1s0` por el dispositivo correcto.
    2. Asignar IP estático y rango CIDR: `nmcli con mod enp1s0 ipv4.addresses 192.168.1.253/24`. Normalmente, los routers de hogar usan un rango CIDR de `/24` o su equivalente máscara de subred `255.255.255.0`. Revise el manual de su router para más información.
    3. Deshabilitar cliente DHCP: `nmcli con mod enp1s0 ipv4.method manual`.
    4. Configurar la IP del router: `nmcli con mod enp1s0 ipv4.gateway 192.168.1.254`. Normalmente, el router se asigna una IP estática que es la penúltima IP del rango de IPs.
    5. Configurar el router como DNS y Cloudflare como DNS de respaldo: `nmcli con mod enp1s0 ipv4.dns "192.168.1.254 1.1.1.1"`. Si gusta usar otro DNS como el de Google, puede cambiarlo.
    6. Reactivar el dispositivo para que surtan efecto los cambios: `nmcli con up enp1s0`. Esto puede terminar la sesión SSH. de ser así, vuelva a hacer `ssh` al servidor.
7. Establecer IPv6 estático para el servidor (Opcional). Solo si su router está usando IPv6.
    1. Navegar a "Network" > "DHCP" > "Leases".
    2. Hacer clic en el botón `Add`.
    3. `Hostname`: `server`.
    4. `MAC Addresses`: seleccionar el MAC Address del servidor de la lista.
    5. `IPv4`: `192.168.1.253`.
    6. `DUID/IAIDs`: seleccionar el DUID del servidor. Asegurarse que el IAID es el correspondiente al dispositivo de red principal y no el del macvlan shim creada anteriormente.
    7. `IPv6 Token`: `fffd`.
    8. Hacer clic en el botón `Save`.
    9. Navegar a "Network" > "Interfaces" > "Global network options".
    10. Asegurarse que el "ULA Prefix" tenga valor y anotarlo. Si no, puede generar uno nuevo con https://simpledns.plus/private-ipv6 como antes.
    11. Si tiene más de una interfaz lan (como interfaz guest o iot), asegurarse de establecer la pista de asignación IPv6 a `1` para la interfaz `lan`.
    12. Hacer clic en el botón `Save & Apply`. Su servidor debería tener ahora una dirección IPv6 que empieza con el prefijo ULA que termina en `fffd`. Si no, asegurarse que su interface `lan` esté permitiendo ULA en el filtro de prefijo o intente resetear la red del servidor para que pida una dirección IPv6.
8. Agregar servicios con IP estática al dominio `lan`. Como estos no usan DHCP. el router no los agrega a la lista de hosts. Aún no hemos creado el servicio de Home Assistant, pero su IP estará lista.
    1. Navegar a "Network" > "DHCP and DNS" > "Hostnames".
    2. Hacer clic en el botón `Add`.
    3. `Hostname`: `homeassistant`.
    4. `IP Address`: `192.168.1.11`.
    5. Hacer clic en el botón `Save`.
    6. Hacer clic en el botón `Save & Apply`.
9. Agregar Split Horizon DNS para nuestro subdominio.
    1. Navegar a la pestaña "General".
    2. `Addresses`: `/.micasa.duckdns.org/192.168.1.253` y `/.micasa.duckdns.org/XXXX::fffd` donde XXXX::fffd es la dirección IPv6 ULA del servidor. Puede ver esta dirección en la pestaña "Leases" bajo "Active DHCPv6 Leases". Si no cuenta con IPv6, usar solo la línea de IPv4.
    3. Hacer clic en el botón `Save & Apply`.

[<img width="33.3%" src="buttons/prev-Configure dns.es.svg" alt="Configurar DNS">](Configure%20dns.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create and configure public external traffic stack optional.es.svg" alt="Crear y configurar stack de tráfico externo público">](Create%20and%20configure%20public%20external%20traffic%20stack.es.md)

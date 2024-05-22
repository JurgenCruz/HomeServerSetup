# Configurar DNS del router

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20router%20dns.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20router%20dns.es.md)

Cada router es diferente, asi que tal vez requiera leer el manual para saber como hacer pasos específicos. La guía va a usar un router con OpenWrt como ejemplo ya que su naturaleza de código abierto se alínea con el espíritu de esta guía.

Configuraremos nuestro DNS ascendente y usaremos DNS-sobre-HTTPS (DoH) para mejor privacidad; configuraremos el rango de IPs del DHCP; estableceremos un IP estático para el servidor; configuraremos el DNS para agregar los dispositivos con IPs estáticos al dominio `lan`; y finalmente, configuraremos el Split Horizon para nuestro subdominio de DuckDNS.org, para poder usarlo desde adentro de nuestra LAN.

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
4. Configurar el rango del DHCP.
    1. Navegar a "Network" > "Interfaces".
    2. Editar la interfaz `lan`.
    3. Navegar a la pestaña "DHCP Server".
    4. Establecer `Start` a `64` y `Limit` a `189`.
    5. Hacer clic en el botón `Save`.
    6. Hacer clic en el botón `Save & Apply`.
5. Establecer IP estático para el servidor.
    1. Ver el nombre del dispositivo de red físico activo, por ejemplo `enp1s0` o `eth0`: `nmcli device status`. Si existe más de un dispositivo físico, seleccionar el que esté conectado al router con mejor velocidad. Reemplazar en los comandos siguientes `enp1s0` por el dispositivo correcto.
    2. Asignar IP estático y rango CIDR: `nmcli con mod enp1s0 ipv4.addresses 192.168.1.253/24`. Normalmente los routers de hogar usan un rango CIDR de `/24` o su equivalente mascara de subred `255.255.255.0`. Revise el manual de su router para más información.
    3. Deshabilitar cliente DHCP: `nmcli con mod enp1s0 ipv4.method manual`.
    4. Configurar el IP del router: `nmcli con mod enp1s0 ipv4.gateway 192.168.1.254`. Normalmente el router se asigna un IP estático que es el penúltimo IP del rango de IPs.
    5. Configurar el router como DNS y Cloudflare como DNS de respaldo: `nmcli con mod enp1s0 ipv4.dns "192.168.1.254 1.1.1.1"`. Si gusta usar otro DNS como el de Google, puede cambiarlo.
    6. Reactivar el dispositivo para que surtan efecto los cambios: `nmcli con up enp1s0`. Esto puede terminar la sesión SSH. de ser así, vuelva a hacer `ssh` al servidor.
6. Agregar servicios con IP estático al dominio `lan`. Como estos no usan DHCP. el router no los agrega a la lista de hosts.
    1. Navegar a "Network" > "DHCP and DNS" > "Hostnames".
    2. Hacer clic en el botón `Add`.
    3. `Hostname`: `server`.
    4. `IP Address`: `192.168.1.253`.
    5. Hacer clic en el botón `Save`.
    6. Hacer clic en el botón `Add`.
    7. `Hostname`: `homeassistant`.
    8. `IP Address`: `192.168.1.11`.
    9. Hacer clic en el botón `Save`.
    10. Hacer clic en el botón `Save & Apply`.
7. Agregar Split Horizon DNS para nuestro subdominio.
    1. Navegar a la pestaña "General".
    2. `Addresses`: `/.micasa.duckdns.org/192.168.1.253`
    3. Hacer clic en el botón `Save & Apply`.

[<img width="33.3%" src="buttons/prev-Configure dns.es.svg" alt="Configurar DNS">](Configure%20dns.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create and configure public external traffic stack optional.es.svg" alt="Crear y configurar stack de tráfico externo público (Opcional)">](Create%20and%20configure%20public%20external%20traffic%20stack%20optional.es.md)

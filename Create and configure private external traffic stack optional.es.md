# Crear y configurar stack de tráfico externo privado (Opcional)

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.es.md)

Esta guía asume que un router OpenWrt está siendo usado. Los routers OpenWrt tienen la posibilidad the configurar la VPN local directamente desde el router. Esto es mejor, ya que no solo aligerará la carga del servidor, también significa que en caso de que el servidor se cayera, la VPN seguiría sirviendo y permitiría conectar al servidor para diagnosticar el problema. Si no cuenta con un router con capacidad de VPN, puede seguir esta sección para ejecutar la VPN desde el servidor. Si cuenta con un router OpenWrt, entonces puede mejor seguir esta guía: https://openwrt.org/docs/%20guide-user/services/vpn/wireguard/server#luci_web_interface_instructions

> [!NOTE]
> Si sigue esa guía, puede usar `10.13.13.1/24` como la subred en vez de `10.0.0.1/24` como la guía recomienda para que coincida con esta guía. También, mientras configura los `Wireguard Peers`, es recomendable que use un CIDR de un solo IP (e.g. `10.13.13.2/32` en vez de `10.0.0.10/24` como la guía sugiere) en `Allowed IPs` para que el par sea asignado la misma IP todas las veces. La guía también usa el valor por defecto de `0.0.0.0/0` para `Allowed IPs` durante la generación de la configuración del par. Si prefiere tener "split tunneling" como esta guía, elimine los valores por defecto y en su lugar agregue `192.168.1.0/24` (use la subred de su LAN si es diferente) y `10.13.13.0/24`. No olvide también cambiar el `endpoint` a `wg.micasa.duckdns.org` cuando genere la configuración.

Configuraremos el stack de Docker de tráfico privado; configuraremos el cortafuegos para permitir el puerto necesario; y levantaremos el stack a través de Dockhand. Haremos Port Forwarding del puerto 51820 para WireGuard. Finalmente, configuraremos los clientes que se van a conectar a ella. Esto se puede hacer de 2 formas: a través de un código QR o a través de un archivo `.conf`. Una vez conectados a esta VPN, podremos acceder a servicios que no expusimos públicamente con nuestro Reverse Proxy como Dockhand y Cockpit, los cuales son demasiado críticos como para exponer a ataques en la internet pública. El stack consiste del siguiente contenedor:

- WireGuard: VPN para la red local.

> [!NOTE]
> WireGuard será configurado con "split tunneling". Si usted desea redireccionar todo el tráfico del cliente, entonces debe cambiar la variable `ALLOWEDIPS` en el stack en Dockhand a `0.0.0.0/0`.

## Pasos

1. Ejecutar: `./scripts/create_wireguard_folder.sh` para generar el directorio del contenedor en el SSD.
2. Ejecutar: `./scripts/iptable_setup.sh`. Agrega un módulo de kernel al inicio del sistema necesario para WireGuard.
3. Editar el archivo del stack: `nano ./files/private-traffic-stack.yml`.
4. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
5. Reemplazar las XXX con el `uid` y `gid` del usuario `mediacenter`. Se puede usar `id mediacenter` para obtener el `uid` y `gid`.
6. Reemplazar `myhome` por el subdominio que registró en DuckDNS.org y ajustar la variable `ALLOWEDIPS` en caso de que `192.168.1.0/24` no sea el rango CIDR de su red local. No remover `10.13.13.0` ya que es la red interna de WireGuard y perderá conectividad si la remueve. Si asignó un IP diferente a su DNS (por ejemplo si usó Technitium), ajustar la variable `PEERDNS` con la IP correcta. No remover `10.13.13.1` ya que es el DNS interno de WireGuard y no va a funcionar. La guía asume 2 clientes que se conectaran a la VPN con los IDs: `phone` y `laptop`. Si usted requiere más o menos clientes, agregar o remover o renombrar los IDs de los clientes que desee.
7. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
8. Ejecutar: `./scripts/wireguard_firewalld_services.sh`. Configura Firewalld para WireGuard. El script abre el puerto para WireGuard.
9. Agregar stack en Dockhand desde el navegador.
    1. Acceder a Dockhand a través de https://Dockhand.micasa.duckdns.org.
    2. Darle clic en "Stacks" en el menú izquierdo y crear un nuevo stack.
    3. Ponerle nombre "private-traffic" y pegar el contenido del private-traffic-stack.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Dockhand y no en el archivo.
10. Configurar el router. Cada router es diferente, así que tendrá que consultar su manual para poder hacer el paso siguiente.
    1. Redireccionar el puerto (Port Forwarding) 51820 en UDP al servidor.
11. Si se desea configurar con código QR hacer lo siguiente:
    1. Acceder a Dockhand en su red local desde un dispositivo que no es el cliente que va a configurar.
    2. Navegar a `Containers`.
    3. En la fila del contenedor `wireguard` presionar el botón de `terminal`.
    4. Presionar `Connect`.
    5. Mostrar el código QR para el cliente `phone` en la consola con: `/app/show-peer phone`.
    6. Desde el dispositivo que va a ser el cliente `phone` (su celular por ejemplo), abrir la aplicación de WireGuard y seleccionar `Agregar túnel`.
    7. Elegir `Escanear código QR` y escanear el código que se desplegó en la consola.
    8. Si desea probar que funciona correctamente, desconectar su dispositivo de la red local (apagar el Wifi por ejemplo) y habilitar la VPN. Intentar acceder a una IP de su red local.
12. Si se desea configurar con archivo de configuración hacer lo siguiente (Nota: la guía asume un dispositivo Linux que ya tiene instalado el paquete `wireguard-tools` o equivalente. Para otro SO, favor de leer la documentación de WireGuard):
    1. Conectar al servidor desde el dispositivo que va a ser el cliente con SSH: `ssh admin@server.lan`.
    2. Mostramos la configuración para el cliente `laptop`: `sudo cat /Apps/wireguard/peer_laptop/peer_laptop.conf`.
    3. Copiar el contenido del archivo al portapapeles.
    4. Regresar a la consola del dispositivo cliente con `exit` o abrir una nueva consola.
    5. Creamos el archivo de configuración para una red virtual con nombre `wg0`: `sudo nano /etc/wireguard/wg0.conf`.
    6. Pegar el contenido del portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
    7. Si desea probar que funciona correctamente, desconectar su dispositivo de la red local (conectarse a su red Wifi de invitado o desde la red pública de un café o use su celular como módem) y habilitar la red virtual `wg0` con: `wg-quick up wg0`. Intentar acceder a una IP de su red local.

[<img width="33.3%" src="buttons/prev-Create and configure home assistant stack.es.svg" alt="Crear y configurar stack de Home Assistant">](Create%20and%20configure%20home%20assistant%20stack.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Configure scheduled tasks.es.svg" alt="Configurar tareas programadas">](Configure%20scheduled%20tasks.es.md)
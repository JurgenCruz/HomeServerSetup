# Crear stack de redes compartidas

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20shared%20networks%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20shared%20networks%20stack.es.md)

Crearemos una red macvlan auxiliar para poder comunicarnos con Home Assistant que estará en una macvlan de Docker. La guía asumirá una red local con rango CIDR 192.168.1.0/24, con el router en la penúltima dirección (192.168.1.254) y el servidor en la antepenúltima (192.168.1.253). Si necesita usar otro rango, solo reemplazar por el rango correcto en el resto de la guía. Después, configuraremos el stack de Docker de redes compartidas y levantaremos el stack a través de Portainer. El stack consiste de las siguientes redes:

- lanvlan: Esta es una red virtual que permitirá a los contenedores ser asignados una IP directamente en nuestra LAN sin compartir puertos con el servidor.

## Pasos

1. Agregar conexión macvlan auxiliar: `nmcli con add con-name macvlan-shim type macvlan ifname macvlan-shim ip4 192.168.1.12/32 dev enp1s0 mode bridge`. `192.168.1.12` es el IP del servidor dentro de está red auxiliar. Si su red local esta en otro prefijo, ajuste este IP a uno dentro de su prefijo pero fuera del rango de asignación del DHCP para evitar colisiones.
2. Agregar ruta a conexión auxiliar para la red macvlan: `nmcli con mod macvlan-shim +ipv4.routes "192.168.1.0/27"`. `192.168.1.0/27` es el rango de IPs de la red macvlan que coincide con el prefijo de la red local y a su vez está fuera del rango de asignación del DHCP.
3. Activar la conexión auxiliar: `nmcli con up macvlan-shim`.
4. Editar el archivo del stack: `nano ./files/network-stack.yml`.
5. Ajustar la red `lanvlan`.
    1. Ajustar atributo `parent` con el dispositivo que usó para crear la red macvlan auxiliar anteriormente. Por ejemplo `enp1s0`.
    2. Ajustar atributo `subnet` con el rango de su red local.
    3. Ajustar atributo `gateway` con el IP de su router.
    4. Ajustar atributo `ip_range` con el rango de su red local que el DHCP no asigna. La guía configuró Technitium para no asignar las primeras 64 direcciones, por eso usamos un rango 192.168.1.0/27. Si usted configuró su DHCP con otro rango no asignable, use ese aquí.
    5. Ajustar atributo `host` con el IP del servidor en la red macvlan auxiliar.
6. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
7. Agregar stack en Portainer desde el navegador.
    1. Acceder a Portainer a través de https://192.168.1.253:9443. Si sale una alerta de seguridad, puede aceptar el riesgo ya que Portainer usa un certificado de SSL autofirmado.
    2. Darle clic en "Get Started" y luego seleccionar "local".
    3. Seleccionar "Stacks" y crear un nuevo stack.
    4. Ponerle nombre "networks" y pegar el contenido del network-stack.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Portainer y no en el archivo.

[<img width="33.3%" src="buttons/prev-Install docker.es.svg" alt="Instalar Docker">](Install%20docker.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create and configure home assistant stack.es.svg" alt="Crear y configurar stack de Home Assistant">](Create%20and%20configure%20home%20assistant%20stack.es.md)

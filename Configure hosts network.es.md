# Configurar red del anfitrión

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20hosts%20network.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20hosts%20network.es.md)

Para evitar que las configuraciones de las conexiones se rompan en el futuro, es útil asignar al servidor un IP estático en la red local. Configuraremos el servidor para no usar DHCP y asignarse un IP en la red. Además crearemos una red macvlan auxiliar para poder comunicarnos con Home Assistant que estará en una macvlan de Docker. La guía asumirá una red local con rango CIDR 192.168.1.0/24, con el router en la penúltima dirección (192.168.1.254) y el servidor en la antepenúltima (192.168.1.253). Si necesita usar otro rango, solo reemplazar por el rango correcto en el resto de la guía.

## Pasos

1. Ejecutar: `./scripts/disable_resolved.sh`. Desactivamos el servicio de DNS local "systemd-resolved" para desocupar el puerto DNS que necesita Technitium.
2. Ver el nombre del dispositivo de red físico activo, por ejemplo `enp1s0` o `eth0`: `nmcli device status`. Si existe más de un dispositivo físico, seleccionar el que esté conectado al router con mejor velocidad. Reemplazar en los comandos siguientes `enp1s0` por el dispositivo correcto.
3. Asignar IP estático y rango CIDR: `nmcli con mod enp1s0 ipv4.addresses 192.168.1.253/24`. Normalmente los routers de hogar usan un rango CIDR de `/24` o su equivalente mascara de subred `255.255.255.0`. Revise el manual de su router para más información.
4. Deshabilitar cliente DHCP: `nmcli con mod enp1s0 ipv4.method manual`.
5. Configurar el IP del router: `nmcli con mod enp1s0 ipv4.gateway 192.168.1.254`. Normalmente el router se asigna un IP estático que es el penúltimo IP del rango de IPs.
6. Configurar Technitium como DNS y Cloudflare como DNS de respaldo: `nmcli con mod enp1s0 ipv4.dns "192.168.1.10 1.1.1.1"`. Si gusta usar otro DNS como el de Google, puede cambiarlo.
7. Reactivar el dispositivo para que surtan efecto los cambios: `nmcli con up enp1s0`. Esto puede terminar la sesión SSH. de ser así, vuelva a hacer `ssh` al servidor.
8. Agregar conexión macvlan auxiliar: `nmcli con add con-name macvlan-shim type macvlan ifname macvlan-shim ip4 192.168.1.12/32 dev enp1s0 mode bridge`. `192.168.1.12` es el IP del servidor dentro de está red auxiliar. Si su red local esta en otro prefijo, ajuste este IP a uno dentro de su prefijo pero fuera del rango de asignación del DHCP para evitar colisiones.
9. Agregar ruta a conexión auxiliar para la red macvlan: `nmcli con mod macvlan-shim +ipv4.routes "192.168.1.0/27"`. `192.168.1.0/27` es el rango de IPs de la red macvlan que coincide con el prefijo de la red local y a su vez está fuera del rango de asignación del DHCP.
10. Activar la conexión auxiliar: `nmcli con up macvlan-shim`.

[<img width="50%" src="buttons/prev-Configure zfs.es.svg" alt="Configurar ZFS">](Configure%20zfs.es.md)[<img width="50%" src="buttons/next-Configure shares.es.svg" alt="Configurar shares">](Configure%20shares.es.md)

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

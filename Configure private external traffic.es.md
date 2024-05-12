# Configurar tráfico externo privado

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20private%20external%20traffic.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20private%20external%20traffic.es.md)

WireGuard de hecho ya fue configurado en el stack de Portainer y ya debería estar corriendo la VPN. Lo único que falta es configurar los clientes que se van a conectar a ella. Esto se puede hacer de 2 formas: a través de un código QR o a través de un archivo `.conf`. Una vez conectados a esta VPN, podremos acceder a servicios que no expusimos públicamente con nuestro Reverse Proxy como Portainer y Cockpit, los cuales son demasiado críticos como para exponer a ataques en la internet publica.

> [!NOTE]
> WireGuard fue configurado con "split tunneling". Si usted desea redireccionar todo el tráfico del cliente, entonces debe cambiar la variable `ALLOWEDIPS` en el stack en Portainer a `0.0.0.0/0`.

## Pasos

1. Si se desea configurar con código QR hacer lo siguiente:
    1. Acceder a Portainer en su red local desde un dispositivo que no es el cliente que va a configurar.
    2. Navegar a `local` > `Containers`.
    3. En la fila del contenedor `wireguard` presionar el botón de `exec console`.
    4. Presionar `Connect`.
    5. Mostrar el código QR para el cliente `phone` en la consola con: `/app/show-peer phone`.
    6. Desde el dispositivo que va a ser el cliente `phone` (su celular por ejemplo), abrir la aplicación de WireGuard y seleccionar `Agregar túnel`.
    7. Elegir `Escanear código QR` y escanear el código que se desplegó en la consola.
    8. Si desea probar que funciona correctamente, desconectar su dispositivo de la red local (apagar el Wifi por ejemplo) y habilitar la VPN. Intentar acceder a una IP de su red local.
2. Si se desea configurar con archivo de configuración hacer lo siguiente (Nota: la guía asume un dispositivo Linux que ya tiene instalado el paquete `wireguard-tools` o equivalente. Para otro SO, favor de leer la documentación de WireGuard):
    1. Conectar al servidor desde el dispositivo que va a ser el cliente con SSH: `ssh admin@server.lan`.
    2. Mostramos la configuración para el cliente `laptop`: `sudo cat /Apps/wireguard/peer_laptop/peer_laptop.conf`.
    3. Copiar el contenido del archivo al portapapeles.
    4. Regresar a la consola del dispositivo cliente con `exit` o abrir una nueva consola.
    5. Creamos el archivo de configuración para una red virtual con nombre `wg0`: `sudo nano /etc/wireguard/wg0.conf`.
    6. Pegar el contenido del portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
    7. Si desea probar que funciona correctamente, desconectar su dispositivo de la red local (conectarse a su red Wifi de invitado o desde la red publica de un café o use su celular como módem) y habilitar la red virtual `wg0` con: `wg-quick up wg0`. Intentar acceder a una IP de su red local.

[<img width="50%" src="buttons/prev-Configure public external traffic.es.svg" alt="Configurar tráfico externo público">](Configure%20public%20external%20traffic.es.md)[<img width="50%" src="buttons/next-Install cockpit.es.svg" alt="Instalar Cockpit">](Install%20cockpit.es.md)

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

# Instalar Docker

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Install%20docker.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Install%20docker.es.md)

Instalaremos Docker como nuestro motor de contenedores con soporte de IPv6; opcionalmente instalaremos los controladores de Nvidia y "Nvidia Container Toolkit"; y configuraremos SELinux para asegurar Docker.

## Pasos

1. Ejecutar: `./scripts/docker_setup.sh admin`. Agrega el repositorio de Docker, lo instala, habilita el servicio y agrega al usuario `admin` al grupo `docker`.
2. Abrir https://simpledns.plus/private-ipv6 y anotar el `Combined/CID` y remover el último bloque. Por ejemplo `fda6:80d8:cf96:a065::/64` se convierte en `fda6:80d8:cf96::/64`.
3. Editar el script: `nano ./scripts/selinux_setup.sh`.
4. Reemplazar el valor de `fixed-cidr-v6` con el CIDR que generó a traves del sitio. Guardar y salir con `Ctrl + X, Y, Enter`.
5. Ejecutar: `./scripts/selinux_setup.sh`. Habilita SELinux en Docker; reinicia el servicio de Docker para que surtan efecto los cambios; activa las banderas que permite a los contenedores manejar la red y usar el GPU; e instala pólizas de SELinux. Estas son necesarias para algunos contenedores para poder acceder a archivos de Samba e interactuar con WireGuard y para que rsync sea capaz de respaldar las aplicaciones.
6. Opcional: Si tiene una tarjeta Nvidia relativamente moderna, ejecutar: `./scripts/nvidia_setup.sh`. Agrega repositorios de "RPM Fusion" y Nvidia para instalar el controlador y el "Nvidia Container Toolkit" para Docker. También registra la llave de "Akmods" en la cadena de Secure Boot. Es necesario reiniciar y repetir el proceso de enrolar la llave como lo hicimos con ZFS. Después de reiniciar e iniciar sesión, no se olvide de asumir `root` con `sudo -i`. Una optimización que puede hacer es modificar la configuración de Nvidia Runtime con: `nano /etc/nvidia-container-runtime/config.toml` y descomentar la línea `no-cgroups = false`. Presione Ctrl + S para guardar y Ctrl + X para salir de nano.
7. Ejecutar: `./scripts/create_dockhand_folder.sh` para generar el directorio del contenedor en el SSD.
8. Editar el archivo del stack: `nano ./files/dockhand-stack.yml`.
9. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
10. Reemplazar las XXX con el `uid` y `gid` del usuario `mediacenter`. Se puede usar `id mediacenter` para obtener el `uid` y `gid`.
11. Reemplazar las YYY con el `gid` del grupo `docker`. Se puede usar `getent group | grep docker` para obtener el `gid`. Esto permitirá al contenedor controlar Docker a través del socket de Docker.
12. Guardar y salir con `Ctrl + X, Y, Enter`.
13. Ejecutar: `./scripts/run_dockhand.sh`. Esto ejecuta un contenedor de Dockhand y escuchará en el puerto `3000`.
14. Configurar Dockhand desde el navegador.
    1. Acceder a Dockhand a través de http://server.lan:3000.
    2. Navegar a "Settings" > "Authentication" > "Users".
    3. Generar una contraseña aleatoria y crear usuario `admin`. Se recomienda Bitwarden nuevamente para esto.
    4. Regresar a la pestaña "Authentications" > "General" y habilitar "Authentication".
    5. Refrescar la página e iniciar sesión con el nuevo usuario.
    6. Navegar a "Settings" > "Notifications" y hacer clic en el botón "Add channel".
    7. "Name": "Gotify".
    8. "Type": "Apprise (Webhooks)".
    9. "URL": "gotifys://hostname/{token}". {token} será reemplazado más adelante en la guía con el valor correcto.
    10. Hacer clic en el botón "Add".
    11. Navegar a "Settings" > "Environments".
    12. Hacer clic en el botón "Add environment".
    13. "Name": "local".
    14. "Connection type": "Unix socket".
    15. "Socket path": "/var/run/docker.sock".
    16. Navegar a la pestaña "Security" y habilitar "Vulnerability scanning".
    17. Navegar a la pestaña "Notifications" y habilitar el canal "Gotify".
    18. Hacer clic en el botón "Add".

[<img width="33.3%" src="buttons/prev-Configure shares.es.svg" alt="Configurar shares">](Configure%20shares.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create shared networks stack.es.svg" alt="Crear stack de redes compartidas">](Create%20shared%20networks%20stack.es.md)

# Instalar Docker

Instalaremos Docker como nuestro motor de contenedores con soporte de IPv6; opcionalmente instalaremos los controladores de Nvidia y "Nvidia Container Toolkit"; y configuraremos SELinux para asegurar Docker.

## Pasos

1. Ejecutar: `./scripts/docker_setup.sh admin`. Agrega el repositorio de Docker, lo instala, habilita el servicio y agrega al usuario `admin` al grupo `docker`.
2. Abrir https://simpledns.plus/private-ipv6 y anotar el `Combined/CID` y remover el último bloque. Por ejemplo `fda6:80d8:cf96:a065::/64` se convierte en `fda6:80d8:cf96::/64`.
3. Editar el script: `nano ./scripts/selinux_setup.sh`.
4. Reemplazar el valor de `fixed-cidr-v6` con el CIDR que generó a traves del sitio. Guardar y salir con `Ctrl + X, Y, Enter`.
5. Ejecutar: `./scripts/selinux_setup.sh`. Habilita SELinux en Docker; reinicia el servicio de Docker para que surtan efecto los cambios; activa las banderas que permite a los contenedores manejar la red y usar el GPU; e instala pólizas de SELinux. Estas son necesarias para algunos contenedores para poder acceder a archivos de Samba e interactuar con WireGuard y para que rsync sea capaz de respaldar las aplicaciones.
6. Opcional: Si tiene una tarjeta Nvidia relativamente moderna, ejecutar: `./scripts/nvidia_setup.sh`. Agrega repositorios de "RPM Fusion" y Nvidia para instalar el controlador y el "Nvidia Container Toolkit" para Docker. También registra la llave de "Akmods" en la cadena de Secure Boot. Es necesario reiniciar y repetir el proceso de enrolar la llave como lo hicimos con ZFS. Después de reiniciar e iniciar sesión, no se olvide de asumir `root` con `sudo -i`. Una optimización que puede hacer es modificar la configuración de Nvidia Runtime con: `nano /etc/nvidia-container-runtime/config.toml` y descomentar la línea `no-cgroups = false`. Presione Ctrl + S para guardar y Ctrl + X para salir de nano.
7. Ejecutar: `./scripts/create_arcane_folder.sh` para generar el directorio del contenedor en el SSD.
8. Ejecutar: `openssl rand -hex 32` y copiar la llave generada.
9. Editar el archivo del stack: `nano ./files/arcane-stack.yml`.
10. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
11. Reemplazar las XXX con el `uid` y `gid` del usuario `mediacenter`. Se puede usar `id mediacenter` para obtener el `uid` y `gid`.
12. Reemplazar {key} con la llave generada con el comando openssl.
13. Guardar y salir con `Ctrl + X, Y, Enter`.
14. Ejecutar: `./scripts/run_arcane.sh`. Esto ejecuta un contenedor de Arcane y escuchará en el puerto `3552`.
15. Configurar Arcane desde el navegador.
    1. Acceder a Arcane a través de http://server.lan:3552.
    2. Acceder con el nombre de usuario `arcane` y contraseña `arcane-admin`.
    3. Generar una contraseña aleatoria y cambiar la contraseña. Se recomienda Bitwarden nuevamente para esto.
    4. Navegar a "Settings" > "Notifications" > "Gotify" y habilitarlo.
    5. "Server Host": "gotify.micasa.duckdns.org".
    6. "Application Token": "{token}". El {token} será reemplazado más adelante en la guía con el valor correcto.
    7. "Priority": 5.
    8. Hacer clic en el botón "Save" en la parte superior.
    9. Navegar a "Environments".
    10. Hacer clic en "local".
    11. Navegar a la pestaña "Automation" y habilitar "Vulnerability Scan".

# Importar alberca ZFS existente

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Import%20existing%20zfs%20pool.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Import%20existing%20zfs%20pool.es.md)

Puede haber ocasiones en las que desee importar una alberca ZFS existente. Por ejemplo, después de una reinstalación del sistema operativo. Asi es como se hace.

## Pasos

1. Después de iniciar sesión, asumir `root` ejecutando `sudo -i`.
2. Crear el directorio de llaves: `mkdir /keys`. Se asume que esta dirección es la misma usada antes de reinstalar el SO y que la alberca buscará la llave en el mismo directorio. Ajuste la dirección de no ser así.
3. Copiar la llave desde otra computadora: `scp user@host:/path/to/keyfile /keys/Tank.dat`. Cambiar `{user@host:/path/to/keyfile}` por la dirección de la llave en la computadora que contenga el respaldo. Si lo prefiere también puede usar una memoria USB para transferir el respaldo de la llave.
4. Importar las albercas existente: `zpool import -d /dev/disk/by-id -a`. Si la alberca no fue exportada antes, pruebe usar `-f` para forzar la importación.
5. Montar todos los datasets y cargar la llave de ser necesario: `zfs mount -al`.
6. Restaurar las carpetas de los contenedores de los discos duros al SSD: `rsync -avz /mnt/Tank/Apps/ /Apps/`.
7. Ejecutar: `./scripts/generate_dataset_mount_units.sh`. Esto generara unidades de Systemd que montaran los datasets de `Tank` automáticamente después de cargar la llave al reiniciar el servidor. Ejecute este comando `cat /etc/zfs/zfs-list.cache/Tank` para verificar que el archivo de cache no esté vacío. Si está vacío, intente ejecutar el script de nuevo ya que significa que no se generó el cache ni las unidades.

> [!NOTE]
> Después de una importación, habrá ciertos pasos en la guía que podrá omitir. Por ejemplo si ya existían ciertos directorios o archivos. Se deja a discreción del lector ver cuales pasos ya no son necesarios.

> [!TIP]
> Para ajustar el tamaño máximo de ZFS ARC use el comando `echo {size_in_bytes} > /sys/module/zfs/parameters/zfs_arc_max` reemplazando `{size_in_bytes}` por el tamaño en bytes que desea establecer. Para hacer el cambio permanente ejecute el comando `echo "options zfs zfs_arc_max={size_in_bytes}" > /etc/modprobe.d/zfs.conf && dracut --force`.

> [!CAUTION]
> Asignar un valor muy alto puede causar inestabilidad en el sistema, solo cámbielo si sabe lo que hace.

[<img width="50%" src="buttons/prev-Configure zfs.es.svg" alt="Configurar ZFS">](Configure%20zfs.es.md)[<img width="50%" src="buttons/next-Configure hosts network.es.svg" alt="Configurar red del anfitrión">](Configure%20hosts%20network.es.md)

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

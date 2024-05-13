# Crear alberca ZFS

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20zfs%20pool.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20zfs%20pool.es.md)

Ahora configuraremos la alberca de ZFS y sus datasets. Si tiene de 3 a 4 discos, se recomienda `raidz`. Si tiene de 5 a 6 discos, se recomienda `raidz2`. Menos de 3 discos no es recomendable ya que la única redundancia posible sería con 2 discos en modo espejo con solo un disco de redundancia y solo 50% de capacidad. Para más de 6 discos es recomendable que mejor haga 2 o más albercas. También se prepararán directorios para la configuración de los contenedores en la partición del SO, o sea, en el SSD. Esto brinda mejor rendimiento en la ejecución de las mismas. La configuración de los contenedores se respaldara a los discos duros una vez al día.

## Pasos

1. Después de iniciar sesión, asumir `root` ejecutando `sudo -i`.
2. Ejecutar: `./scripts/generate_zfs_key.sh`. Se generará una llave hexadecimal en `/keys/Tank.dat`. Es recomendable que respalde esta llave en un lugar seguro ya que si el SSD falla y se pierde la llave, los datos en la alberca se perderán para siempre.
3. Ejecutar: `./scripts/create_zfs_pool.sh raidz2 /dev/disk/by-id/disk1 /dev/disk/by-id/disk2 /dev/disk/by-id/disk3 /dev/disk/by-id/disk4 /dev/disk/by-id/disk5 /dev/disk/by-id/disk6`. Adecúe los parámetros para escoger el tipo de `raidz` adecuado. Es recomendable usar los nombres de los discos por id, por uuid o por label. **No use el nombre de disco** (por ejemplo /dev/sda) ya que estos pueden cambiar después de un reinicio y la alberca no funcionará.
4. Ejecutar: `printf "nasj\nnask" | ./scripts/create_zfs_datasets.sh`. Se crearan datasets con el nombre del usuario en mayúsculas, por ejemplo `Tank/NASJ`. Ademas creará un dataset `Tank/Apps` para respaldar la configuración de los contenedores y un dataset `Tank/MediaCenter` para guardar los archivos de media. Los datasets que serán usados como Samba shares serán configurados para que SELinux permita el acceso a ellos por Samba.
5. Ejecutar: `./scripts/create_app_folders.sh` para generar los directorios de los contenedores en el SSD.
6. Ejecutar: `./scripts/generate_dataset_mount_units.sh`. Esto generara unidades de Systemd que montaran los datasets de `Tank` automáticamente después de cargar la llave al reiniciar el servidor. Ejecute este comando `cat /etc/zfs/zfs-list.cache/Tank` para verificar que el archivo de cache no esté vacío. Si está vacío, intente ejecutar el script de nuevo ya que significa que no se generó el cache ni las unidades.

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

# Crear alberca ZFS

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20zfs%20pool.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20zfs%20pool.es.md)

Ahora configuraremos la alberca de ZFS y sus datasets. Si tiene de 3 a 4 discos, se recomienda `raidz`. Si tiene de 5 a 6 discos, se recomienda `raidz2`. Menos de 3 discos no es recomendable ya que la única redundancia posible sería con 2 discos en modo espejo con solo un disco de redundancia y solo 50% de capacidad. Para más de 6 discos es recomendable que mejor haga 2 o más albercas. También se prepararán directorios para la configuración de los contenedores en la partición del SO, o sea, en el SSD. Esto brinda mejor rendimiento en la ejecución de las mismas. La configuración de los contenedores se respaldará a los discos duros una vez al día.

## Pasos

1. Después de iniciar sesión, asumir `root` ejecutando `sudo -i`.
2. Ejecutar: `./scripts/generate_zfs_key.sh`. Se generará una llave hexadecimal en `/keys/Tank.dat`. Es recomendable que respalde esta llave en un lugar seguro ya que si el SSD falla y se pierde la llave, los datos en la alberca se perderán para siempre.
3. Ejecutar: `./scripts/create_zfs_pool.sh raidz2 /dev/disk/by-id/disk1 /dev/disk/by-id/disk2 /dev/disk/by-id/disk3 /dev/disk/by-id/disk4 /dev/disk/by-id/disk5 /dev/disk/by-id/disk6`. Adecúe los parámetros para escoger el tipo de `raidz` adecuado. Es recomendable usar los nombres de los discos por id, por uuid o por label. **No use el nombre de disco** (por ejemplo /dev/sda) ya que estos pueden cambiar después de un reinicio y la alberca no funcionará.
4. Ejecutar: `./scripts/create_zfs_datasets.sh`. Ingresar los nombres de los usuarios para los que desee crear Samba shares uno por uno. Se crearán datasets con el nombre del usuario en mayúsculas, por ejemplo `Tank/USUARIO1`. Además, creará un dataset `Tank/Apps` para respaldar la configuración de los contenedores, un dataset `Tank/MediaCenter` para guardar los archivos de media y un dataset `Tank/NextCloud` para guardar los archivos de respaldo. Los datasets que serán usados como Samba shares serán configurados para que SELinux permita el acceso a ellos por Samba.
5. Ejecutar: `./scripts/create_app_folders.sh` para generar los directorios de los contenedores en el SSD.
6. Ejecutar: `./scripts/generate_dataset_mount_units.sh`. Esto generará unidades de Systemd que montaran los datasets de `Tank` automáticamente después de cargar la llave al reiniciar el servidor. Ejecute este comando `cat /etc/zfs/zfs-list.cache/Tank` para verificar que el archivo de caché no esté vacío. Si está vacío, intente ejecutar el script de nuevo ya que significa que no se generó el caché ni las unidades.

> [!TIP]
> Para ajustar el tamaño máximo de ZFS ARC, use el comando `echo {size_in_bytes} > /sys/module/zfs/parameters/zfs_arc_max` reemplazando `{size_in_bytes}` por el tamaño en bytes que desea establecer. Para hacer el cambio permanente, ejecute el comando `echo "options zfs zfs_arc_max={size_in_bytes}" > /etc/modprobe.d/zfs.conf && dracut --force`.

> [!CAUTION]
> Asignar un valor muy alto puede causar inestabilidad en el sistema, solo cámbielo si sabe lo que hace.

[<img width="33.3%" src="buttons/prev-Configure zfs.es.svg" alt="Configurar ZFS">](Configure%20zfs.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Configure shares.es.svg" alt="Configurar shares">](Configure%20shares.es.md)

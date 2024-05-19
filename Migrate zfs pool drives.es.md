# Migrar discos de la alberca ZFS

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Migrate%20zfs%20pool%20drives.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Migrate%20zfs%20pool%20drives.es.md)

Si desea migrar su alberca a otros discos, quizás a discos más grandes, puede seguir los siguientes pasos. Si tiene de 3 a 4 discos, se recomienda `raidz`. Si tiene de 5 a 6 discos, se recomienda `raidz2`. Menos de 3 discos no es recomendable ya que la única redundancia posible sería con 2 discos en modo espejo con solo un disco de redundancia y solo 50% de capacidad. Para más de 6 discos es recomendable que mejor haga 2 o más albercas.

## Pasos

1. Después de iniciar sesión, asumir `root` ejecutando `sudo -i`.
2. Ejecutar: `./scripts/migrate_pool.sh Tank raidz2 /dev/disk/by-id/disk1 /dev/disk/by-id/disk2 /dev/disk/by-id/disk3 /dev/disk/by-id/disk4 /dev/disk/by-id/disk5 /dev/disk/by-id/disk6`. Se asume que la nueva alberca usará la misma llave que la anterior y que ya está en su lugar. `Tank` es el nombre de la alberca actual. Es el mismo nombre usado por el script que crea la alberca inicialmente. Los demás parámetros son los mismos que para `create_zfs_pool.sh`. Ver información en la sección `Crear alberca ZFS`.
3. Montar todos los datasets y cargar la llave de ser necesario: `zfs mount -al`.
4. Ejecutar: `./scripts/generate_dataset_mount_units.sh`. Esto generara unidades de Systemd que montaran los datasets de `Tank` automáticamente después de cargar la llave al reiniciar el servidor. Ejecute este comando `cat /etc/zfs/zfs-list.cache/Tank` para verificar que el archivo de cache no esté vacío. Si está vacío, intente ejecutar el script de nuevo ya que significa que no se generó el cache ni las unidades.

> [!NOTE]
> Después de una migración, habrá ciertos pasos en la guía que podrá omitir. Por ejemplo si ya existían ciertos directorios o archivos. Se deja a discreción del lector ver cuales pasos ya no son necesarios.

> [!TIP]
> Para ajustar el tamaño máximo de ZFS ARC use el comando `echo {size_in_bytes} > /sys/module/zfs/parameters/zfs_arc_max` reemplazando `{size_in_bytes}` por el tamaño en bytes que desea establecer. Para hacer el cambio permanente ejecute el comando `echo "options zfs zfs_arc_max={size_in_bytes}" > /etc/modprobe.d/zfs.conf && dracut --force`.

> [!CAUTION]
> Asignar un valor muy alto puede causar inestabilidad en el sistema, solo cámbielo si sabe lo que hace.

[<img width="33.3%" src="buttons/prev-Configure zfs.es.svg" alt="Configurar ZFS">](Configure%20zfs.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Configure shares.es.svg" alt="Configurar shares">](Configure%20shares.es.md)

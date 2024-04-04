# Servidor NAS, Media Center y Home Automation

Esta es una guía de como configurar un servidor casero desde cero. Si usted no está familiarizado con algún concepto, la guía provee un glosario al final de la misma para su conveniencia.

## Indice

1. Objetivo
2. Características
3. Diseño y justificación
4. Prerequisitos mínimos
5. Guía
    1. Instalar Fedora Server
    2. Configurar Secure Boot
    3. Instalar y configurar Zsh (Opcional)
    4. Configurar usuarios
    5. Instalar ZFS
    6. Configurar ZFS
    7. Configurar IP estático
    8. Configurar shares
    9. Registrar DDNS
    10. Instalar Docker
    11. Preparar configuración de Pi-hole
    12. Crear stack de Docker
    13. Configurar aplicaciones
    14. Configurar tareas cron
    15. Configurar tráfico externo público
    16. Configurar tráfico externo privado
    17. Instalar Cockpit
6. Glosario

## 1. Objetivo

Configurar un servidor casero sencillo, accesible, seguro, barato y útil.

## 2. Características

- Seguro.
- Privado.
- Robusto.
- Resiliente.
- Respaldo de archivos y acceso remoto a los mismos.
- Servicio de medios.
- Automatización del hogar.
- Administración del servidor a través de un explorador e interfaz gráfica.
- Usar código abierto y gratuito.

## 3. Diseño y justificación

- Fedora Server: Fedora Server brinda una combinación de estabilidad y modernidad como sistema operativo. Al tener un ciclo de lanzamiento corto podemos tener acceso a tecnologías nuevas y no es necesario hacer una actualización completa como Debian. Al mismo tiempo, no es una distribución de lanzamiento rodante, por lo que no tendremos inestabilidades tras actualizar.
- Sistema entero encriptado: Un sistema seguro y privado requiere evitar la modificación y lectura del sistema sin consentimiento del usuario. Por esto, es necesario encriptar los datos en todos los medios. El SO es encriptado usando LUKS con contraseña, mientras que los discos duros serán encriptados usando encriptación nativa de ZFS con una llave. La llave permanecerá en la partición del SO encriptado, de tal manera que no puede ser accedida sin abrir primero el SO con la contraseña, al mismo tiempo que permite no requerir una segunda contraseña.
- Secure Boot habilitado: Para garantizar la seguridad y privacidad del servidor, es necesario asegurar la cadena de inicio de la computadora. Esto solo se puede lograr con Secure Boot habilitado.
- Sistema de archivos ZFS: ZFS es un sistema de archivos robusto seleccionado por usar COW (copiar durante escritura), acceso a RAIDZ para redundancia de discos, snapshots nativos, encriptación nativa y compresión. Es una de los mejores opciones como sistema de archivos para un NAS.
- Samba shares para múltiples usuarios: Samba permite acceder remotamente a los archivos del NAS de manera segura y compatible con múltiples sistemas operativos. Permite el uso de ACL para definir los permisos para el acceso a los archivos y garantizar la privacidad.
- Docker como motor de contenerización: Docker es el motor de contenerización mas usado y sencillo. Para mantener accesible el servidor, vamos a evitar usar otros motores más complejos como Kubernetes y Podman.
- Ecosistema de aplicaciones ARR: Este grupo de micro servicios brinda un sistema de entretenimiento en casa con acceso a películas y series completamente automatizado y personalizable con una interfaz intuitiva y completo control del mismo.
- Pi-hole como servidor DNS y DHCP: Pi-hole nos ayuda a bloquear dominios de publicidad, rastreo y malware al mismo tiempo que nos permite configurar "split horizon DNS" y DHCP en un solo servicio.
- Home Assistant como sistema de automatización del hogar: Home Assistant es de software libre y completamente independiente de la nube, brindando privacidad, seguridad y control completo de su hogar.
- Cockpit como administrador de servidor: Cockpit proporciona una administración remota del servidor desde un solo lugar a través de un navegador web con interfaz grafica para mayor conveniencia.
- Portainer como administrador de contenedores: Aunque Cockpit tiene la capacidad de administrar contenedores, solamente soporta Podman y no Docker. Portainer nos permite administrar los contenedores de manera remota desde un navegador web con una interfaz gráfica, en vez de la terminal, y es compatible con Docker.
- qBittorrent con VPN: El protocolo bittorrent permite acceso a librería muy grande de archivos, distribuida, gratuita y en la mayoría de los casos pública. Para poder mantener la privacidad en linea es necesaria una VPN anónima remota para el protocolo bittorrent.
- WireGuard como protocolo para VPN local: Para poder acceder a sistemas críticos remotamente, es necesario no exponerlos públicamente sino a través de una VPN segura. WireGuard es un protocolo de VPN de código abierto, moderno, seguro y eficiente y es ideal para crear una VPN personal conectada a nuestra red local.
- DuckDNS: DuckDNS ofrece un servicio de DDNS gratuito que además suporta múltiples niveles de subdominio. Por ejemplo: `micasa.duckdns.org` y `jellyfin.micasa.duckdns.org` serán mapeados a el mismo IP. Esto es muy útil ya que nos permite tener subdominios propios que el reverse proxy puede usar en sus reglas.

## 4. Prerequisitos mínimos

- Una computadora vieja de no más de 7 años.
- Un SSD para el SO.
- Al menos 3 HDDs del mismo tamaño de al menos 6 TB. Recomendado 6 HDDs de 8 TB.
- Mínimo 8GB de RAM. Se recomienda toda la RAM que pueda soportar la tarjeta madre ya que ZFS puede hacer uso de la RAM como cache para mejor desempeño.
- Conexión a internet. Si se desea ver los medios fuera de casa, es recomendable una buena velocidad de subida.
- Una memoria USB de al menos 1 GB para el ISO de Fedora Server.
- Un proveedor de VPN anónima para bittorrent. Se recomienda Mulvad ya que no requiere ninguna información para usar el servicio y la única información que se expone es la IP. El pago se puede hacer con Monero para aún mayor privacidad.
- Opcional: Tarjeta de red Ethernet de 2.5 Gb. Si la tarjeta madre ya tiene un puerto Ethernet de al menos 1 Gb puede omitirse al menos que se desee mejor rendimiento en la transferencia de datos. La guía asume que conectó el servidor al router a través de este puerto Ethernet.
- Opcional: Tarjeta de video capaz de codificación/decodificación de video para aceleración por hardware. La guía asumirá una tarjeta de video Nvidia.
- Opcional: Tarjeta HBA en modo "passthrough" (i.e. no RAID por hardware). Si su tarjeta madre tiene suficientes puertos para todos los discos, no es necesaria. Es importante revisar el manual de la tarjeta madre y ver si soporta la tarjeta de video, la de red (si no está integrada) y el HBA al mismo tiempo, tanto físicamente (tiene las suficientes ranuras para las tarjetas) como lógicamente (soporta las múltiples ranuras al mismo tiempo. Algunas tarjetas madre solo pueden tener cierta combinación de ranuras funcionando al mismo tiempo).
- La guía asume que el usuario está familiarizado con el manual de su tarjeta madre y el BIOS y ha configurado correctamente el BIOS para su hardware.

## 5. Guía

Esta guía es solo eso, una guía. Siéntase libre de modificar y adecuar los pasos a su gusto y conveniencia. La guía usará algunos nombres y parámetros que usted puede personalizar, por favor esté pendiente si decide usar diferentes nombres o parámetros deberá ajustar algunos pasos y archivos de la guía.

### 5.1. Instalar Fedora Server

Para instalar Fedora Server necesitaremos una memoria USB y descargar el ISO de la pagina oficial de Fedora. Escribiremos el ISO a la USB e iniciaremos el instalador del sistema operativo. Configuraremos nuestra instalación y dejaremos al asistente hacer el resto. La guía asume que preparará el medio de instalación desde un sistema operativo Linux. Si lo hace desde Windows, puede intentar usar la herramienta Rufus y su guía: https://rufus.ie/.

> **Antes de iniciar asegúrese de respaldar los datos de la memoria USB ya que esta será formateada y se perderán todos los datos en ella!**
> **Antes de iniciar asegúrese de respaldar los datos en los discos del servidor ya que estos serán formateados y se perderán todos los datos en ellos!**

#### 5.1.1 Pasos

1. Acceder a https://fedoraproject.org/server/download y descargar el ISO "Network Install" para su arquitectura (normalmente x86_64). Si desea puede verificar la firma del archivo con el hash en la misma pagina.
2. Insertar la memoria USB y determinar el dispositivo usando `lsblk`. Buscar la memoria USB en la lista y anotar el nombre, por ejemplo `sdc`.
3. Si su sistema montó la USB automáticamente, desmontar con `sudo umount /dev/sdc*`.
4. Escribir el ISO a la USB con `dd if=./Fedora-Server-netinst-x86_64-39-1.5.iso of=/dev/sdc bs=8M status=progress`. Ajustar la dirección al archivo ISO en el comando.
5. Extraer la USB e insertarla en el servidor. Si el servidor esta prendido, apagarlo.
6. Prender el servidor y acceder al BIOS (pruebe con la tecla F2 o Insert o lea el manual de su tarjeta madre).
7. Deshabilitar Secure Boot si está activo. Cada BIOS es diferente así que consulte su manual para encontrar la opción.
8. Seleccionar la opción de iniciar desde la USB. Si no se puede, intentar cambiar el orden de dispositivos de inicio y poner la USB antes que otros discos. Guardar y reiniciar. El instalador de Fedora debería iniciar. Si no, intente nuevamente cambiar el orden de inicio.
9. Seleccionar "Test media & install Fedora".
10. Seleccionar el idioma de su preferencia y Continuar. La guía asumirá Inglés.
11. Si desea usar otra distribución del teclado, hacer clic en `Keyboard` y seleccionar una o más distribuciones. Presionar `Done` para regresar al menú principal.
12. Si desea instalar más idiomas, hacer clic en `Language Support` y seleccionar uno o más idiomas. Presionar `Done` para regresar al menú principal.
13. Hacer clic en `Time & Date` y escoger su región y ciudad para seleccionar su huso horario. Asegúrese de habilitar `Network Time`. Presionar `Done` para regresar al menú principal.
14. Hacer clic en `Software Selection`.
15. `Fedora Server Edition` debería estar seleccionado por defecto, si no, seleccionarlo. En `Additional Software` no necesita seleccionar nada, pero si gusta puede instalar lo que desee. Presionar `Done` para regresar al menú principal.
16. Hacer clic en `Network & Host Name` y establecer el `Host Name`. La guía usará `server` pero usted puede usar otro nombre. Presionar `Done` para regresar al menú principal.
17. Hacer clic en `User Creation`. Ingresar `admin` en `User name` (si desea usar otro nombre, use otro, pero la guía asumirá `admin` y deberá ajustar archivos en el futuro con el nombre que escoja). No desactive ninguna casilla.
18. Ingresar una contraseña fuerte y confirmarla. Presionar `Done` para regresar al menú principal.
19. Hacer clic en `Installation Destination` y configurar las particiones. La guía asume que no se ejecutará nada mas en este servidor y borrará todas las particiones. Si usted sabe lo que hace y quiere una configuración diferente, ignore los pasos siguientes y configure las particiones como desee.
    1. Seleccionar unicamente el SSD como disco de instalación.
    2. Seleccionar `Advanced Custom` en `Storage Configuration`. Hacer clic en `Done`
    3. Seleccionar el único disco y borrar todas las particiones existentes.
    4. Agregar nueva partición EFI.
        1. Hacer clic en `Add New Device`.
        2. `Device Type` debe ser `Partition`.
        3. `Size` debe ser 512 MiB.
        4. `Filesystem` debe ser `EFI System Partition`.
        5. `Label` debe ser `EFI`.
        6. `Mountpoint` debe ser `/boot/efi`.
        7. Aceptar.
    5. Seleccionar `free space`.
    6. Agregar partición boot.
        1. Hacer clic en `Add New Device`.
        2. `Device Type` debe ser `Partition`.
        3. `Size` debe ser 512 MiB.
        4. `Filesystem` debe ser `ext4`.
        5. `Label` debe ser `boot`
        6. `Mountpoint` debe ser `/boot`.
        7. Aceptar.
    7. Seleccionar `free space`.
    8. Agregar LVM.
        1. Hacer clic en `Add New Device`.
        2. `Device Type` debe ser `LVM2 Volume Group`.
        3. Usar todo el espacio restante.
        4. `Name` debe ser `root-vg`.
        5. Habilitar `Encrypt`.
        6. Establecer una contraseña para el disco y confirmarla.
        7. Aceptar.
    9. Seleccionar `root-vg`.
    10. Agregar swap.
        1. Hacer clic en `Add New Device`.
        2. `Device Type` debe ser `LVM2 Logical Volume`.
        3. `Size` debe ser de 2 a 8 GiB dependiendo cuanto espacio en la SSD y RAM tenga.
        4. `Filesystem` debe ser `swap`.
        5. `Label` debe ser `swap`
        6. `Name` debe ser `swap`.
        7. Aceptar.
    11. Seleccionar `free space`.
    12. Agregar partición raíz.
        1. Hacer clic en `Add New Device`.
        2. `Device Type` debe ser `LVM2 Logical Volume`.
        3. `Size` debe ser lo que resta de espacio.
        4. `Filesystem` debe ser `ext4`. Si prefiere `btrfs` puede cambiarlo.
        5. `Label` debe ser `root`.
        6. `Name` debe ser `root`.
        6. `Mountpoint` debe ser `/`.
        7. Aceptar.
    13. Hacer clic en `Done`. Revisar los cambios y Aceptar si coincide con los pasos anteriores.
20. Hacer clic en `Begin Installation`. Dejar al instalador hacer su trabajo.
21. Hacer clic en `Reboot System` para reiniciar.
22. Entrar al BIOS nuevamente.
23. Volver a cambiar el orden de inicio y poner Fedora hasta arriba de la lista. Guardar y salir.
24. Ingresar la contraseña del disco.
25. Desde su computadora (no el servidor) conectarse remotamente con SSH `ssh admin@server`
26. Instalar git: `sudo dnf install -y git`.
27. Descargar este repositorio: `git clone https://github.com/JurgenCruz/HomeServerSetup.git`.
28. Borrar la carpeta de .git: `rm -rf HomeServerSetup/.git`.
29. Mover todo un nivel arriba; `mv HomeServerSetup/* ./`
30. Actualizar el sistema: `dnf up`.
30. Apagar el servidor: `shutdown`.

### 5.2. Configurar Secure Boot

Se configurará Secure Boot con llaves del dueño y se pondrá contraseña al BIOS para impedir su desactivación.

#### 5.2.1. Pasos

1. Prender el servidor y entrar al BIOS (usualmente con la tecla `F2`).
2. Configurar el Secure Boot en modo "Setup", guardar y reiniciar.
3. Después de iniciar sesión con `admin`, ejecutar: `sudo ./scripts/secureboot.sh`.
4. Si no hubo errores, entonces ejecutar `reboot` para reiniciar y entrar al BIOS nuevamente.
5. Salir del modo "Setup" y habilitar Secure Boot.
6. Ponerle contraseña al BIOS, guardar y reiniciar.
7. Después de iniciar sesión con `admin`, ejecutar: `sbctl status`. El mensaje debería decir que está instalado y Secure Boot habilitado.

### 5.3. Instalar y configurar Zsh (Opcional)

Si se desea seguir usando Bash como terminal, se puede omitir esta sección. Zsh es una terminal más poderosa que Bash, pero al final es una decisión personal y no es relevante para la configuración del servidor.

#### 5.3.1. Pasos

1. Ejecutar: `./scripts/zsh_setup.sh`. El script instalará Zsh y la configurará como la terminal por defecto de los usuarios `admin` y `root`.

### 5.4. Configurar usuarios

Aparte del usuario `admin`, es necesario un usuario que llamaremos `mediacenter` para administrar el acceso a los archivos del Media Center y manejar el ecosistema de  aplicaciones AAR. También es necesario un usuario por cada Samba share que se desee hacer. La guía usará 2 Samba shares de ejemplo y por ende, 2 usuarios: `nasj` y `nask`. El usuario `admin` será agregado a los grupos de cada usuario creado de manera que también tenga acceso a los archivos.

#### 5.4.1. Pasos

1. Asumir el rol de `root` ejecutando `sudo -i`.
2. Creamos usuarios `nasj`, `nask` y `mediacenter` y agregamos a `admin` a sus grupos: `printf "nasj\nnask\nmediacenter" | ./scripts/users_setup.sh admin`.

### 5.5. Instalar ZFS

Ya que ZFS es un modulo del kernel, significa que también tiene que pasar la inspección de Secure Boot. Instalaremos ZFS y registraremos en la cadena de inicio de Secure Boot la llave usada para firmarlo. Este registro requiere reiniciar el servidor y navegar un asistente como se explicará más adelante.

#### 5.5.1. Pasos

1. Ejecutar: `./scripts/zfs_setup.sh`. El script le pedirá que ingrese una contraseña. Esta contraseña será usada por única vez en el próximo reinicio para agregar la firma a la cadena de Secure Boot. Puede usar una contraseña temporal o puede reusar la de su usuario si lo desea.
2. Reiniciar con: `reboot`.
3. Le aparecerá una pantalla azul con un menú. Seleccione las siguientes opciones:
    1. "Enroll MOK".
    2. "Continue".
    3. "Yes".
    4. Ingrese la contraseña que definió en el primer paso.
    5. "OK".
    6. "Reboot".

### 5.6. Configurar ZFS

Ahora configuraremos la alberca de ZFS y sus datasets. Si tiene de 3 a 4 discos, se recomienda `raidz`. Si tiene de 5 a 6 discos, se recomienda `raidz2`. Menos de 3 discos no es recomendable ya que la única redundancia posible sería con 2 discos en modo espejo con solo un disco de redundancia y solo 50% de capacidad. Para más de 6 discos es recomendable que mejor haga 2 o más albercas. También se prepararán directorios para la configuración de los contenedores en la partición del SO, o sea, en el SSD. Esto brinda mejor rendimiento en la ejecución de las mismas. La configuración de los contenedores se respaldara a los discos duros una vez al día.

#### 5.6.1. Pasos

1. Después de iniciar sesión, asumir `root` ejecutando `sudo -i`.
2. Dependiendo de si es su primera instalación, una reinstalación o una migración de discos duros, ejecute los pasos correspondientes.
    - A) Primera instalación: se generará una llave de encriptación y creará una nueva alberca de discos.
      1. Ejecutar: `./scripts/generate_zfs_key.sh`. Se generará una llave hexadecimal en `/keys/Tank.dat`. Es recomendable que respalde esta llave en un lugar seguro ya que si el SSD falla y se pierde la llave, los datos en la alberca se perderán para siempre.
      2. Ejecutar: `./scripts/create_zfs_pool.sh raidz2 /dev/disk/by-id/disk1 /dev/disk/by-id/disk2 /dev/disk/by-id/disk3 /dev/disk/by-id/disk4 /dev/disk/by-id/disk5 /dev/disk/by-id/disk6`. Adecúe los parámetros para escoger el tipo de `raidz` adecuado. Es recomendable usar los nombres de los discos por id, por uuid o por label. **No use el nombre de disco** (por ejemplo /dev/sda) ya que estos pueden cambiar después de un reinicio y la alberca no funcionará.
      3. Ejecutar: `printf "nasj\nnask" | ./scripts/create_zfs_datasets.sh`. Se crearan datasets con el nombre del usuario en mayúsculas, por ejemplo `Tank/NASJ`. Ademas creará un dataset `Tank/Apps` para respaldar la configuración de los contenedores y un dataset `Tank/MediaCenter` para guardar los archivos de media. Los datasets que serán usados como Samba shares serán configurados para que SELinux permita el acceso a ellos por Samba.
      4. Ejecutar: `./scripts/create_app_folders.sh` para generar los directorios de los contenedores en el SSD.
    - B) Reinstalación del SO: se restaurará la llave de encriptación y se importará la alberca existente.
      1. Crear el directorio de llaves: `mkdir /keys`. Se asume que esta dirección es la misma usada antes de reinstalar el SO y que la alberca buscará la llave en el mismo directorio. Ajuste la dirección de no ser así.
      2. Copiar la llave desde otra computadora: `scp user@host:/path/to/keyfile /keys/Tank.dat`. Cambiar `{user@host:/path/to/keyfile}` por la dirección de la llave en la computadora que contenga el respaldo. Si lo prefiere también puede usar una memoria USB para transferir el respaldo de la llave.
      3. Importar las albercas existente: `zpool import -d /dev/disk/by-id -a`. Si la alberca no fue exportada antes, pruebe usar `-f` para forzar la importación.
      4. Montar todos los datasets y cargar la llave de ser necesario: `zfs mount -al`.
      5. Restaurar las carpetas de los contenedores de los discos duros al SSD: `rsync -avz /mnt/Tank/Apps/ /Apps/`.
    - C) Migrar a nuevos discos duros: Se asume que la nueva alberca usará la misma llave que la anterior y que ya está en su lugar.
      1. Ejecutar: `./scripts/migrate_pool.sh Tank raidz2 /dev/disk/by-id/disk1 /dev/disk/by-id/disk2 /dev/disk/by-id/disk3 /dev/disk/by-id/disk4 /dev/disk/by-id/disk5 /dev/disk/by-id/disk6`. `Tank` es el nombre de la alberca actual. Es el mismo nombre usado por el script que crea la alberca inicialmente. Los demás parámetros son los mismos que para `create_zfs_pool.sh`. Ver información en la opción A).
      2. Montar todos los datasets y cargar la llave de ser necesario: `zfs mount -al`.
3. Ejecutar: `./scripts/generate_dataset_mount_units.sh`. Esto generara unidades de Systemd que montaran los datasets de `Tank` automáticamente después de cargar la llave al reiniciar el servidor. Ejecute este comando `cat /etc/zfs/zfs-list.cache/Tank` para verificar que el archivo de cache no esté vacío. Si está vacío, intente ejecutar el script de nuevo ya que significa que no se generó el cache ni las unidades.

> Si realizó una migración o reinstalación, habrá ciertos pasos en la guía que podrá omitir. Por ejemplo si ya existían ciertos directorios o archivos. Se deja a discreción del lector ver cuales pasos ya no son necesarios.

### 5.7. Configurar red del anfitrión

Para evitar que las configuraciones de las conexiones se rompan en el futuro, es útil asignar al servidor un IP estático en la red local. Configuraremos el servidor para no usar DHCP y asignarse un IP en la red. Además crearemos una red macvlan auxiliar para poder comunicarnos con Home Assistant que estará en una macvlan de Docker. La guía asumirá una red local con rango CIDR 192.168.1.0/24, con el router en la penúltima dirección (192.168.1.254) y el servidor en la antepenúltima (192.168.1.253). Si necesita usar otro rango, solo reemplazar por el rango correcto en el resto de la guía.

#### 5.7.1. Pasos

1. Ver el nombre del dispositivo de red físico activo, por ejemplo `enp1s0` o `eth0`: `nmcli device status`. Si existe más de un dispositivo físico, seleccionar el que esté conectado al router con mejor velocidad. Reemplazar en los comandos siguientes `enp1s0` por el dispositivo correcto.
2. Asignar IP estático y rango CIDR: `nmcli con mod enp1s0 ipv4.addresses 192.168.1.253/24`. Normalmente los routers de hogar usan un rango CIDR de `/24` o su equivalente mascara de subred `255.255.255.0`. Revise el manual de su router para más información.
3. Deshabilitar cliente DHCP: `nmcli con mod enp1s0 ipv4.method manual`.
4. Configurar el IP del router: `nmcli con mod enp1s0 ipv4.gateway 192.168.1.254`. Normalmente el router se asigna un IP estático que es el penúltimo IP del rango de IPs.
5. Configurar Cloudflare como DNS: `nmcli con mod enp1s0 ipv4.dns 1.1.1.1`. Si gusta usar otro DNS como el de Google, puede cambiarlo.
6. Reactivar el dispositivo para que surtan efecto los cambios: `nmcli con up enp1s0`. Esto puede terminar la sesión SSH. de ser así, vuelva a hacer `ssh` al servidor.
7. Ejecutar: `./scripts/disable_resolved.sh`. Desactivamos el servicio de DNS local "systemd-resolved" para desocupar el puerto DNS que necesita Pi-hole y configuramos Cloudflare como DNS. Si gusta puede modificar el script para usar otro DNS como Google.
8. Agregar conexión macvlan auxiliar: `nmcli con add con-name macvlan-shim type macvlan ifname macvlan-shim ip4 192.168.1.12/32 dev enp1s0 mode bridge`. `192.168.1.12` es el IP del servidor dentro de está red auxiliar. Si su red local esta en otro prefijo, ajuste este IP a uno dentro de su prefijo pero fuera del rango de asignación del DHCP para evitar colisiones.
9. Agregar ruta a conexión auxiliar para la red macvlan: `nmcli con mod macvlan-shim +ipv4.routes "192.168.1.0/27"`. `192.168.1.0/27` es el rango de IPs de la red macvlan que coincide con el prefijo de la red local y a su vez está fuera del rango de asignación del DHCP.
10. Activar la conexión auxiliar: `nmcli con up macvlan-shim`.

### 5.8. Configurar shares

Se instalará Samba, se configurarán los shares de Samba, se crearán las contraseñas para los usuarios que son separadas de las de Linux (si gusta puede usar las mismas contraseñas que las de Linux) y se configurará el cortafuegos para permitir el servicio de Samba a la red local.

#### 5.8.1. Pasos

1. Ejecutar: `./scripts/smb_setup.sh`. Instala servicio Samba.
2. Ejecutar: `./scripts/set_samba_passwords.sh`. Ingresar el nombre de usuario y establecer una contraseña para el mismo. En esta guía se asume que se establecerán contraseñas para 3 usuarios: `mediacenter`, `nasj` y `nask`.
3. Copiar la configuración del servidor Samba preconfigurada con 3 shares para los usuarios del paso anterior: `cp ./files/smb.conf /etc/samba`.
4. Editar el archivo: `nano /etc/samba/smb.conf`. Puede cambiar los nombres de los shares (e.g. \[NASJ\]), y las propiedades `path` y `valid users`. La guía asume que la red local esta en el rango 192.168.1.0/24. Si su red es diferente, entonces también cambie la propiedad `allow hosts` para que tenga el rango correcto de su red local. Guardar y salir con `Ctrl + X, Y, Enter`.
5. Ejecutar: `./scripts/smb_firewalld_services.sh`. Configura Firewalld abriendo los puertos para Samba y después habilita el servicio de Samba.

### 5.9. Registrar DDNS

Si usted no piensa acceder a su servidor fuera de su red local, o si cuenta con un IP público estático y su propio dominio, puede omitir esta sección.

Esta guía usará el servicio de DuckDNS.org como DDNS para poder mapear un subdominio a nuestro servidor. Registraremos un subdominio en DuckDNS.org y configuraremos nuestro servidor para actualizar el IP en DuckDNS.org.

#### 5.9.1. Pasos

1. Registrar un subdominio en DuckDNS.org.
    1. Acceder y crear una cuenta en https://www.duckdns.org/.
    2. Registrar un subdominio de su preferencia. Anotar el token generado porque lo vamos a necesitar a continuación.
2. Copiar el script que actualiza el DDNS con nuestro IP público a `sbin`: `cp ./scripts/duck.sh /usr/local/sbin/`.
3. Editar el script: `nano /usr/local/sbin/duch.sh`. Reemplazar `XXX` con el subdominio que registramos y `YYY` con el token que nos generó durante el registro. Guardar y salir con `Ctrl + X, Y, Enter`.
4. Cambiamos los permisos del script para que solo `root` pueda acceder a el: `chmod 700 /usr/local/sbin/duck.sh`. El script contiene nuestro token que es lo único que permite que solo nosotros podamos cambiar el IP al que apunta el subdominio, de ahí la importancia de asegurarlo.

### 5.10. Instalar Docker

Instalaremos Docker como nuestro motor de contenedores; opcionalmente instalaremos los controladores de Nvidia y "Nvidia Container Toolkit"; y configuraremos SELinux para asegurar Docker.

#### 5.10.1. Pasos

1. Ejecutar: `./scripts/docker_setup.sh admin`. Agrega el repositorio de Docker, lo instala, habilita el servicio y agrega al usuario `admin` al grupo `docker`.
2. Copiar las pólizas de SELinux: `cp ./files/{arr.cil,qbittorrent.cil,wireguard.cil} /root`. Estas son necesarias para algunos contenedores para poder acceder a archivos de Samba y interactuar con WireGuard.
3. Ejecutar: `./scripts/selinux_setup.sh`. Habilita SELinux en Docker, reinicia el servicio de Docker para que surtan efecto los cambios y activa la bandera que permite a los contenedores manejar la red.
4. Opcional: Si tiene una tarjeta Nvidia relativamente moderna, ejecutar: `./scripts/nvidia_setup.sh`. Agrega repositorios de "RPM Fusion" y Nvidia para instalar el controlador y el "Nvidia Container Toolkit" para Docker. También registra la llave de "Akmods" en la cadena de Secure Boot. Es necesario reiniciar y repetir el proceso de enrolar la llave como lo hicimos con ZFS. Después de reiniciar y iniciar sesión, no se olvide de asumir `root` con `sudo -i`.

### 5.11. Preparar configuración de Pi-hole

Crearemos un secreto de Docker para establecer la contraseña de Pi-hole y opcionalmente configuraremos Pi-hole como DHCP para poder autoasignarse como DNS y hacer "split horizon" DNS.

#### 5.11.1. Pasos

1. Crear archivo de credenciales para Pi-hole. Este archivo establece la contraseña para Pi-hole, por lo que debe ser solo accesible a `root`.
    1. Crear archivo de contraseña: `nano /Apps/pihole_pwd.txt`.
    2. Escribir una contraseña aleatoria y segura. Se recomienda usar el administrador de contraseñas Bitwarden para generar y guardar la contraseña de manera segura. Guardar y salir con `Ctrl + X, Y, Enter`.
    3. Establecer los permisos para que solo `root` lo pueda acceder: `chmod 700 /Apps/pihole_pwd.txt`.
    4. Cambiar manualmente la etiqueta de SELinux del archivo: `semanage fcontext -a -t container_file_t '/Apps/pihole_pwd.txt'`. Existe un defecto en docker-compose que no permite usar secretos con SELinux ya que no cambia automáticamente la etiqueta antes de montar el secreto.
    5. Refrescamos la etiqueta para que surta efecto el cambio: `restorecon -v /Apps/pihole_pwd.txt`.
2. Configurar Pi-hole como servidor DHCP para poder autoasignarse como DNS. Si su router tiene la opción de cambiar el DNS asignado por el DHCP o si no piensa exponer su servidor al internet, siga la ruta B)
    A) Usar Pi-hole como DHCP:
        1. Editar el archivo del stack: `nano ./files/docker-compose.yml`.
        2. Ajustar las variables `DHCP_START` y `DHCP_END` con el rango de IPs de su red local. Asegurarse de dejar algunos IPs no asignables al principio de la red. Por ejemplo si el rango de su red local es 192.168.1.0/24, empiece en 192.168.1.64.
        3. Ajustar la variable `DHCP_ROUTER` con el IP de su router.
        4. Ajustar el atributo `ipv4_address` en el contenedor `pihole` con un IP en el rango no asignable por el DHCP. Por ejemplo 192.168.1.11.
    B) No usar Pi-hole como DHCP:
        1. Editar el archivo del stack: `nano ./files/docker-compose.yml`.
        2. Borrar las variables `DHCP_ACTIVE`, `DHCP_START`, `DHCP_END`, `DHCP_ROUTER`, `DHCP_LEASETIME`, `PIHOLE_DOMAIN`, `DHCP_IPv6` y `DHCP_rapid_commit` del contenedor `pihole`.
3. Opcional: Si no quiere usar Cloudflare como DNS, Ajustar `PIHOLE_DNS_` con el DNS de su elección como Google. Guardar y salir con `Ctrl + X, Y, Enter`.
4. Si va a exponer su servidor al internet, configurar "split horizon DNS": `echo "address=/micasa.duckdns.org/192.168.1.253" > /Apps/pihole/etc-dnsmasq.d/03-my-wildcard-dns.conf`.

### 5.12. Crear stack de Docker

Prepararemos el archivo de configuración de la VPN anónima que requiere qBittorrent; configuraremos el stack; configuraremos el cortafuegos para permitir los puertos necesarios; y levantaremos el stack a través de Portainer. El stack consiste de los siguientes contenedores:

- qBittorrent: Administrador de descargas a través del protocolo bittorrent.
- Sonarr: Administrador de series.
- Radarr: Administrador de películas.
- Prowlarr: Administrador de motores de búsqueda.
- Bazarr: Administrador de subtítulos.
- Flaresolverr: Solucionador de CAPTCHAs.
- Jellyfin: Servicio de medios.
- Jellyseerr: Administrador de peticiones de medios y servicio de catálogo.
- Pi-hole: Servidor DNS y DHCP.
- Nginx Proxy Manager: Motor y administrador de Reverse Proxy.
- Home Assistant: Motor de automatización del hogar.
- WireGuard: VPN para la red local.

#### 5.12.1. Pasos

1. Copiar el archivo de configuración de la VPN anónima para bittorrent: `scp user@host:/path/to/vpn.conf /Apps/qbittorrent/wireguard/tun0.conf`. Cambiar `{user@host:/path/to/vpn.conf}` por la dirección del archivo en la computadora que contenga el archivo. Este archivo debe ser proporcionado por su proveedor de VPN si selecciona WireGuard como protocolo. También puede usar una memoria USB para transferir el archivo de configuración. Si su proveedor requiere usar OpenVPN tendrá que cambiar la configuración del contenedor. Para más información lea la guía del contenedor: https://github.com/Trigus42/alpine-qbittorrentvpn.
2. Si se va a usar una VPN local, ejecutar: `./scripts/iptable_setup.sh`. Agrega un módulo de kernel al inicio del sistema necesario para WireGuard.
3. Editar el archivo del stack: `nano ./files/docker-compose.yml`.
4. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
5. Reemplazar las XXX con el `uid` y `gid` del usuario `mediacenter`. Se puede usar `id mediacenter` para obtener el `uid` y `gid`.
6. Si no se va a usar GPU, borrar las secciones de `runtime` y `deploy` del contenedor `jellyfin`.
7. Si se va a usar OpenVPN para bittorrent, actualizar el contenedor `qbittorrent` de acuerdo a la guía oficial.
8. Si no se va a usar una VPN local, quitar el contenedor de `wireguard`, de lo contrario, reemplazar `micasa` por el subdominio que registró en DuckDNS.org y ajustar la variable `ALLOWEDIPS` en caso de que `192.168.1.0/24` no sea el rango CIDR de su red local. No remover `10.13.13.0` ya que es la red interna de WireGuard y perderá conectividad si la remueve. La guía asume 2 clientes que se conectaran a la VPN con los IDs: `phone` y `laptop`. Si usted requiere más o menos clientes, agregar o remover o renombrar los IDs de los clientes que desee.
9. Si no se va a exponer el servidor al internet, quitar el contenedor de `nginx`.
10. Ajustar la red `lanvlan`.
    1. Ajustar atributo `parent` con el dispositivo que usó para crear la red macvlan auxiliar anteriormente. Por ejemplo `enp1s0`.
    2. Ajustar atributo `subnet` con el rango de su red local.
    3. Ajustar atributo `gateway` con el IP de su router.
    4. Ajustar atributo `ip_range` con el rango de su red local que el DHCP no asigna. La guía configuró Pi-hole para no asignar las primeras 64 direcciones, por eso usamos un rango 192.168.1.0/27. Si usted configuró su DHCP con otro rango no asignable, use ese aquí.
    5. Ajustar atributo `host` con el IP del servidor en la red macvlan auxiliar.
11. Ajustar el atributo `ipv4_address` en el contenedor `homeassistant` con un IP en el rango no asignable por el DHCP. Por ejemplo 192.168.1.10.
11. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
12. Ejecutar: `./scripts/container_firewalld_services.sh`. Configura Firewalld para los contenedores. El script abre los puertos para DHCP y DNS para Pi-hole; los puertos para HTTP y HTTPS para Nginx y el puerto para WireGuard. Si no va a usar alguno de estos servicios, editar el script y remueva las reglas no necesarias.
13. Ejecutar: `./scripts/run_portainer.sh`. Esto ejecuta un contenedor de Portainer Community Edition y escuchará en el puerto `9443`.
14. Configurar Portainer desde el navegador.
    1. Acceder a Portainer a través de https://192.168.1.253:9443. Si sale una alerta de seguridad, puede aceptar el riesgo ya que Portainer usa un certificado de SSL autofirmado.
    2. Establecer una contraseña aleatoria y crear usuario `admin`. Se recomienda Bitwarden nuevamente para esto.
    3. Darle clic en "Get Started" y luego seleccionar "local".
    4. Seleccionar "Stacks" y crear un nuevo stack.
    5. Ponerle nombre "apps" y pegar el contenido del docker-compose.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Portainer y no en el archivo.
    6. Navegar a "Environments" > "local" y cambiar "Public IP" con el IP estático del servidor `192.168.1.253`.

### 5.13. Configurar aplicaciones

Los contenedores deben estar ejecutándose ahora, sin embargo, requieren cierta configuración para trabajar entre ellos.

#### 5.13.1. Configurar qBittorrent

1. Acceder a qBittorrent a través de http://192.168.1.253:10095.
2. Usar `admin` y `adminadmin` como usuario y contraseña.
3. Hacer clic en el botón `Options`.
4. Configurar pestaña `Downloads`. Hacer los siguientes cambios:
    1. "Default Torrent Management Mode" : "Automatic".
    2. "Default Save Path": "/MediaCenter/torrents".
    3. Opcional: Si quiere guardar los archivos `.torrent` por si necesita descargar de nuevo algo puede habilitar "Copy .torrent files for finished downloads to" y asignar: "/MediaCenter/torrents/backup".
5. Configurar pestaña `Connection`. Hacer los siguientes cambios:
    1. Deshabilitar "Use UPnP / NAT-PMP port forwarding from my router".
    2. Si gusta puede ajustar los límites de conexiones.
6. Configurar pestaña `Speed`. Hacer los siguientes cambios:
    1. En la sección de "Alternative Rate Limits" > "Upload": Poner un tercio de la velocidad de subida de su proveedor.
    2. En la sección de "Alternative Rate Limits" > "Download": Poner un tercio de la velocidad de bajada de su proveedor.
    3. Habilitar "Schedule the use of alternative rate limits".
    4. Escoger el horario en el cual se usa el Internet en el hogar para otras cosas. Por ejemplo: 08:00 - 01:00 todos los días.
7. Configurar pestaña `BitTorrent`. Hacer los siguientes cambios:
    1. Deshabilitar `Enable Local Peer Discovery to find more peers` ya que no hay nada local en el contenedor.
    2. Si gusta dejar de ser semilla después de una meta, puede habilitar y ajustar los límites aquí. Por ejemplo "Cuando la taza llegue a 1".
8. Configurar pestaña `Web UI`. Hacer los siguientes cambios:
    1. Cambiar la contraseña por una más seguro. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
    2. Habilitar "Bypass authentication for clients on localhost".
    3. Habilitar "Bypass authentication for clients in whitelisted IP subnets".
    4. Agregar `172.21.0.0/24` a la lista debajo. Esto permitirá a los contenedores en la red `arr` de Docker acceder sin contraseña.
9. Configurar pestaña `Advanced`. Hacer los siguientes cambios:
    1. Asegurar que el "Network Interface" sea `tun0`. Si no quiere decir que no está usando su VPN y el tráfico no será anónimo.
    2. Habilitar "Reannounce to all trackers when IP or port changed".
    3. Habilitar "Always announce to all trackers in a tier".
    4. Habilitar "Always announce to all tiers".
10. Guardar.

#### 5.13.2. Configurar Radarr

1. Acceder a Radarr a través de http://192.168.1.253:7878.
2. Configurar contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo. Dejar el método de autenticación como `Forms` y no deshabilitar la autenticación.
3. Navegar a "Settings" > "Media Management" y configurar.
    1. "Standard Movie Format": `{Movie CleanTitle} {(Release Year)} [imdbid-{ImdbId}] - {Edition Tags }{[Custom Formats]}{[Quality Full]}{[MediaInfo 3D]}{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels}]{MediaInfo AudioLanguages}[{MediaInfo VideoBitDepth}bit][{Mediainfo VideoCodec}]{-Release Group}`.
    2. Hacer clic en "Add Root Folder" y seleccionar "/MediaCenter/media/movies".
4. Navegar a "Settings" > "Download Clients" y configurar.
    1. Agregar nuevo cliente.
    2. Seleccionar "qBittorrent".
    3. "Name": "qBittorrent".
    4. "Host": "qbittorrent".
    5. "Port": "8080".
    6. "Category": "movies".
    7. Hacer clic en "Test" y luego "Save".
5. Navegar a "Settings" > "General".
6. Copiar el "API Key" a un bloc de notas ya que lo necesitaremos más tarde.
7. Para configurar las pestañas de "Profiles", "Quality" y "Custom Formats" se recomienda el uso de la siguiente guía: https://trash-guides.info/Radarr/

#### 5.13.3. Configurar Sonarr

1. Acceder a Sonarr a través de http://192.168.1.253:8989.
2. Configurar contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo. Dejar el método de autenticación como `Forms` y no deshabilitar la autenticación.
3. Navegar a "Settings" > "Media Management" y configurar.
    1. "Standard Episode Format": `{Series TitleYear} - S{season:00}E{episode:00} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}`.
    2. "Daily Episode Format": `{Series TitleYear} - {Air-Date} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}`.
    3. "Anime Episode Format": `{Series TitleYear} - S{season:00}E{episode:00} - {absolute:000} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}[{MediaInfo VideoBitDepth}bit]{[MediaInfo VideoCodec]}[{Mediainfo AudioCodec} { Mediainfo AudioChannels}]{MediaInfo AudioLanguages}{-Release Group}`.
    4. "Season Folder Format": "Season {season:00}".
    5. Hacer clic en "Add Root Folder" y seleccionar "/MediaCenter/media/tv".
4. Navegar a "Settings" > "Download Clientes" y configurar.
    1. Agregar nuevo cliente.
    2. Seleccionar "qBittorrent".
    3. "Name": "qBittorrent".
    4. "Host": "qbittorrent".
    5. "Port": "8080".
    6. "Category": "tv".
    7. Hacer clic en "Test" y luego "Save".
5. Navegar a "Settings" > "General".
6. Copiar el "API Key" a un bloc de notas ya que lo necesitaremos más tarde.
7. Para configurar las pestañas de "Profiles", "Quality" y "Custom Formats" se recomienda el uso de la siguiente guía: https://trash-guides.info/Sonarr/

#### 5.13.4. Configurar Prowlarr

1. Acceder a Prowlarr a través de http://192.168.1.253:8989.
2. Configurar contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo. Dejar el método de autenticación como `Forms` y no deshabilitar la autenticación.
3. Navegar a "Settings" > "Indexers" y configurar.
    1. Agregar nuevo proxy.
    2. Seleccionar "FlareSolverr".
    3. "Name": "FlareSolverr".
    4. "Tags": "proxy".
    5. "Host": "http://flaresolverr:8191/".
    6. Hacer clic en "Test" y luego "Save".
4. Navegar a "Settings" > "Apps" y configurar.
    1. Agregar nueva aplicación.
    2. Seleccionar "Radarr"
    3. "Name": "Radarr".
    4. "Sync Level": "Full Sync".
    5. "Tags": "radarr".
    6. "Prowlarr Server": "http://prowlarr:9696".
    7. "Radarr Server": "http://radarr:7878".
    8. "API Key": pegar el API Key de Radarr que copiamos antes.
    9. Hacer clic en "Test" y luego "Save".
    10. Agregar nueva aplicación.
    11. Seleccionar "Sonarr"
    12. "Name": "Sonarr".
    13. "Sync Level": "Full Sync".
    14. "Tags": "sonarr".
    15. "Prowlarr Server": "http://prowlarr:9696".
    16. "Sonarr Server": "http://sonarr:8989".
    17. "API Key": pegar el API Key de Sonarr que copiamos antes.
    18. Hacer clic en "Test" y luego "Save".
5. Navegar a "Settings" > "Download Clients" y configurar.
    1. Agregar nuevo cliente.
    2. Seleccionar "qBittorrent".
    3. "Name": "qBittorrent".
    4. "Host": "qbittorrent".
    5. "Port": "8080".
    6. "Default Category": "manual".
    7. Hacer clic en "Test" y luego "Save".
6. Navegar a "Indexers" y configurar.
    1. Agregar indexer.
    2. Escoger el indexer de su preferencia.
    3. Configurar el indexer a su preferencia.
    4. "Tags": Agregar "sonarr" si quiere usar este indexer con Sonarr. Agregar "radarr" si quiere usar este indexer con Radarr. Agregar "proxy" si este indexer necesita de FlareSolverr.
    5. Hacer clic en "Test" y luego "Save".
    6. Repetir los pasos para cualquier otro indexer que desee. Prowlarr empujará los detalles de los indexers a Radarr y Sonarr.

#### 5.13.5. Configurar Bazarr

1. Acceder a Bazarr a través de http://192.168.1.253:6767.
2. Configurar contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo. Dejar el método de autenticación como `Forms` y no deshabilitar la autenticación.
3. Navegar a "Settings" > "Languages" y configurar.
    1. "Languages Filter": Seleccionar los idiomas que le interese descargar. Es buena idea tener un idioma de respaldo en caso de que no existan para el de su preferencia.
    2. Hacer clic en "Add New Profile".
    3. "Name": El nombre del idioma principal.
    4. Agregar idioma principal e idiomas de respaldo en el orden de su preferencia.
    5. "Cutoff": Seleccionar el idioma principal.
    6. Guardar.
    7. Si desea otros idiomas, puede repetir agregar otro perfil.
    8. Seleccionar el idioma por defecto para series y películas.
    9. Guardar.
4. Navegar a "Settings" > "Providers" y configurar.
    1. Agregar los proveedores de subtítulos de su preferencia.
5. Navegar a "Settings" > "Sonarr" y configurar.
    1. Habilitar Sonarr.
    2. "Host" > "Address": "sonarr".
    3. "Host" > "Port": "8989".
    4. "Host" > "API Key": Pegar el API Key de Sonarr que copiamos antes.
    5. Hacer clic en "Test" y luego "Save".
6. Navegar a "Settings" > "Radarr" y configurar.
    1. Habilitar Radarr.
    2. "Host" > "Address": "radarr".
    3. "Host" > "Port": "7878".
    4. "Host" > "API Key": Pegar el API Key de Radarr que copiamos antes.
    5. Hacer clic en "Test" y luego "Save".
7. Para configurar otras pestañas se recomienda el uso de la siguiente guía: https://trash-guides.info/Bazarr/

#### 5.13.6. Configurar Jellyfin

1. Acceder a Jellyfin a través de http://192.168.1.253:8096.
2. Seguir el asistente para crear un nuevo usuario y contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
3. Abrir panel lateral y navegar a "Administration" > "Dashboard".
4. Si tiene GPU, navegar a "Playback" y configurar.
    1. Seleccionar su GPU. La guía asumirá "NVidia NVENC".
    2. Habilitar los codecs que su modelo de GPU soporte.
    3. Habilitar "Enable enhanced NVDEC decoder".
    4. Habilitar "Enable hardware encoding".
    5. Habilitar "Allow encoding in HEVC format".
    6. Si gusta puede configurar otros parámetros a su gusto.
    7. Guardar.
5. Navegar a "Networking" y configurar:
    1. "Known proxies": "nginx".
    2. Guardar.
6. Navegar a "Plugins" > "Catalog" y configurar.
    1. Si va a haber Anime en su colección, instalar "AniDB" y "AniList".
    2. Instalar "TMBd Box Sets", "TVmaze" y "TheTVDB".
7. Para que los plugins surtan efecto reiniciar Jellyfin desde Portainer.
8. Navegar a "Libraries" y configurar.
    1. Agregar librería.
    2. "Content Type": "Movies".
    3. "Name": "Movies".
    4. "Folders": Agregar "/MediaCenter/media/movies".
    5. Ordenar "Metadata downloaders": "TheMovieDb", "AniDB", "AniList", "The Open Movie Database".
    6. Ordenar "Image fetchers": "TheMovieDb", "The Open Movie Database", "AniDB", "AniList", "Embedded Image Extractor", "Screen Grabber".
    7. Configurar las demás opciones a su gusto y Guardar.
    8. Agregar librería.
    9. "Content Type": "Shows".
    10. "Name": "Shows".
    11. "Folders": Agregar "/MediaCenter/media/tv".
    12. Ordenar "Metadata downloaders (TV Shows)": "TheTVDB", "TVmaze", "TheMovieDb", "AniDB", "AniList", "The Open Movie Database".
    13. Ordenar "Metadata downloaders (Seasons)": "TVmaze", "TheMovieDb", "AniDB".
    14. Ordenar "Metadata downloaders (Episodes)": "TheTVDB", "TVmaze", "TheMovieDb", "AniDB", "The Open Movie Database".
    15. Ordenar "Image fetchers (TV Shows)": "TheTVDB", "TVmaze", "TheMovieDb", "AniList", "AniDB".
    16. Ordenar "Image fetchers (Seasons)": "TheTVDB", "TVmaze", "TheMovieDb", "AniDB", "AniList".
    17. Ordenar "Image fetchers (Episodes)": "TheTVDB", "TVmaze", "TheMovieDb", "The Open Movie Database", "Embedded Image Extractor", "Screen Grabber".
    18. Configurar las demás opciones a su gusto y Guardar.
9. Navegar a "Users" y configurar.
    1. Si más personas van a usar Jellyfin, Crear más usuarios y configurarlos como guste.
10. Navegar a su perfil (Icono de usuario arriba a la derecha) > "Subtitles".
    1. "Preferred subtitle language": Su idioma principal. Guardar.
    2. Puede configurar el resto de su perfil si lo desea.

#### 5.13.7. Configurar Jellyseerr

1. Acceder a Jellyseerr a través de http://192.168.1.253:5055.
2. Ingresar con Jellyfin.
    1. Hacer clic en "Use Jellyfin Account".
    2. "Jellyfin URL": "http://192.168.1.253:8096"
    3. Ingresar con su nombre de usuario y contraseña.
3. Configurar librerías.
    1. Hacer clic en "Sync Libraries".
    2. Habilitar "Movies", "Shows" y "Collections".
    3. Hacer clic en "Start Scan".
    4. Hacer clic en "Continue".
4. Configurar Sonarr y Radarr.
    1. Hacer clic en "Add Radarr Server".
    2. Habilitar "Default Server".
    3. "Server Name": "Movies".
    4. "Hostname or IP Address": "radarr".
    5. "Port": "7878".
    6. "API Key": Pegar el API Key de Radarr que copiamos antes.
    7. Hacer clic en "Test".
    8. "Quality Profile": escoger el perfil de calidad por defecto que quiera usar.
    9. "Root Folder": "/MediaCenter/media/movies".
    10. "Minimum Availability": "Announced".
    11. Habilitar "Enable Scan".
    12. Guardar.
    13. Hacer clic en "Add Sonarr Server".
    14. Habilitar "Default Server".
    15. "Server Name": "Series".
    16. "Hostname or IP Address": "sonarr".
    17. "Port": "8989".
    18. "API Key": Pegar el API Key de Sonarr que copiamos antes.
    19. Hacer clic en "Test".
    20. "Quality Profile": escoger el perfil de calidad por defecto que quiera usar.
    21. "Root Folder": "/MediaCenter/media/tv".
    22. "Anime Quality Profile": escoger el perfil de calidad por defecto que quiera usar para Anime. Dejar en blanco si no va a tener anime en su colección.
    23. "Anime Root Folder": "/MediaCenter/media/tv".
    24. Habilitar "Season Folders".
    25. Habilitar "Enable Scan".
    26. Guardar.
5. Importar usuarios.
    1. Navegar a "Users".
    2. Hacer clic en "Import Jellyfin Users".
    3. Puede configurar los usuarios haciendo clic en "Edit" en la fila del usuario que desee configurar.
6. Si desea configurar más opciones, Navegar a "Settings" y hacer los cambios deseados.

#### 5.13.8. Configurar Pi-hole

1. Acceder a Pi-hole a través de http://192.168.1.11/admin.
2. Ingresar la contraseña de Pi-hole que estableció en el archivo secreto.
3. Navegar a "Adlists" y configurar.
    1. Agregar direcciones de listas de bloqueo. Algunas recomendaciones de paginas donde conseguir listas: https://easylist.to/ y https://firebog.net/.
4. Si alguna pagina está siendo bloqueada y no desea bloquearla, Navegar a "Domains" y agregar dominio o expresión regular a la lista de inclusión.

#### 5.13.9. Configurar Home Assistant

1. Acceder a Home Assistant a través de http://192.168.1.10:8123.
2. Usar el asistente para crear una cuenta de usuario y contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
3. Configurar con el asistente nombre de la instancia de Home Assistant y sus datos y preferencias.
4. Escoja si quiere mandar datos de uso a la pagina de Home Assistant.
5. Finalizar el asistente.
6. Configurar Webhook para notificaciones.
    1. Navegar a "Settings" > "Automations & Scenes".
    2. Hacer clic en "Create Automation".
    3. Hacer clic en "Create new Automation".
    4. Hacer clic en "Add Trigger".
    5. Buscar "Webhook" y seleccionar.
    6. Nombrar el trigger "A Problem is reported".
    7. Cambiar el id del webhook a "notify".
    8. Hacer clic en el engrane de configuración y habilitar unicamente "POST" y "Only accessible from the local network".
    9. Hacer clic en "Add Action".
    10. Buscar "send persistent notification" y seleccionar.
    11. Hacer clic en el Menú de la acción y seleccionar "Edit in YAML" y agregar lo siguiente:
        ```yaml
        alias: Notify Web
        service: notify.persistent_notification
        metadata: {}
        data:
            title: Issue found in server!
            message: "Issue in server: {{trigger.json.problem}}"
        ```
    12. Si desea recibir notificaciones en su celular, primero deberá descargar la aplicación a su celular e iniciar sesión en Home Assistant desde él. Después configurar lo siguiente:
    13. Hacer clic en "Add Action".
    14. Buscar "mobile" y seleccionar "Send notification via mobile_app".
    15. Hacer clic en el Menú de la acción y seleccionar "Edit in YAML" y agregar lo siguiente:
        ```yaml
        alias: Notify Mobile
        service: notify.mobile_app_{mobile_name}
        metadata: {}
        data:
            title: Issue found in server!
            message: "Issue in server: {{trigger.json.problem}}"
        ```
    16. Guardar.

### 5.14. Configurar tareas cron

Automatizaremos las tareas siguientes: creación y purga automática de snapshots de ZFS; limpieza de albercas de ZFS; respaldo de la configuración de los contenedores; actualización de las imágenes de los contenedores a la última versión; pruebas cortas y largas de discos duros con SMART; y actualización de IP público en DDNS. Si nota que algún script no tiene la bandera de ejecutable, convertirlo en ejecutable con el comando `chmod 775 <file>` reemplazando `<file>` por el nombre del script.

#### 5.14.1. Pasos

1. Copiar script para manejo de snapshots de ZFS: `cp ./scripts/snapshot-with-purge.sh /usr/local/sbin/`. Este script crea snapshots recursivos de todos los datasets de una alberca con la misma estampa de tiempo. Después purga los snapshots viejos según la póliza de retención. Note que la póliza de retención no es por tiempo sino por numero de snapshots creados por el script (los snapshots creados manuales con esquema de nombres diferente serán ignorados).
2. Copiar script de notificaciones usando Home Assistant para reportar problemas: `cp ./scripts/notify.sh /usr/local/sbin/`. Si usó un IP diferente para Home Assistant en la macvlan, ajuste el script con `nano /usr/local/sbin/notify.sh` con el IP correcto.
3. Si no va a usar DDNS, editar el archivo cron: `nano ./files/cron`. Remover la última linea referente a DDNS. Guardar y salir con `Ctrl + X, Y, Enter`.
3. Cargar las tareas cron al crontab: `crontab < ./files/cron`. Creamos tareas cron para limpieza de albercas de ZFS mensualmente el día 15 a la 01:00; creación y purga de snapshots de ZFS diario a las 00:00; respaldo de configuración de los contenedores diario a las 23:00; actualización de las imágenes de Docker diario a las 23:30; y actualización del IP al DDNS cada 5 minutos. Si cualquier tarea falla, se notificará al usuario a través del webhook de Home Assistant.
4. Copiar script de notificaciones para smartd: `cp ./scripts/smart_error_notify.sh /usr/local/sbin/`. Con este script podemos hacer proxy a los correos de smartd y también llamar a nuestro sistema de notificaciones.
5. Copiar configuración de los SMART tests: `cp ./files/smartd.conf /etc/`. Configuramos prueba SHORT semanalmente los domingos a las 00:00 y prueba LONG 1 vez cada dos meses, el primero del mes a la 01:00; y usamos nuestro script de notificaciones.
6. Copiar script de notificaciones para servicio ZFS-ZED: `cp ./scripts/process_email.sh /usr/local/sbin/`. Con este script podemos hacer proxy a los correos de ZED y también llamar a nuestro sistema de notificaciones.
7. Modificar la configuración de ZED para interceptar los correos: `nano /etc/zfs/zed.d/zed.rc`. Modificar la linea de `ZED_EMAIL_PROG` con `ZED_EMAIL_PROG="/usr/local/sbin/process_email.sh"`. Modificar la linea de `ZED_EMAIL_OPTS` con `ZED_EMAIL_OPTS="'@SUBJECT@' @ADDRESS@"`. Guardar y salir con `Ctrl + X, Y, Enter`.
8. Instalar `mailx` para poder mandar correos desde los scripts: `dnf install -y mailx`.

### 5.15. Configurar tráfico externo público

Si usted no piensa acceder a su servidor fuera de su red local, puede omitir esta sección.

Haremos Port Forwarding de los puertos HTTP y HTTPS para Nginx y el puerto 51820 para WireGuard; deshabilitaremos IPv6 ya que complicaría demasiado la configuración; condicionalmente deshabilitaremos DHCP en el router o configuraremos Pi-hole como el DNS del DHCP; configuraremos Nginx para redireccionar el trafico a los contenedores; y permitiremos a Nginx actuar como proxy de Home Assistant.

#### 5.15.1. Pasos

1. Configurar el router. Cada router es diferente, así que tendrá que consultar su manual para poder hacer los pasos siguientes.
    1. Redireccionar el puerto (Port Forwarding) 80 y 443 en protocolo TCP al servidor para que Nginx pueda hacer reverse proxy a los servicios internos. Si piensa usar VPN privada con WireGuard, entonces también redireccionar puerto 51820 en UDP al servidor.
    2. Deshabilitar IPv6 porque Pi-hole solo puede hacer IPv4 con la configuración establecida y es mas complejo configurarlo para IPv6.
    3. Si su router permite configurar el DNS que el DHCP asigna a todos los dispositivos de la casa, entonces use el IP de Pi-hole en vez del que el ISP brinda. De lo contrario, tendrá que deshabilitar el DHCP para que Pi-hole sea el DHCP y pueda auto asignarse como DNS. Puede encontrar el IP de Pi-hole en Portainer si ve el stack en el editor y ve la configuración del contenedor `pihole`.
    4. Verificar que el DHCP de Pi-hole o del router esté funcionando (conectar un dispositivo a la red y verificar que se le asignara un IP en el rango configurado y que el DNS sea la IP del servidor).
2. Configurar proxy hosts en Nginx usando el DDNS.
    1. Acceder a Nginx a través de http://192.168.1.253:8181.
    2. Usar `admin@example.com` y `changeme` como usuario y contraseña y modificar los detalles y contraseña por una segura. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
    3. Navegar a la pestaña de `SSL Certificates`.
    4. Presionar `Add SSL Certificate`. Seleccionar `Let's Encrypt` como proveedor de certificados.
        1. Configurar un certificado SSL de "dominio comodín" con Let's Encrypt. Por ejemplo `*.micasa.duckdns.org` (note el `*` al principio del dominio).
        2. Es necesario habilitar `Usar DNS Challenge`.
        3. Seleccionar DuckDNS como proveedor DNS.
        4. Reemplazar `your-duckdns-token` por el token que generó en DuckDNS.org
        5. Aceptar los términos del servicio y guardar.
    5. Navegar a la pestaña de "Proxy Hosts" y configurar un proxy host para Jellyfin.
        1. En la pestaña de `Details` llenar:
            - "Domain Names": jellyfin.micasa.duckdns.org.
            - "Scheme": http.
            - "Forward Hostname/IP": jellyfin. Podemos usar el nombre del contenedor gracias a que Docker tiene un DNS interno que mapea el nombre del contenedor al IP interno de Docker.
            - "Forward Port": 8096. Usar el puerto interno del contenedor, no el puerto del servidor al que fue mapeado. Revise el puerto de cada contenedor en el stack de Portainer.
            - "BlockCommonExploits": activado.
            - "Websockets Support": activado. Jellyfin y Home Assistant lo necesitan, los demás servicios no parecen necesitarlo. Si nota algún problema con algún servicio cuando lo accede a través de Nginx (y no desde el puerto directo), pruebe habilitar esta opción.
        2. En la pestaña de `SSL` llenar:
            - "SSL Certificate": *.micasa.duckdns.org. Usamos el certificado creado en el paso 4.
            - "Force SSL": activado.
            - "HTTP/2 Support": activado.
            - "HSTS Enabled": activado.
            - "HSTS Subdomains": activado.
        3. En la pestaña de `Avanzado` llenar (Nota: esto es solo necesario para Jellyfin, los otros servicios no requieren nada en la pestaña `Avanzado`):
            ```sh
            # Disable buffering when the nginx proxy gets very resource heavy upon streaming
            proxy_buffering off;

            # Proxy main Jellyfin traffic
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header Host $host;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_headers_hash_max_size 2048;
            proxy_headers_hash_bucket_size 128;

            # Security / XSS Mitigation Headers
            # NOTE: X-Frame-Options may cause issues with the webOS app
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-XSS-Protection "0";
            add_header X-Content-Type-Options "nosniff";
            ```
        4. Repetir este paso para Bazarr, Home Assistant, Jellyseerr, Prowlarr, Radarr, Sonarr y qBittorrent. **No exponga Portainer ni Cockpit con Nginx!**
3. Configurar Home Assistant para permitir tráfico redireccionado por el Reverse Proxy de Nginx.
    1. Editar la configuración de Home Assistant: `nano /Apps/homeassistant/configuration.yaml`.
    2. Agregar la siguiente sección al final del archivo. Permitimos proxies de la red `172.21.3.0/24` que es la red de `nginx` que configuramos en el stack en Portainer.
        ```yml
        http:
            use_x_forwarded_for: true
            trusted_proxies:
                - 172.21.3.0/24
        ```
    3. Guardar y salir con `Ctrl + X, Y, Enter`.
4. Recargar la configuración de Home Assistant desde el UI para que surtan efecto los cambios.
    1. Acceder a Home Assistant a través de http://192.168.1.10:8123.
    2. Navegar a `Developer tools`.
    3. Presionar `Restart`.
5. Puede probar que Nginx funciona accediendo a un servicio a través del URL con su subdominio. Por ejemplo https://jellyfin.micasa.duckdns.org. Inténtelo desde adentro de su red local para probar el "split horizon DNS" y desde afuera para probar el DDNS.

### 5.16. Configurar tráfico externo privado

WireGuard de hecho ya fue configurado en el stack de Portainer y ya debería estar corriendo la VPN. Lo único que falta es configurar los clientes que se van a conectar a ella. Esto se puede hacer de 2 formas: a través de un código QR o a través de un archivo `.conf`. Una vez conectados a esta VPN, podremos acceder a servicios que no expusimos públicamente con nuestro Reverse Proxy como Portainer y Cockpit, los cuales son demasiado críticos como para exponer a ataques en la internet publica.

> Nota: WireGuard fue configurado con "split tunneling". Si usted desea redireccionar todo el tráfico del cliente, entonces debe cambiar la variable `ALLOWEDIPS` en el stack en Portainer a `0.0.0.0/0`.

#### 5.16.1. Pasos

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
    1. Conectar al servidor desde el dispositivo que va a ser el cliente con SSH: `ssh admin@192.168.1.253`.
    2. Mostramos la configuración para el cliente `laptop`: `sudo cat /Apps/wireguard/peer_laptop/peer_laptop.conf`.
    3. Copiar el contenido del archivo al portapapeles.
    4. Regresar a la consola del dispositivo cliente con `exit` o abrir una nueva consola.
    5. Creamos el archivo de configuración para una red virtual con nombre `wg0`: `sudo nano /etc/wireguard/wg0.conf`.
    6. Pegar el contenido del portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
    7. Si desea probar que funciona correctamente, desconectar su dispositivo de la red local (conectarse a su red Wifi de invitado o desde la red publica de un café o use su celular como módem) y habilitar la red virtual `wg0` con: `wg-quick up wg0`. Intentar acceder a una IP de su red local.

### 5.17. Instalar Cockpit

Finalmente instalaremos Cockpit con algunos plugins y configuraremos el cortafuegos para permitir el servicio de Cockpit a la red local.

#### 5.17.1. Pasos

1. Ejecutar: `./scripts/cockpit_setup.sh`. Instala Cockpit y sus plugins ademas de configurar Firewalld para permitir Cockpit en la red.
2. Para probar que funcionó acceder a Cockpit a través de https://192.168.1.253:9090. Usar sus credenciales de `admin`.

**Felicidades! ahora tiene su servidor casero funcionando y listo para trabajar!**

## 6. Glosario

### Bittorrent

Es un protocolo de comunicación para intercambio de archivos entre pares, es decir, sin un servidor central, que permite compartir datos de manera descentralizada. Se utiliza un servidor llamado rastreador que contiene la lista de archivos disponibles y los clientes que tienen una copia total o parcial del archivo. Un cliente puede usar esta lista para entonces solicitar a otros clientes partes del archivo y reconstruirlo al final. El cliente puede empezar a compartirlo a otros clientes desde el momento en que recibe su primera pieza de manera que se optimice el uso de recursos para no sobrecargar a un solo cliente. Más información: https://en.wikipedia.org/wiki/BitTorrent.

### Certificado SSL

El protocolo SSL (así como su sucesor TLS) utilizan un "Certificado de Llave Pública" para garantizar que la comunicación entre un cliente y un servidor sea segura. Un certificado de llave pública es un documento electrónico usado para probar la validez de una llave pública. Este contiene la llave pública, la identidad del dueño y una firma digital de una entidad que ha verificado el certificado. El certificado es presentado por el servidor al cliente, el cliente valida que el certificado concuerde con la dirección a la que se quiere conectar y que el certificado haya sido firmado por una autoridad confiable (el cliente puede decidir que autoridades son confiables), probando así que el servidor es efectivamente el destino deseado. Más información: https://en.wikipedia.org/wiki/Public_key_certificate.

#### Certificado de dominio comodín

Un certificado de dominio comodín (wildcard domain certificate) es un certificado que no solo cubre el tráfico a un dominio o subdominio especifico, sino también cualquier otro subdominio debajo del dominio especificado en el certificado. Por ejemplo un certificado con el destino *.micasa.duckdns.org cubre micasa.duckdns.org, jellyfin.micasa.duckdns.org, sonarr.micasa.duckdns.org, etc.

### Cockpit

Cockpit es una interfaz gráfica basada en web que permite la administración del servidor de manera remota, en un solo lugar, a través de un explorador web. Cockpit permite administrar usuarios, la red, el almacenamiento, las actualizaciones, SELinux, ZFS, Systemd, el journal, el cortafuegos, las métricas y si no fuera suficiente, tiene una terminal donde se puede hacer todo lo que no se puede hacer gráficamente. Cockpit usa los usuarios y contraseñas de Linux por lo que no es necesario crear una cuenta pero también es muy importante no exponer este servicio públicamente y proteger la contraseña. Mas información: https://cockpit-project.org.

### Contenedores

Es una técnica de virtualización a nivel de sistema operativo para que múltiples aplicaciones puedan ejecutarse en espacios de usuario asilados llamados contenedores con su propio ambiente evitando colisiones con otros contenedores y el mismo SO anfitrión. Mas información: https://en.wikipedia.org/wiki/Containerization_(computing).

### Cron

Mantener un servidor corriendo requiere de varias tareas. Algunas de ellas por suerte pueden ser automatizadas por medio de scripts y su ejecución automática por medio de un planificador de tareas. Cron es un planificador de tareas sencillo y robusto comúnmente usado en sistemas operativos Linux. Permite ejecutar tareas repetitivas periódicamente en fechas y horas especificas o por intervalos de tiempo. Más información: https://en.wikipedia.org/wiki/Cron.

#### crontab:

La tabla cron (cron table, abreviada crontab) es un archivo de configuración que maneja las acciones de cron. Esta especifica los comandos a ejecutar y su itinerario. pueden existir múltiples crontabs en un sistema en carpetas especificas (por ejemplo tareas del sistema, y tareas de un usuario) y el servicio cron las carga y lleva acabo.

### DNS

El Sistema de Nombres de Dominio (Domain Name System) es un sistema para nombrar computadoras de manera jerárquica y distribuida en redes que usan el protocolo IP. Asocia cierta información con "Nombres de Dominio" que son asignadas a las entidades asociadas. El uso más común es el de traducir un nombre de dominio fácilmente memorizable a una dirección IP numérica para localizar una computadora en la red. Es jerárquica ya que los servidores que mapean un dominio pueden delegar un subdominio a otro servidor múltiples niveles hasta llegar al último subdominio. Más información: https://en.wikipedia.org/wiki/Domain_Name_System.

#### Dominio

Es una cadena de caracteres que identifica una esfera de administración autónoma o autoridad o control. Es usualmente usado para identificar servicios proveídos a través del internet. Un nombre de dominio Identifica un dominio de red o a un recurso en una red que usa el protocolo de Internet.

#### Subdominio

Los dominios están organizados en niveles subordinados (subdominios) del dominio raíz del DNS, el cual no tiene nombre. A el primer nivel de dominios se les llama dominios de nivel-superior como "com", "net", "org", etc. Debajo de estos están los dominios de segundo y tercer nivel que están libres para reservación por usuarios que desean conectar su red a la internet y crear recursos públicos como un sitio web.

#### Split Horizon DNS

Si intentamos acceder a un URL con un dominio desde la red local (LAN) al que ese dominio pertenece en vez de una IP local, el DNS público (por ejemplo DuckDNS) nos regresará el IP público de la red y el router no podrá resolverlo, ya que estaremos intentando acceder al IP público desde el mismo IP público. Si configuramos un DNS interno dentro de la red local (por ejemplo Pi-hole) para que mapee el dominio o incluso subdominios a IPs locales, entonces crearemos una máscara que evitará redireccionar erróneamente las direcciones locales. Cuando un dispositivo es conectado a esta LAN, el DHCP asignará el DNS interno (Pi-hole) y este interceptará el dominio en vez de preguntarle al DNS público (DuckDNS). Si el mismo dispositivo se conectara fuera de la red local, el cliente DNS llamará a un DNS público (DuckDNS) como siempre, haciendo transparente para los clientes acceder a un dominio desde cualquier red sin necesidad de que el cliente manipule archivos del ordenador o que use el IP local en vez del dominio. A esta técnica se le conoce como DNS de horizonte dividido (Split Horizon DNS).

#### DDNS

Un problema común para los hogares que desean exponerse al tráfico externo es que el IP público puede cambiar en cualquier momento si el ISP así lo desea. Comúnmente solo a las empresas o instituciones se les asigna un IP estático. Si se intenta usar un DNS para mapear un dominio, eventualmente el IP al que apunta expirará y el dominio estará caído. Un DNS dinámico (DDNS) resuelve esto. Todo DDNS (como DuckDNS) requiere de un cliente que lo actualice cada determinado tiempo con el IP público de la red haciendo una llamada (con algún tipo de autenticación, claro) desde adentro de esa red, el DDNS automáticamente detectará el IP público del que se está haciendo la llamada y actualizará el DNS con ese IP.

### DHCP

El Protocolo Dinámico de Configuración de Anfitriones (Dynamic Host Configuration Protocol) es un protocolo de redes parte del Protocolo de Internet (IP) para asignar automáticamente una dirección IP y otros parámetros como la dirección de router y el DNS de la red. Esto elimina la necesidad de configurar manual e individualmente cada dispositivo en la red. El protocolo funciona con servidor DHCP central y un cliente DHCP en cada dispositivo que se quiera conectar. El cliente solicita los parámetros de la red cuando se conecta a la red y periódicamente después de esto usando el protocolo DHCP difundiendo un mensaje a la red en espera que un servidor DHCP lo escuche y le responda. Más información: https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol.

### Firewall

El Cortafuegos (Firewall) es un sistema de seguridad para redes que monitorea y controla el tráfico basado en reglas de seguridad predefinidas que permiten o bloquean el tráfico. Usualmente se utiliza como una barrera entre una red de confianza y una red no confiable (Como el Internet). Más información: https://en.wikipedia.org/wiki/Firewall_(computing).

### IP

Una dirección IP es una etiqueta numérica que es asignada a un dispositivo conectado a una red de computadoras que usa el Protocolo de Internet para comunicarse. Sirve dos propósitos: identificación y direccionamiento. Las versiones mas usadas son IPv4 e IPv6. Más información: https://en.wikipedia.org/wiki/IP_address.

#### IPv4

Una dirección IPv4 consiste de 32 bits. Usualmente es representada con 4 números decimales del 0 al 255 separados por un punto, por ejemplo 192.168.1.0. Cada número representa un grupo de 8 bits. Algunos rangos de IPv4 son comúnmente usados para propósitos especiales como redes privadas.

#### IPv6

En IPv6 se incrementó el tamaño de 32 bits a 128 bits. Esto debido a que el crecimiento exponencial de dispositivos conectados a la internet estaba acabando rápidamente con los IPs disponibles. La notación es normalmente 8 grupos de números de 4 dígitos Hexadecimales separados por `:`. por ejemplo 2001:0db8:85a3:0000:0000:8a2e:0370:7334

#### Máscara de Subred/CIDR

Para poder definir la arquitectura de las redes se usaban originalmente las máscaras de subred, pero poco a poco han sido reemplazadas por CIDR. La idea es dividir la dirección IP en 2 partes: el prefijo de red, que identifica una subred, y el identificador de dispositivo, que identifica un dispositivo único en la subred. Tanto la máscara de subred como el CIDR son maneras de indicar la división del IP. Por ejemplo, la notación CIDR "10.0.0.0/8" denota una subred IPv4 con 8 bits de prefijo (indicado por /8) y 24 bits de identificador (el restante de los 32 bits de IPv4), dando un rango de subred desde 10.0.0.0 hasta 10.255.255.255.

### LUKS

La Configuración Linux de Llave Unificada (Linux Unified Key Setup) es una especificación para encriptación de discos. La encriptación es a nivel de bloques así que cualquier sistema de archivos puede ser encriptado con LUKS. Más información: https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup.

### NAS

El Almacenamiento Conectado a la Red (Network Attached Storage, abreviado NAS) es un servidor de almacenamiento a nivel de archivo (en vez de a nivel de bloque) conectado a una red para proveer acceso a datos a un grupo de clientes. El servidor está optimizado para servir archivos por medio de su configuración de hardware y software. Usualmente ocupan los protocolos para compartir archivos NFS o SMB. Más información: https://en.wikipedia.org/wiki/Network-attached_storage.

### NAT

La Traducción de Direcciones de Red (Network Address Translation) es un método para mapear un rango de direcciones IP a otro. Normalmente se usa en modo "uno a muchos" que permite mapear múltiples clientes privados a un IP público. Los hogares normalmente son asignados un IP público por su proveedor de internet (ISP). Sin embargo, ese IP es compartido por todos los dispositivos del hogar gracias a un router que asigna IPs privados a cada uno de ellos y maneja su tráfico. Esto funciona ya que el tráfico es iniciado desde adentro de la red local y el router puede saber a quien redirigir la respuesta del trafico usando NAT. Más información: https://en.wikipedia.org/wiki/Network_address_translation.

#### Port Forwarding

El Redireccionamiento de Puerto (Port Forwarding) es una aplicación del NAT que traduce una dirección y puerto a otra cuando el tráfico es iniciado desde afuera de la red. Sin esto, el router no tiene manera de saber quien debe recibir la petición (recordemos que el NAT uno a muchos funciona de adentro hacia afuera). Otra manera de resolver esto sería configurar el router para redirigir todo el tráfico iniciado externamente al servidor. Esto no es muy recomendable ya que expondría el servidor a usuarios mal intencionados por ejemplo, a través del puerto SSH. La mejor solución es hacer Port Forwarding unicamente al tráfico recibido en los puertos deseados como el 80 (HTTP) y 443 (HTTPS) hacia el servidor desde el router.

### Reverse Proxy

Un Proxy en Reversa (Reverse Proxy) es una aplicación que se encuentra en medio de un cliente y múltiples servidores y ayuda a redirigir el trafico iniciado por el cliente al servidor correcto. Pueden tener muchos usos, pero en un servidor casero busca solucionar un problema con el Port Forwarding del router. con Port Forwarding podemos exponer unicamente un puerto, sin embargo, no todas las aplicaciones del servidor pueden escuchar en el mismo puerto. Un reverse proxy hace entonces algo similar al NAT pero en reversa y redirecciona el tráfico recibido en el puerto expuesto con Port Forwarding a las diferentes aplicaciones con el puerto correcto. Esto se logra a través de reglas que usan el URL (el subdominio por ejemplo) en la petición para identificar la aplicación a la cual redireccionar el tráfico. Más información: https://en.wikipedia.org/wiki/Reverse_proxy.

### Router

Un Enrutador (Router) es un dispositivo de red que redirecciona paquetes de datos entre redes. Los paquetes son enviados de un router a otro a través de múltiples redes hasta que alcanza su destino. Un router por ende está conectado a dos o más redes a la vez. El router utiliza un tabla de enrutamiento para comparar la dirección del paquete para determinar el siguiente destino en el camino del paquete. Más información: https://en.wikipedia.org/wiki/Router_(computing).

### Samba

Samba es una implementación de código libre del protocolo SMB para compartir archivos e impresoras pensado para clientes Microsoft. Hoy en día tanto Linux como macOS tienen clientes para conectarse a servidores Samba. Samba define recursos compartidos conocidos como shares para directorios definidos en el sistema. Los Samba shares se administran en un archivo de configuración que nos permite definir que directorios compartir, que usuarios tienen acceso a los diferentes shares, y que redes pueden acceder al servidor Samba. Samba usa los mismos usuarios que Linux, pero tiene su propia base de datos de contraseñas. Por eso es necesario asignar una contraseña Samba a cada usuario que se creo para usar los shares. Mas información: https://en.wikipedia.org/wiki/Samba_(software).

### Secure Boot

Inicio Seguro (Secure Boot) es un protocolo definido en la especificación UEFI diseñado para asegurar el proceso de inicio al prevenir cargar controladores UEFI o gestores de arranque que no estén firmados por una llave aceptable. Para habilitarlo se requiere cambiar en el BIOS primero a modo "Setup" para poder configurar nuestras llaves públicas. Para poder cargar un gestor de arranque al inicio se requiere firmar los archivos de la partición `/efi` con la llave privada. Igualmente, para cargar controladores al inicio, es necesario registrar la firma del controlador a la base de datos de firmas confiables. Después es necesario salir del modo "Setup" y habilitar Secure Boot. Normalmente se protege el BIOS con contraseña para impedir su desactivación. Más información: https://en.wikipedia.org/wiki/UEFI#Secure_Boot.

### SELinux

Linux de Seguridad Mejorada (Security-Enhanced-Linux abreviado SELinux) es un módulo de seguridad del kernel Linux que provee un mecanismo para soportar pólizas de seguridad de control de acceso incluyendo Controles de Acceso Mandatorio (MAC). Permite imponer la separación de información basada en los requerimientos de integridad y confidencialidad, confinando el daño que una aplicación maliciosa pudiera causar. Más información: https://en.wikipedia.org/wiki/Security-Enhanced_Linux.

### SMART

SMART, o S.M.A.R.T., es un sistema de monitoreo incluido en discos duros (HDDs) y discos de estado sólido (SSDs). Sirve para detectar y reportar indicadores del estado del disco con el propósito de anticipar una falla inminente en el disco. Esto le da tiempo al usuario de prevenir perdida de datos y reemplazar el disco para continuar con la integridad de los datos. Más información: https://en.wikipedia.org/wiki/Self-Monitoring,_Analysis_and_Reporting_Technology.

#### smartd

Smartd es un daemon parte del paquete "SMART monitor tools" que monitorea de manera configurable el SMART de los diferentes discos del servidor y notifica cuando hay un problema por medio de un script.

### VPN

Una Red Privada Virtual (Virtual Private Network) es un mecanismo para crear una conexión segura entre un dispositivo y una red o entre dos redes usando un medio inseguro como el internet. Esta es creada usando una conexión punto a punto por medio de protocolos de túnel. Una VPN nos permite acceder a nuestra red local como si estuviéramos físicamente conectados a ella. Podremos acceder a servicios que no expusimos públicamente con nuestro Reverse Proxy como Portainer y Cockpit, los cuales son demasiado críticos como para exponer a ataques en la internet publica. Más información: https://en.wikipedia.org/wiki/Virtual_private_network.

#### Split Tunneling

Normalmente una VPN redirecciona todo el trafico de un cliente al través de ella. Es posible configurar la VPN para solo redireccionar trafico en cierto rango de IPs (como su red local) y no redireccionar el resto. Si navega a cualquier otro IP desde ese cliente (por ejemplo a google.com), usará su red normal y por ende el IP público del dispositivo cliente. A esta configuración se le llama Tunelización Dividida (Split Tunneling).

#### WireGuard

Es una implementación de VPN que usa encriptación asimétrica para garantizar que nadie pueda conectarse si no tiene la llave generada por el servidor. Su objetivo es ser una VPN sencilla, rápida, moderna, y eficiente.

### ZFS

Es un sistema de archivos con capacidades de manejo de volúmenes tanto físicos como lógicos. Al tener el conocimiento tanto del sistema de archivos como del disco físico, le permite manejar eficientemente los datos. Está enfocado en garantizar que los datos no se pierdan por errores físicos, errores del sistema operativo o corrupción por el paso del tiempo. Emplea técnicas como COW, snapshots y replicación para mayor robustez. Mas información: https://en.wikipedia.org/wiki/ZFS.

#### COW

Copiar-al-escribir (Copy-on-write abreviado COW) es una técnica en la cual cualquier dato modificado no sobrescribe el dato original sino que es escrito aparte y luego el original puede ser borrado, garantizando que no se pierdan los datos en caso de un error durante la escritura.

#### Snapshots

COW permite retener los bloques viejos que serían descartados en un "instante de tiempo" (Snapshot) que permite restaurar a una versión anterior del dataset. Solo se guarda el diferencial entre dos snapshots por lo que es muy eficiente en términos de espacio.

#### RAID

Es una tecnología que permite combinar múltiples discos físicos en una o más unidades lógicas con el propósito de redundancia de datos, mejora de rendimiento o ambos. ZFS tiene su propia implementación de RAID. En ZFS `raidz` es equivalente a RAID5 que permite tener un disco de redundancia, es decir, puede fallar un solo disco antes de que la alberca pierda datos. Mientras que `raidz2` es equivalente a RAID6 permite 2 discos de redundancia.

## 7. Cómprame un café

Siempre puede invitarme un café aquí:

[![PayPal](https://img.shields.io/badge/PayPal-Donate-blue.svg?logo=paypal&style=for-the-badge)](https://www.paypal.com/donate/?business=AKVCM878H36R6&no_recurring=0&item_name=Buy+me+a+coffee&currency_code=USD)

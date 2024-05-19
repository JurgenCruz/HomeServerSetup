# Instalar Fedora Server

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Install%20fedora%20server.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Install%20fedora%20server.es.md)

Para instalar Fedora Server necesitaremos una memoria USB y descargar el ISO de la pagina oficial de Fedora. Escribiremos el ISO a la USB e iniciaremos el instalador del sistema operativo. Configuraremos nuestra instalación y dejaremos al asistente hacer el resto. La guía asume que preparará el medio de instalación desde un sistema operativo Linux. Si lo hace desde Windows, puede intentar usar la herramienta Rufus y su guía: https://rufus.ie/.

> [!CAUTION]
> **Antes de iniciar asegúrese de respaldar los datos de la memoria USB ya que esta será formateada y se perderán todos los datos en ella!**

> [!CAUTION]
> **Antes de iniciar asegúrese de respaldar los datos en los discos del servidor ya que estos serán formateados y se perderán todos los datos en ellos!**

## Pasos

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
16. Hacer clic en `Network & Host Name` y establecer el `Host Name`. La guía usará `server.lan` pero usted puede usar otro nombre. Presionar `Done` para regresar al menú principal.
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
        7. `Mountpoint` debe ser `/`.
        8. Aceptar.
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
31. Apagar el servidor: `shutdown`.

[<img width="33.3%" src="buttons/prev-Guide.es.svg" alt="Guía">](Guide.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Configure secure boot.es.svg" alt="Configurar Secure Boot">](Configure%20secure%20boot.es.md)

# Configurar tareas programadas

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20scheduled%20tasks.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20scheduled%20tasks.es.md)

Automatizaremos las tareas siguientes: creación y purga automática de snapshots de ZFS; limpieza de albercas de ZFS; respaldo de la configuración de los contenedores; actualización de las imágenes de los contenedores a la última versión; pruebas cortas y largas de discos duros con SMART; y actualización de IP público en DDNS. Si nota que algún script no tiene la bandera de ejecutable, convertirlo en ejecutable con el comando `chmod 775 <file>` reemplazando `<file>` por el nombre del script.

## Pasos

1. Copiar script para manejo de snapshots de ZFS: `cp ./scripts/snapshot-with-purge.sh /usr/local/sbin/`. Este script crea snapshots recursivos de todos los datasets de una alberca con la misma estampa de tiempo. Después purga los snapshots viejos según la póliza de retención. Note que la póliza de retención no es por tiempo sino por numero de snapshots creados por el script (los snapshots creados manuales con esquema de nombres diferente serán ignorados).
2. Copiar script de notificaciones usando Home Assistant para reportar problemas: `cp ./scripts/notify.sh /usr/local/sbin/`. Si usó un IP diferente para Home Assistant en la macvlan, ajuste el script con `nano /usr/local/sbin/notify.sh` con el IP correcto.
3. Si no va a usar DDNS, editar el script: `nano ./scripts/systemd-timers_setup.sh`. Remover la última linea referente a DDNS. Guardar y salir con `Ctrl + X, Y, Enter`.
4. Ejecutar: `./scripts/systemd-timers_setup.sh`. Creamos tareas programadas para limpieza de albercas de ZFS mensualmente el día 15 a la 01:00; creación y purga de snapshots de ZFS diario a las 00:00; respaldo de configuración de los contenedores diario a las 23:00; actualización de las imágenes de Docker diario a las 23:30; y actualización del IP al DDNS cada 5 minutos. Si cualquier tarea falla, se notificará al usuario a través del webhook de Home Assistant.
5. Copiar script de notificaciones para smartd: `cp ./scripts/smart_error_notify.sh /usr/local/sbin/`. Con este script escribiremos al log del sistema y también llamaremos a nuestro sistema de notificaciones.
6. Copiar configuración de los SMART tests: `cp ./files/smartd.conf /etc/`. Configuramos prueba SHORT semanalmente los domingos a las 00:00 y prueba LONG 1 vez cada dos meses, el primero del mes a la 01:00; y usamos nuestro script de notificaciones.
7. Recargar smartd para que surtan efecto los cambios: `systemctl restart smartd.service`.
8. Modificar la configuración de ZED para interceptar los correos: `nano /etc/zfs/zed.d/zed.rc`. Modificar la linea de `ZED_EMAIL_PROG` con `ZED_EMAIL_PROG="/usr/local/sbin/notify.sh"`. Modificar la linea de `ZED_EMAIL_OPTS` con `ZED_EMAIL_OPTS="'@SUBJECT@'"`. Guardar y salir con `Ctrl + X, Y, Enter`.
9. Recargar ZED para que surtan efecto los cambios: `systemctl restart zed.service`.

[<img width="50%" src="buttons/prev-Configure applications.es.svg" alt="Configurar aplicaciones">](Configure%20applications.es.md)[<img width="50%" src="buttons/next-Configure public external traffic.es.svg" alt="Configurar tráfico externo público">](Configure%20public%20external%20traffic.es.md)

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

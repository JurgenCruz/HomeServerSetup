# Configurar tareas programadas

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20scheduled%20tasks.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20scheduled%20tasks.es.md)

Automatizaremos las tareas siguientes: creación y purga automática de snapshots de ZFS; limpieza de albercas de ZFS; respaldo de la configuración de los contenedores; actualización de las imágenes de los contenedores a la última versión; pruebas cortas y largas de discos duros con SMART; y actualización de IP pública en DDNS. Si nota que algún script no tiene la bandera de ejecutable, convertirlo en ejecutable con el comando `chmod 775 <file>` reemplazando `<file>` por el nombre del script.

## Pasos

1. Copiar script para manejo de snapshots de ZFS: `cp ./scripts/snapshot-with-purge.sh /usr/local/sbin/`. Este script crea snapshots recursivos de todos los datasets de una alberca con la misma estampa de tiempo. Después purga los snapshots viejos según la póliza de retención. Note que la póliza de retención no es por tiempo sino por número de snapshots creados por el script (los snapshots creados manuales con esquema de nombres diferente serán ignorados).
2. Copiar script de notificaciones usando Home Assistant para reportar problemas: `cp ./scripts/notify.sh /usr/local/sbin/`. Ajustar el script con `nano /usr/local/sbin/notify.sh` y reemplace `{your_token_here}` con el token que se generó en Gotify para la App NAS. También reemplazar el dominio por el que registró en DuckDNS.
3. Copiar el script para actualizar imágenes de Docker: `cp ./scripts/apps-update.sh /usr/local/sbin/`. Este script recorre la lista de stacks de Portainer y actualiza las imágenes y reinicia los contenedores con nuevas imágenes.
4. Si no va a usar DDNS, editar el script: `nano ./scripts/systemd-timers_setup.sh`. Remover la última linea referente a DDNS. Guardar y salir con `Ctrl + X, Y, Enter`.
5. Ejecutar: `./scripts/systemd-timers_setup.sh`. Creamos tareas programadas para limpieza de albercas de ZFS mensualmente el día 15 a la 01:00; creación y purga de snapshots de ZFS diario a las 00:00; respaldo de configuración de los contenedores diario a las 23:00; actualización de las imágenes de Docker diario a las 23:30; y actualización del IP al DDNS cada 5 minutos. Si cualquier tarea falla, se notificará al usuario a través del webhook de Home Assistant.
6. Copiar script de notificaciones para smartd: `cp ./scripts/smart_error_notify.sh /usr/local/sbin/`. Con este script escribiremos al log del sistema y también llamaremos a nuestro sistema de notificaciones.
7. Copiar configuración de los SMART tests: `cp ./files/smartd.conf /etc/`. Configuramos prueba SHORT semanalmente los domingos a las 00:00 y prueba LONG 1 vez cada dos meses, el primero del mes a la 01:00; y usamos nuestro script de notificaciones.
8. Recargar smartd para que surtan efecto los cambios: `systemctl restart smartd.service`.
9. Modificar la configuración de ZED para interceptar los correos: `nano /etc/zfs/zed.d/zed.rc`. Modificar la línea de `ZED_EMAIL_PROG` con `ZED_EMAIL_PROG="/usr/local/sbin/notify.sh"`. Modificar la línea de `ZED_EMAIL_OPTS` con `ZED_EMAIL_OPTS="'@SUBJECT@'"`. Guardar y salir con `Ctrl + X, Y, Enter`.
10. Recargar ZED para que surtan efecto los cambios: `systemctl restart zed.service`.

**¡Felicidades! ¡Ahora tiene su servidor casero funcionando y listo para trabajar!**

[<img width="33.3%" src="buttons/prev-Create and configure private external traffic stack optional.es.svg" alt="Crear y configurar stack de tráfico externo privado (Opcional)">](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Glossary.es.svg" alt="Glosario">](Glossary.es.md)
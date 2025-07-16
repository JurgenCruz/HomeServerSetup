# Configurar shares

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20shares.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20shares.es.md)

Se instalará Samba, se configurarán los shares de Samba, se crearán las contraseñas para los usuarios que son separadas de las de Linux (si gusta puede usar las mismas contraseñas que las de Linux) y se configurará el cortafuegos para permitir el servicio de Samba a la red local.

## Pasos

1. Ejecutar: `./scripts/smb_setup.sh`. Instala servicio Samba.
2. Ejecutar: `./scripts/set_samba_passwords.sh`. Ingresar un nombre de usuario y establecer una contraseña para el mismo. El script seguiŕa preguntando por más usuarios. Ingresar tantos como desee que tengan acceso al servicio Samba. En esta guía se asume que se establecerá una contraseña para al menos 1 usuario: `mediacenter`.
3. Copiar la configuración del servidor Samba preconfigurada con 1 share para el usuario del paso anterior: `cp ./files/smb.conf /etc/samba`.
4. Editar el archivo: `nano /etc/samba/smb.conf`. Puede agregar nuevos shares copiando el share `[MediaCenter]` existente y cambiandole el nombre y las propiedades `path` y `valid users`. La guía asume que la red local esta en el rango 192.168.1.0/24. Si su red es diferente, entonces también cambie la propiedad `allow hosts` para que tenga el rango correcto de su red local. Guardar y salir con `Ctrl + X, Y, Enter`.
5. Ejecutar: `./scripts/smb_firewalld_services.sh`. Configura Firewalld abriendo los puertos para Samba y después habilita el servicio de Samba.

[<img width="33.3%" src="buttons/prev-Configure zfs.es.svg" alt="Configurar ZFS">](Configure%20zfs.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Install docker.es.svg" alt="Instalar Docker">](Install%20docker.es.md)

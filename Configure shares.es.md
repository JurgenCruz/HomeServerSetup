# Configurar shares

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20shares.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20shares.es.md)

Se instalará Samba, se configurarán los shares de Samba, se crearán las contraseñas para los usuarios que son separadas de las de Linux (si gusta puede usar las mismas contraseñas que las de Linux) y se configurará el cortafuegos para permitir el servicio de Samba a la red local.

## Pasos

1. Ejecutar: `./scripts/smb_setup.sh`. Instala servicio Samba.
2. Ejecutar: `./scripts/set_samba_passwords.sh`. Ingresar el nombre de usuario y establecer una contraseña para el mismo. En esta guía se asume que se establecerán contraseñas para 3 usuarios: `mediacenter`, `nasj` y `nask`.
3. Copiar la configuración del servidor Samba preconfigurada con 3 shares para los usuarios del paso anterior: `cp ./files/smb.conf /etc/samba`.
4. Editar el archivo: `nano /etc/samba/smb.conf`. Puede cambiar los nombres de los shares (e.g. \[NASJ\]), y las propiedades `path` y `valid users`. La guía asume que la red local esta en el rango 192.168.1.0/24. Si su red es diferente, entonces también cambie la propiedad `allow hosts` para que tenga el rango correcto de su red local. Guardar y salir con `Ctrl + X, Y, Enter`.
5. Ejecutar: `./scripts/smb_firewalld_services.sh`. Configura Firewalld abriendo los puertos para Samba y después habilita el servicio de Samba.

[<img width="50%" src="buttons/prev-Configure hosts network.es.svg" alt="Configurar red del anfitrión">](Configure%20hosts%20network.es.md)[<img width="50%" src="buttons/next-Register ddns.es.svg" alt="Registrar DDNS">](Register%20ddns.es.md)

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

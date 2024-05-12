# Registrar DDNS

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Register%20ddns.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Register%20ddns.es.md)

Si usted no piensa acceder a su servidor fuera de su red local, o si cuenta con un IP público estático y su propio dominio, puede omitir esta sección.

Esta guía usará el servicio de DuckDNS.org como DDNS para poder mapear un subdominio a nuestro servidor. Registraremos un subdominio en DuckDNS.org y configuraremos nuestro servidor para actualizar el IP en DuckDNS.org.

## Pasos

1. Registrar un subdominio en DuckDNS.org.
    1. Acceder y crear una cuenta en https://www.duckdns.org/.
    2. Registrar un subdominio de su preferencia. Anotar el token generado porque lo vamos a necesitar a continuación.
2. Copiar el script que actualiza el DDNS con nuestro IP público a `sbin`: `cp ./scripts/duck.sh /usr/local/sbin/`.
3. Editar el script: `nano /usr/local/sbin/duch.sh`. Reemplazar `XXX` con el subdominio que registramos y `YYY` con el token que nos generó durante el registro. Guardar y salir con `Ctrl + X, Y, Enter`.
4. Cambiamos los permisos del script para que solo `root` pueda acceder a el: `chmod 700 /usr/local/sbin/duck.sh`. El script contiene nuestro token que es lo único que permite que solo nosotros podamos cambiar el IP al que apunta el subdominio, de ahí la importancia de asegurarlo.

[<img width="50%" src="buttons/prev-Configure shares.es.svg" alt="Configurar shares">](Configure%20shares.es.md)[<img width="50%" src="buttons/next-Install docker.es.svg" alt="Instalar Docker">](Install%20docker.es.md)

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

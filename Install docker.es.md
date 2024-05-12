# Instalar Docker

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Install%20docker.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Install%20docker.es.md)

Instalaremos Docker como nuestro motor de contenedores; opcionalmente instalaremos los controladores de Nvidia y "Nvidia Container Toolkit"; y configuraremos SELinux para asegurar Docker.

## Pasos

1. Ejecutar: `./scripts/docker_setup.sh admin`. Agrega el repositorio de Docker, lo instala, habilita el servicio y agrega al usuario `admin` al grupo `docker`.
2. Ejecutar: `./scripts/selinux_setup.sh`. Habilita SELinux en Docker; reinicia el servicio de Docker para que surtan efecto los cambios; activa las banderas que permite a los contenedores manejar la red y usar el GPU; e instala pólizas de SELinux. Estas son necesarias para algunos contenedores para poder acceder a archivos de Samba y interactuar con WireGuard y para que rsync sea capaz de respaldar las aplicaciones.
3. Opcional: Si tiene una tarjeta Nvidia relativamente moderna, ejecutar: `./scripts/nvidia_setup.sh`. Agrega repositorios de "RPM Fusion" y Nvidia para instalar el controlador y el "Nvidia Container Toolkit" para Docker. También registra la llave de "Akmods" en la cadena de Secure Boot. Es necesario reiniciar y repetir el proceso de enrolar la llave como lo hicimos con ZFS. Después de reiniciar y iniciar sesión, no se olvide de asumir `root` con `sudo -i`.

[<img width="50%" src="buttons/prev-Register ddns.es.svg" alt="Registrar DDNS">](Register%20ddns.es.md)[<img width="50%" src="buttons/next-Create docker stack.es.svg" alt="Crear stack de Docker">](Create%20docker%20stack.es.md)

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

# Configurar Secure Boot

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20secure%20boot.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20secure%20boot.es.md)

Se configurará Secure Boot con llaves del dueño y se pondrá contraseña al BIOS para impedir su desactivación.

## Pasos

1. Prender el servidor y entrar al BIOS (usualmente con la tecla `F2`).
2. Configurar el Secure Boot en modo "Setup", guardar y reiniciar.
3. Después de iniciar sesión con `admin`, ejecutar: `sudo ./scripts/secureboot.sh`.
4. Si no hubo errores, entonces ejecutar `reboot` para reiniciar y entrar al BIOS nuevamente.
5. Salir del modo "Setup" y habilitar Secure Boot.
6. Ponerle contraseña al BIOS, guardar y reiniciar.
7. Después de iniciar sesión con `admin`, ejecutar: `sbctl status`. El mensaje debería decir que está instalado y Secure Boot habilitado.

[<img width="50%" src="buttons/prev-Install fedora server.es.svg" alt="Instalar Fedora Server">](Install%20fedora%20server.es.md)[<img width="50%" src="buttons/next-Install and configure zsh optional.es.svg" alt="Instalar y configurar Zsh (Opcional)">](Install%20and%20configure%20zsh%20optional.es.md)

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

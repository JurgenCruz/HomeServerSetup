# Instalar ZFS

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Install%20zfs.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Install%20zfs.es.md)

Ya que ZFS es un modulo del kernel, significa que también tiene que pasar la inspección de Secure Boot. Instalaremos ZFS y registraremos en la cadena de inicio de Secure Boot la llave usada para firmarlo. Este registro requiere reiniciar el servidor y navegar un asistente como se explicará más adelante.

## Pasos

1. Ejecutar: `./scripts/zfs_setup.sh`. El script le pedirá que ingrese una contraseña. Esta contraseña será usada por única vez en el próximo reinicio para agregar la firma a la cadena de Secure Boot. Puede usar una contraseña temporal o puede reusar la de su usuario si lo desea.
2. Reiniciar con: `reboot`.
3. Le aparecerá una pantalla azul con un menú. Seleccione las siguientes opciones:
    1. "Enroll MOK".
    2. "Continue".
    3. "Yes".
    4. Ingrese la contraseña que definió en el primer paso.
    5. "OK".
    6. "Reboot".

[<img width="50%" src="buttons/prev-Configure users.es.svg" alt="Configurar usuarios">](Configure%20users.es.md)[<img width="50%" src="buttons/next-Configure zfs.es.svg" alt="Configurar ZFS">](Configure%20zfs.es.md)

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

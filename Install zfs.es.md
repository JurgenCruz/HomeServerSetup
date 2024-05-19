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

[<img width="33.3%" src="buttons/prev-Configure users.es.svg" alt="Configurar usuarios">](Configure%20users.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Configure zfs.es.svg" alt="Configurar ZFS">](Configure%20zfs.es.md)

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

[<img width="33.3%" src="buttons/prev-Install fedora server.es.svg" alt="Instalar Fedora Server">](Install%20fedora%20server.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Install and configure zsh optional.es.svg" alt="Instalar y configurar Zsh (Opcional)">](Install%20and%20configure%20zsh%20optional.es.md)

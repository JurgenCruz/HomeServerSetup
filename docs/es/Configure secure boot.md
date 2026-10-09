# Configurar Secure Boot

Se configurará Secure Boot con llaves del dueño y se pondrá contraseña al BIOS para impedir su desactivación.

## Pasos

1. Prender el servidor y entrar al BIOS (usualmente con la tecla `F2`).
2. Configurar el Secure Boot en modo "Setup", guardar y reiniciar.
3. Después de iniciar sesión con `admin`, ejecutar: `sudo ./scripts/secureboot.sh`.
4. Si no hubo errores, entonces ejecutar `reboot` para reiniciar y entrar al BIOS nuevamente.
5. Salir del modo "Setup" y habilitar Secure Boot.
6. Ponerle contraseña al BIOS, guardar y reiniciar.
7. Después de iniciar sesión con `admin`, ejecutar: `sbctl status`. El mensaje debería decir que está instalado y Secure Boot habilitado.

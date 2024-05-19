# Registrar DDNS (Opcional)

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Register%20ddns.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Register%20ddns.es.md)

Si usted no piensa acceder a su servidor fuera de su red local, o si cuenta con un IP público estático y su propio dominio, puede omitir esta sección.

Esta guía usará el servicio de DuckDNS.org como DDNS para poder mapear un subdominio a nuestro servidor. Registraremos un subdominio en DuckDNS.org y configuraremos nuestro servidor para actualizar el IP en DuckDNS.org.

## Pasos

1. Registrar un subdominio en DuckDNS.org.
    1. Acceder y crear una cuenta en https://www.duckdns.org/.
    2. Registrar un subdominio de su preferencia. Anotar el token generado porque lo vamos a necesitar a continuación.
2. Copiar el script que actualiza el DDNS con nuestro IP público a `sbin`: `cp ./scripts/duck.sh /usr/local/sbin/`.
3. Editar el script: `nano /usr/local/sbin/duck.sh`. Reemplazar `XXX` con el subdominio que registramos y `YYY` con el token que nos generó durante el registro. Guardar y salir con `Ctrl + X, Y, Enter`.
4. Cambiamos los permisos del script para que solo `root` pueda acceder a el: `chmod 700 /usr/local/sbin/duck.sh`. El script contiene nuestro token que es lo único que permite que solo nosotros podamos cambiar el IP al que apunta el subdominio, de ahí la importancia de asegurarlo.

[<img width="33.3%" src="buttons/prev-Install cockpit.es.svg" alt="Instalar Cockpit">](Install%20cockpit.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Configure users.es.svg" alt="Configurar usuarios">](Configure%20users.es.md)

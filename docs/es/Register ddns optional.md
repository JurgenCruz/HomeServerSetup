# Registrar DDNS (Opcional)

Si usted no piensa acceder a su servidor fuera de su red local, o si cuenta con un IP público estático y su propio dominio, puede omitir esta sección.

Esta guía usará el servicio de DuckDNS.org como DDNS para poder mapear un subdominio a nuestro servidor. Registraremos un subdominio en DuckDNS.org y configuraremos nuestro servidor para actualizar el IP en DuckDNS.org.

## Pasos

1. Registrar un subdominio en DuckDNS.org.
    1. Acceder y crear una cuenta en https://www.duckdns.org/.
    2. Registrar un subdominio de su preferencia. Anotar el token generado porque lo vamos a necesitar a continuación.
2. Copiar el script que actualiza el DDNS con nuestro IP público a `sbin`: `cp ./scripts/duck.sh /usr/local/sbin/`.
3. Editar el script: `nano /usr/local/sbin/duck.sh`. Reemplazar `XXX` con el subdominio que registramos y `YYY` con el token que nos generó durante el registro. Guardar y salir con `Ctrl + X, Y, Enter`.
4. Cambiamos los permisos del script para que solo `root` pueda acceder a el: `chmod 700 /usr/local/sbin/duck.sh`. El script contiene nuestro token que es lo único que permite que solo nosotros podamos cambiar el IP al que apunta el subdominio, de ahí la importancia de asegurarlo.

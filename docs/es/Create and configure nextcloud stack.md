# Crear y configurar stack de Nextcloud

Configuraremos el stack de Docker de Nextcloud y levantaremos el stack a través de Arcane. El stack consiste del siguiente contenedor:

- Nextcloud: Motor de respaldo y sincronización de archivos.
- Redis: Caché en memoria.
- MariaDB: Base de datos.
- Nextcloud-cron: Ejecutor de tareas programadas.

## Pasos

1. Ejecutar: `./scripts/create_nextcloud_folder.sh` para generar el directorio del contenedor en el SSD.
2. Editar el archivo del stack: `nano ./files/nextcloud-stack.yml`.
3. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Reemplazar `NEXTCLOUD_TRUSTED_DOMAINS=server.lan nextcloud.myhome.duckdns.org` con el hostname de su servidor y el subdominio que registró en DuckDNS.org. Si no se va a exponer el servicio al internet, puede dejar solamente el hostname de su servidor.
5. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
6. Agregar stack en Arcane desde el navegador.
    1. Acceder a Arcane a través de https://arcane.micasa.duckdns.org.
    2. Darle clic en "Projects" en el menú izquierdo y crear un nuevo proyecto.
    3. Ponerle nombre "nextcloud" y pegar el contenido del nextcloud-stack.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Arcane y no en el archivo.
7. Acceder a Nextcloud a través de https://nextcloud.micasa.duckdns.org.
8. Usar las siguientes credenciales: nombre de usuario: `admin`, contraseña `nextcloud`.
9. Usar el asistente para completar la instalación.
10. Navegar a la configuración de usuario y cambiar la contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
11. Puede navegar a `Configuración de Adminstrador` y cambiar lo que quiera.
12. Navegar a `Cuentas` y crear cuantas para sus usuarios.
13. Instalar el cliente de Nextcloud en sus dispositivos desde este enlace: https://nextcloud.com/install/.
14. Cuando configure el cliente, usar uno de los dominios del paso 4 para acceder.

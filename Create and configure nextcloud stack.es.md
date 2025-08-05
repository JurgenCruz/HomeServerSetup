# Crear y configurar stack de Nextcloud

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20nextcloud%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20nextcloud%20stack.es.md)

Configuraremos el stack de Docker de Nextcloud y levantaremos el stack a través de Portainer. El stack consiste del siguiente contenedor:

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
6. Agregar stack en Portainer desde el navegador.
    1. Acceder a Portainer a través de https://portainer.micasa.duckdns.org.
    2. Darle clic en "local".
    3. Seleccionar "Stacks" y crear un nuevo stack.
    4. Ponerle nombre "nextcloud" y pegar el contenido del nextcloud-stack.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Portainer y no en el archivo.
7. Acceder a Nextcloud a través de https://nextcloud.micasa.duckdns.org.
8. Usar las siguientes credenciales: nombre de usuario: `admin`, contraseña `nextcloud`.
9. Usar el asistente para completar la instalación.
10. Navegar a la configuración de usuario y cambiar la contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
11. Puede navegar a `Configuración de Adminstrador` y cambiar lo que quiera.
12. Navegar a `Cuentas` y crear cuantas para sus usuarios.
13. Instalar el cliente de Nextcloud en sus dispositivos desde este enlace: https://nextcloud.com/install/.
14. Cuando configure el cliente, usar uno de los dominios del paso 4 para acceder.

[<img width="33.3%" src="buttons/prev-Create and configure public external traffic stack optional.es.svg" alt="Crear y configurar stack de tráfico externo público">](Create%20and%20configure%20public%20external%20traffic%20stack.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create and configure arr applications stack.es.svg" alt="Crear y configurar stack de aplicaciones arr">](Create%20and%20configure%20arr%20applications%20stack.es.md)
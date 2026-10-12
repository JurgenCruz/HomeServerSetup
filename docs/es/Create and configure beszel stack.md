# Crear y configurar stack de Beszel

Configuraremos el stack de Docker de Nextcloud y levantaremos el stack a través de Arcane. El stack consiste del siguiente contenedor:

- Beszel: Panel de monitoreo de sistemas.
- Beszel Agent: Programa agente que colecta los datos del sistema y los envía al panel.

## Pasos

1. Ejecutar: `./scripts/create_beszel_folder.sh` para generar el directorio del contenedor en el SSD.
2. Editar el archivo del stack: `nano ./files/beszel-stack.yml`.
3. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Reemplazar las variables de ambiente `APP_URL` y `HUB_URL` con el subdominio que registró en DuckDNS.org. Si no se va a exponer el servicio al internet, puede usar el hostname de su servidor.
5. Si tiene una GPU Nvidia, saltar este paso. Borrar o comentar la imagen no comentada bajo beszel-agent `henrygd/beszel-agent-nvidia:latest` y descomentar la imagen comentada `henrygd/beszel-agent:alpine`. Borrar o comentar las propiedades `runtime` y `deploy` por completo.
6. Bajo `devices`, agregar todos los discos que quiera monitorear con un mapeo uno a uno, por ejemplo `/dev/sda:/dev/sda`.
7. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
8. Agregar stack en Arcane desde el navegador.
    1. Acceder a Arcane a través de https://arcane.micasa.duckdns.org.
    2. Darle clic en "Projects" en el menú izquierdo y crear un nuevo proyecto.
    3. Ponerle nombre "beszel" y pegar el contenido del beszel-stack.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Arcane y no en el archivo.
9. Acceder a Beszel a través de https://beszel.micasa.duckdns.org.
10. Usar el asistente para crear una cuenta de usuario y contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
11. Darle clic en "Add System", un diálogo debería aparecer con los campos de `Key` y de `Token`. Copiar los valores y regresar a Arcane y editar la stack de Beszel. Reemplazar las variables de ambiente `TOKEN` y `KEY` con los valores copiados del diálogo y darle clic en "Save and redeploy".
12. Regresar a la pestaña de Beszel en su navegador e ingresar `localhost` bajo "Name" y `/beszel_socket/beszel.sock` bajo "Host/IP". Darle clic al botón `Add system` en el diálogo.
13. Navegar a `Settings > Notifications` y bajo "Webhook / Push notifications" ingresar `gotify://gotify.micasa.duckdns.org/{token}`. Reemplazar `{token}` con el token que copió de Gotify para Beszel. Darle clic al botón `Test URL` para verificar que sirva.
14. Darle clic en `Save Settings`.
15. Regresar a la página de inicio de Beszel. Bajo "All System" debería aparecer `localhost`. Al final de la fila, darle clic al botón "Alerts".
16. Habilitar y configurar las alertas de las que desee recibir notificaciones.

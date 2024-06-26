# Crear y configurar stack de Home Assistant

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20home%20assistant%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20home%20assistant%20stack.es.md)

Configuraremos el stack de Docker de Home Assistant y levantaremos el stack a través de Portainer. El stack consiste del siguiente contenedor:

- Home Assistant: Motor de automatización del hogar.

## Pasos

1. Ejecutar: `./scripts/create_home_assistant_folder.sh` para generar el directorio del contenedor en el SSD.
2. Editar el archivo del stack: `nano ./files/home-assistant-stack.yml`.
3. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Si no se va a exponer el servidor al internet, quitar la red de `nginx`.
5. Ajustar el atributo `ipv4_address` en el contenedor `homeassistant` con un IP en el rango no asignable por el DHCP. Por ejemplo 192.168.1.11.
6. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
7. Agregar stack en Portainer desde el navegador.
    1. Acceder a Portainer a través de https://192.168.1.253:9443. Si sale una alerta de seguridad, puede aceptar el riesgo ya que Portainer usa un certificado de SSL autofirmado.
    2. Darle clic en "Get Started" y luego seleccionar "local".
    3. Seleccionar "Stacks" y crear un nuevo stack.
    4. Ponerle nombre "home-assistant" y pegar el contenido del home-assistant-stack.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Portainer y no en el archivo.
8. Acceder a Home Assistant a través de http://192.168.1.11:8123.
9. Usar el asistente para crear una cuenta de usuario y contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
10. Configurar con el asistente nombre de la instancia de Home Assistant y sus datos y preferencias.
11. Escoja si quiere mandar datos de uso a la pagina de Home Assistant.
12. Finalizar el asistente.
13. Configurar Webhook para notificaciones.
    1. Navegar a "Settings" > "Automations & Scenes".
    2. Hacer clic en "Create Automation".
    3. Hacer clic en "Create new Automation".
    4. Hacer clic en "Add Trigger".
    5. Buscar "Webhook" y seleccionar.
    6. Nombrar el trigger "A Problem is reported".
    7. Cambiar el id del webhook a "notify".
    8. Hacer clic en el engrane de configuración y habilitar unicamente "POST" y "Only accessible from the local network".
    9. Hacer clic en "Add Action".
    10. Buscar "send persistent notification" y seleccionar.
    11. Hacer clic en el Menú de la acción y seleccionar "Edit in YAML" y agregar lo siguiente:
        ```yaml
        alias: Notify Web
        service: notify.persistent_notification
        metadata: {}
        data:
            title: Issue found in server!
            message: "Issue in server: {{trigger.json.problem}}"
        ```
    12. Si desea recibir notificaciones en su celular, primero deberá descargar la aplicación a su celular e iniciar sesión en Home Assistant desde él. Después configurar lo siguiente:
    13. Hacer clic en "Add Action".
    14. Buscar "mobile" y seleccionar "Send notification via mobile_app".
    15. Hacer clic en el Menú de la acción y seleccionar "Edit in YAML" y agregar lo siguiente:
        ```yaml
        alias: Notify Mobile
        service: notify.mobile_app_{mobile_name}
        metadata: {}
        data:
            title: Issue found in server!
            message: "Issue in server: {{trigger.json.problem}}"
        ```
    16. Guardar.

[<img width="33.3%" src="buttons/prev-Create shared networks stack.es.svg" alt="Crear stack de redes compartidas">](Create%20shared%20networks%20stack.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create and configure private external traffic stack optional.es.svg" alt="Crear y configurar stack de tráfico externo privado (Opcional)">](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.es.md)

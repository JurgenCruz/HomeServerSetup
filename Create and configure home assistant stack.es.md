# Crear y configurar stack de Home Assistant

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20home%20assistant%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20home%20assistant%20stack.es.md)

Configuraremos el stack de Docker de Home Assistant y levantaremos el stack a través de Portainer. El stack consiste del siguiente contenedor:

- Home Assistant: Motor de automatización del hogar.
- Whisper: Servicio de Voz-a-texto a través de IA.
- Piper: Servicio de Texto-a-voz a través de IA.
- Ollama: Motor de chat con LLM.

## Pasos

1. Ejecutar: `./scripts/create_home_assistant_folder.sh` para generar los directorios de los contenedores en el SSD.
2. Editar el archivo del stack: `nano ./files/home-assistant-stack.yml`.
3. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Ajustar el atributo `ipv4_address` en el contenedor `homeassistant` con un IP en el rango no asignable por el DHCP. Por ejemplo 192.168.1.11.
5. Si tiene una GPU Nvidia, Saltar este paso. Borrar o comentar las secciones no comentadas `whisper` y `piper` y descomentar las secciones comentadas `whisper` y `piper`. Bajo la sección `ollama`, borrar o comentar las propiedades `runtime` y `deploy` por completo.
6. Si lo desea, puede cambiar el modelo del contenedor whisper (`medium-int8`) a uno más pequeño o más grande dependiendo de su hardware. Opciones disponibles: `tiny, base, small, medium, large & turbo`.
7. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
8. Agregar stack en Portainer desde el navegador.
    1. Acceder a Portainer a través de https://192.168.1.253:9443. Si sale una alerta de seguridad, puede aceptar el riesgo ya que Portainer usa un certificado de SSL autofirmado.
    2. Darle clic en "Get Started" y luego seleccionar "local".
    3. Seleccionar "Stacks" y crear un nuevo stack.
    4. Ponerle nombre "home-assistant" y pegar el contenido del home-assistant-stack.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Portainer y no en el archivo.
9. Acceder a Home Assistant a través de http://192.168.1.11:8123.
10. Usar el asistente para crear una cuenta de usuario y contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
11. Configurar con el asistente nombre de la instancia de Home Assistant y sus datos y preferencias.
12. Escoja si quiere mandar datos de uso a la pagina de Home Assistant.
13. Finalizar el asistente.
14. Configurar Webhook para notificaciones.
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
15. Configurar el Asistente por Voz.
    1. Navegar a "Settings" > "Devices & Services".
    2. Hacer clic en "Add Integration".
    3. Buscar "Wyoming Protocol" y seleccionarlo.
    4. Establecer Host a `whisper`.
    5. Establecer Port a `10300`.
    6. Hacer clic en "Submit".
    7. Hacer clic en "Wyoming Protocol".
    8. Hacer clic en "Add Service".
    9. Establecer Host a `piper`.
    10. Establecer Port a `10200`.
    11. Hacer clic en "Submit".
    12. Regresar a "Integrations".
    13. Hacer clic en "Add Integration".
    14. Buscar "Ollama" y seleccionarlo.
    15. Establecer Url a `http://ollama:11434`.
    16. Hacer clic en "Submit".
    17. Hacer clic en "Ollama".
    18. Hacer clic en el botón "..." junto a "http://ollama:11434".
    19. Hacer clic en "Add conversation agent".
    20. Seleccionar el modelo que desee usar. Se recomienda `llama3.2`.
    21. Habilitar "Assist" bajo "Control Home Assistant".
    22. Hacer clic en "Submit".
    23. Si "Ollama Conversation" no muestra "1 service and 1 entity", hacer clic en el mismo butón "..." de antes y hacer clic en "Reload".
    24. Navegar a "Settings" > "Voice Assistants".
    25. Seleccionar "Home Assistant".
    26. Establecer "Conversation agent" a `Ollama Conversation`.
    27. Establecer "Speech-to-text" a `faster-whisper`.
    28. Establecer "Text-to-speech" a `piper`.
    29. Puede cambiar el idioma del Asistente, Voz-a-texto y Texto-a-voz. También puede cambiar la voz para Texto-a-voz.
    30. Hacer clic en "Update".

> [!TIP]
> Si quiere usar un pequeño dispositivo externo para comandos de voz similar a Alexa, mire esta guia para armar su propio Wyoming Satellite: https://www.youtube.com/watch?v=Bd9qlR0mPB0.

> [!TIP]
> Puede probar su nuevo asistente de voz desde su teléfono mobil con la app de Home Assistant. Desde su Dashboard, hacer clic en los "..." en la parte superior y seleccionar "Assistant" para abrir el Asistente.

[<img width="33.3%" src="buttons/prev-Create and configure nextcloud stack.es.svg" alt="Crear y configurar stack de Nextcloud">](Create%20and%20configure%20nextcloud%20stack.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create and configure private external traffic stack optional.es.svg" alt="Crear y configurar stack de tráfico externo privado (Opcional)">](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.es.md)

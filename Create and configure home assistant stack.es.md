# Crear y configurar stack de Home Assistant

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20home%20assistant%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20home%20assistant%20stack.es.md)

Configuraremos el stack de Docker de Home Assistant y levantaremos el stack a través de Portainer. El stack consiste de los siguientes contenedores:

- Home Assistant: Motor de automatización del hogar.
- Z-WaveJS: Controlador de dispositivo Z-Wave.

## Pasos

1. Si no va a usar dispositivos Z-Wave, editar el script: `nano ./scripts/create_home_assistant_folder.sh` y borrar las últimas 3 líneas relacionadas a `zwavejs`. Guardar y salir con `Ctrl + X, Y, Enter`.
2. Ejecutar: `./scripts/create_home_assistant_folder.sh` para generar los directorios de los contenedores en el SSD.
3. Si va a usar dongles usb Zigbee o Z-Wave, asegurarse de conectarlos a su servidor en un puerto usb.
4. Ejecutar: `ls /dev/serial/by-id/` y anotar las rutas a los dongles usb. Por ejemplo `/dev/serial/by-id/usb-Itead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_V2_12345678901234567890123456789012-1234-port0`.
5. Editar el archivo del stack: `nano ./files/home-assistant-stack.yml`.
6. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
7. Ajustar el atributo `ipv4_address` en el contenedor `homeassistant` con un IP en el rango no asignable por el DHCP. Por ejemplo 192.168.1.11.
8. Bajo el contenedor `homeassistant`, bajo `devices`, reemplazar el dispositivo `/dev/serial/by-id/usb-zigbee_dongle` con la ruta de su dongle Zigbee. Si no tiene un dongle Zigbee, borrar la sección `devices` de este contenedor.
9. Bajo el contenedor `zwavejs`, bajo `devices`, reemplazar el dispostivo `/dev/serial/by-id/usb-zwavejs_dongle` con la ruta de su dongle Z-Wave. Si no tiene un dongle Z-Wave, borrar el contenedor entero. Note que el dispositivo está siendo mapeado a `:/dev/zwave`. Esto es importante porque es la ruta por defecto que el servicio va a buscar. Si no la mapea, tendra que configurar manualmente la ruta del dispositivo.
10. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
11. Agregar stack en Portainer desde el navegador.
    1. Acceder a Portainer a través de https://portainer.micasa.duckdns.org.
    2. Darle clic en "Get Started" y luego seleccionar "local".
    3. Seleccionar "Stacks" y crear un nuevo stack.
    4. Ponerle nombre "home-assistant" y pegar el contenido del home-assistant-stack.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Portainer y no en el archivo.
12. Acceder a Home Assistant a través de https://homeassistant.micasa.duckdns.org.
13. Usar el asistente para crear una cuenta de usuario y contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
14. Configurar con el asistente nombre de la instancia de Home Assistant y sus datos y preferencias.
15. Escoja si quiere mandar datos de uso a la pagina de Home Assistant.
16. Finalizar el asistente.
17. Configurar Restful Command para notificaciones.
    1. Editar la configuración de Home Assistant: `nano /Apps/homeassistant/configuration.yaml`.
    2. Agregar la siguiente sección al final del archivo. Reemplazar `{your_token_here}` con el token generado para Home Assistant en Gotify y `micasa` por su dominio registrado en DuckDNS. Registramos un restful command que se comunica con Gotify para mandar notificaciones.
        ```yml
       rest_command:
            notify_through_gotify:
                url: "https://gotify.micasa.duckdns.org/message?token={your_token_here}"
                method: "post"
                content_type: "application/json"
                payload: '{ "title": "{{ title }}", "message": "{{ message }}", "priority": {{ priority }} }'
        ```
    3. Agregar la siguiente sección al final del archivo. Permitimos proxies desde las redes `172.21.1.0/24` y `172.21.4.0/24` que son las redes de `homeassistant` y `ai` respectivamente que configuramos en el stack en Portainer.
        ```yml
        http:
            use_x_forwarded_for: true
            trusted_proxies:
                - 172.21.1.0/24
                - 172.21.4.0/24
        ```
    4. Guardar y salir con `Ctrl + X, Y, Enter`.
    5. De regreso en Home Assistant, navegar a `Developer tools`.
    6. Presionar `Restart`. Ahora puede crear automatizaciones que llamen este servicio y recibir notificaciones a través de Gotify.
18. Configurar el Asistente por Voz.
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
    20. Seleccionar el modelo que desee usar. Se recomienda `qwen2.5:7b-instruct`.
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
19. Configurar la Automatizacion de Zigbee (Solo si tiene un dongle Zigbee).
    1. Navegar a "Settings" > "Devices & Services".
    2. Home Assistant debería detectar automáticamente y sugerir agregar la "Zigbee Home Automation". Agregar la integracion.
    3. Seleccionar de la lista la ruta de su dongle Zigbee y hacer clic en "Submit".
    4. Ahora puede registrar sus dispositivos Zigbee, pero esto está fuera del alcance de esta guía.
20. Configurar la Automatizacion de Z-Wave (Solo si tiene un dongle Z-Wave).
    1. Acceder en otra pestaña a https://zwavejs.myhome.duckdns.org.
    2. Hacer clic en el icono de configuración.
    3. Bajo `General`, habilitar `Auth`. Esto va a cerrar sesión.
    4. Iniciar sesión otra vez usando `admin` y `zwave` como credenciales.
    5. Hacer clic en el icono del candado para cambiar la contraseña. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
    6. De regreso en la página de configuración, Bajo `Z-Wave`, generar las 6 Llaves de Seguridad usando el icono de aleatorio. Respaldar estas llaves en un lugar seguro como Bitwarden.
    7. Escoger su Region de Radiofrecuencia.
    8. Bajo `Home Assistant` habilitar `WS Server` y establecer `Server Host` a `zwavejs`.
    9. Hacer clic en "Save".
    10. De regreso en la pestaña de Home Assistant, navegar a "Settings" > "Devices & Services".
    11. Hacer click en "Add integration".
    12. Buscar por la integracion `Z-Wave`.
    13. Ingresar `ws://zwavejs:3000` y hacer clic en "Submit".
    14. Ahora puede registrar sus dispositivos Z-Wave, pero esto está fuera del alcance de esta guía.

> [!TIP]
> Si quiere usar un pequeño dispositivo externo para comandos de voz similar a Alexa, mire esta guia para armar su propio Wyoming Satellite: https://www.youtube.com/watch?v=Bd9qlR0mPB0.

> [!TIP]
> Puede probar su nuevo asistente de voz desde su teléfono mobil con la app de Home Assistant. Desde su Dashboard, hacer clic en los "..." en la parte superior y seleccionar "Assistant" para abrir el Asistente.

[<img width="33.3%" src="buttons/prev-Create and configure ai stack.es.svg" alt="Crear y configurar stack de IA">](Create%20and%20configure%20ai%20stack.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create and configure private external traffic stack optional.es.svg" alt="Crear y configurar stack de tráfico externo privado (Opcional)">](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.es.md)
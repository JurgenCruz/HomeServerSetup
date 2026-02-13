# Crear y configurar stack de IA

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20ai%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20ai%20stack.es.md)

Configuraremos el stack de Docker de Inteligencia Artificial y levantaremos el stack a través de Portainer. El stack consiste del siguiente contenedor:

- Whisper: Servicio de Voz-a-texto a través de IA.
- Piper: Servicio de Texto-a-voz a través de IA.
- Ollama: Motor de chat con LLM.
- Open WebUI: Plataforma de IA para ejecución local de IA
- ComfyUI: Motor de flujos de trabajo de IA generativa basado en nodos

## Pasos

1. Ejecutar: `./scripts/create_ai_folder.sh` para generar los directorios de los contenedores en el SSD.
2. Editar el archivo del stack: `nano ./files/ai-stack.yml`.
3. Reemplazar `TZ=America/New_York` por el huso horario de su sistema. Puede usar esta lista como referencia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Si tiene una GPU Nvidia, saltar este paso. Borrar o comentar las secciones no comentadas `whisper` y `piper` y descomentar las secciones comentadas `whisper` y `piper`. Bajo las secciones `ollama` y `comfyui`, borrar o comentar las propiedades `runtime` y `deploy` por completo.
5. Si no tiene una GPU Nvidia, bajo la seccion `comfyui`, cambiar la propiedad `image` a `sinfallas/comfyui:0.9.2-intel` si tiene GPU Intel o a `sinfallas/comfyui:0.9.2-amd` si tiene GPU AMD.
6. Si lo desea, puede cambiar el modelo del contenedor whisper (`medium-int8`) a uno más pequeño o más grande dependiendo de su hardware. Opciones disponibles: `tiny, base, small, medium, large & turbo`.
7. Copiar todo el contenido del archivo al portapapeles. Guardar y salir con `Ctrl + X, Y, Enter`.
8. Agregar stack en Portainer desde el navegador.
    1. Acceder a Portainer a través de https://portainer.micasa.duckdns.org.
    2. Darle clic en "Get Started" y luego seleccionar "local".
    3. Seleccionar "Stacks" y crear un nuevo stack.
    4. Ponerle nombre "ai" y pegar el contenido del ai-stack.yml que copió al portapapeles y crear el stack. Desde ahora modificaciones al stack se deben de hacer a través de Portainer y no en el archivo.
9. Configurar ComfyUI.
    1. Acceder a ComfyUI a través de https://comfyui.micasa.duckdns.org.
    2. Darle clic en "Manager".
    3. Darle clic en "Model Manager".
    4. Buscar el modelo que quisiera usar para generacion de imagenes y darle clic en "Install".
    5. Cerrar los dialogos y en el nodo `Load Checkpoint`, cambiar el modelo al que acaba de instalar.
    6. Hacer clic en el menu de archivo y seleccionar `Export (API)` y guardar el archivo en su computadora. Si no ve esta opcion, darle clic en `Settings` y bajo la pestaña de `Comfy`, habilitar `Dev Mode` e intentar de nuevo.
10. Configurar Open WebUI.
    1. Acceder a Open WebUI a través de https://openwebui.micasa.duckdns.org.
    2. Usar el asistente para crear una cuenta de usuario. Se recomienda nuevamente el uso de Bitwarden para lo mismo.
    3. Darle clic en el icono de usuario y seleccionar `Admin Panel`.
    4. Darle clic en la pestaña `Settings`.
    5. Si quiere permitir a más personas crear cuentas, habilitar `Enable New Sign Ups`. Por defecto, un administrador necesita aprobarlo. Si no quiere tener que aprobarlos, cambiar `Default User Role` a `user` y darle clic en `Save`.
    6. Darle clic en la seccion `Connections`.
    7. Deshabilitar `OpenAI API` y habilitar `Ollama API`.
    8. Establecer `http://ollama:11434` como el url.
    9. Darle clic a `Save`.
    10. Darle clic a la seccion `Models`.
    11. Darle clic al icono `Manage Models` en la esquina superior derecha. Aquí puede descargar y borrar modelos de su instancia de ollama. Para Home Assistant, se recomienda descargar `qwen2.5:7b-instruct`. Para conversaciones normales, puede usar `gemma3:12b`, `mistral-nemo:12b` o `qwen3:14b`.
    12. Darle clic a la seccion `Web Search`.
    13. Si quiere permitir que su modelo busque en internet, habilitar `Web Search`. Puede usar `DDGS` como motor de búsqueda con `DuckDuckGo` como proveedor o el motor de su preferencia. Darle clic en `Save`.
    14. Darle clic a la seccion `Images`.
    15. Habilitar `Image Generation`.
    16. Establecer `Model` al nombre de archivo del modelo que descargo en ComfyUI incluyendo la extension.
    17. Establecer `Image Generation Engine` a `ComfyUI`.
    18. Establecer `ComfyUI Base URL` a `http://comfyui:8188`.
    19. Bajo `ComfyUI Workflow` darle clic a `Upload` y subir el archivo que guardo de ComfyUI.
    20. Bajo `ComfyUI Workflow Nodes` necesitará mapear las propiedades a los ids de los nodos. Para una guía detallada referir: https://docs.openwebui.com/features/image-generation-and-editing/comfyui/#identifying-node-ids-and-input-keys-in-comfyui.
    21. Darle clic a `Save`.

[<img width="33.3%" src="buttons/prev-Create and configure arr applications stack.es.svg" alt="Crear y configurar stack de aplicaciones arr">](Create%20and%20configure%20arr%20applications%20stack.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create and configure home assistant stack.es.svg" alt="Crear y configurar stack de Home Assistant">](Create%20and%20configure%20home%20assistant%20stack.es.md)
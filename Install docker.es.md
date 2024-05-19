# Instalar Docker

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Install%20docker.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Install%20docker.es.md)

Instalaremos Docker como nuestro motor de contenedores; opcionalmente instalaremos los controladores de Nvidia y "Nvidia Container Toolkit"; y configuraremos SELinux para asegurar Docker.

## Pasos

1. Ejecutar: `./scripts/docker_setup.sh admin`. Agrega el repositorio de Docker, lo instala, habilita el servicio y agrega al usuario `admin` al grupo `docker`.
2. Ejecutar: `./scripts/selinux_setup.sh`. Habilita SELinux en Docker; reinicia el servicio de Docker para que surtan efecto los cambios; activa las banderas que permite a los contenedores manejar la red y usar el GPU; e instala pólizas de SELinux. Estas son necesarias para algunos contenedores para poder acceder a archivos de Samba y interactuar con WireGuard y para que rsync sea capaz de respaldar las aplicaciones.
3. Opcional: Si tiene una tarjeta Nvidia relativamente moderna, ejecutar: `./scripts/nvidia_setup.sh`. Agrega repositorios de "RPM Fusion" y Nvidia para instalar el controlador y el "Nvidia Container Toolkit" para Docker. También registra la llave de "Akmods" en la cadena de Secure Boot. Es necesario reiniciar y repetir el proceso de enrolar la llave como lo hicimos con ZFS. Después de reiniciar y iniciar sesión, no se olvide de asumir `root` con `sudo -i`.
1. Ejecutar: `./scripts/create_portainer_folder.sh` para generar el directorio del contenedor en el SSD.
4. Ejecutar: `./scripts/run_portainer.sh`. Esto ejecuta un contenedor de Portainer Community Edition y escuchará en el puerto `9443`.
5. Configurar Portainer desde el navegador.
    1. Acceder a Portainer a través de https://192.168.1.253:9443. Si sale una alerta de seguridad, puede aceptar el riesgo ya que Portainer usa un certificado de SSL autofirmado.
    2. Establecer una contraseña aleatoria y crear usuario `admin`. Se recomienda Bitwarden nuevamente para esto.
    3. Navegar a "Environments" > "local" y cambiar "Public IP" con el hostname del servidor `server.lan`.

[<img width="33.3%" src="buttons/prev-Configure shares.es.svg" alt="Configurar shares">](Configure%20shares.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create shared networks stack.es.svg" alt="Crear stack de redes compartidas">](Create%20shared%20networks%20stack.es.md)

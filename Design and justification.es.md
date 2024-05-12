# Diseño y justificación

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Design%20and%20justification.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Design%20and%20justification.es.md)

- Fedora Server: Fedora Server brinda una combinación de estabilidad y modernidad como sistema operativo. Al tener un ciclo de lanzamiento corto podemos tener acceso a tecnologías nuevas y no es necesario hacer una actualización completa como Debian. Al mismo tiempo, no es una distribución de lanzamiento rodante, por lo que no tendremos inestabilidades tras actualizar.
- Sistema entero encriptado: Un sistema seguro y privado requiere evitar la modificación y lectura del sistema sin consentimiento del usuario. Por esto, es necesario encriptar los datos en todos los medios. El SO es encriptado usando LUKS con contraseña, mientras que los discos duros serán encriptados usando encriptación nativa de ZFS con una llave. La llave permanecerá en la partición del SO encriptado, de tal manera que no puede ser accedida sin abrir primero el SO con la contraseña, al mismo tiempo que permite no requerir una segunda contraseña.
- Secure Boot habilitado: Para garantizar la seguridad y privacidad del servidor, es necesario asegurar la cadena de inicio de la computadora. Esto solo se puede lograr con Secure Boot habilitado.
- Sistema de archivos ZFS: ZFS es un sistema de archivos robusto seleccionado por usar COW (copiar durante escritura), acceso a RAIDZ para redundancia de discos, snapshots nativos, encriptación nativa y compresión. Es una de los mejores opciones como sistema de archivos para un NAS.
- Samba shares para múltiples usuarios: Samba permite acceder remotamente a los archivos del NAS de manera segura y compatible con múltiples sistemas operativos. Permite el uso de ACL para definir los permisos para el acceso a los archivos y garantizar la privacidad.
- Docker como motor de contenerización: Docker es el motor de contenerización mas usado y sencillo. Para mantener accesible el servidor, vamos a evitar usar otros motores más complejos como Kubernetes y Podman.
- Ecosistema de aplicaciones ARR: Este grupo de micro servicios brinda un sistema de entretenimiento en casa con acceso a películas y series completamente automatizado y personalizable con una interfaz intuitiva y completo control del mismo.
- Technitium como servidor DNS y DHCP: Technitium nos ayuda a bloquear dominios de publicidad, rastreo y malware al mismo tiempo que nos permite configurar "split horizon DNS" y DHCP en un solo servicio.
- Home Assistant como sistema de automatización del hogar: Home Assistant es de software libre y completamente independiente de la nube, brindando privacidad, seguridad y control completo de su hogar.
- Cockpit como administrador de servidor: Cockpit proporciona una administración remota del servidor desde un solo lugar a través de un navegador web con interfaz grafica para mayor conveniencia.
- Portainer como administrador de contenedores: Aunque Cockpit tiene la capacidad de administrar contenedores, solamente soporta Podman y no Docker. Portainer nos permite administrar los contenedores de manera remota desde un navegador web con una interfaz gráfica, en vez de la terminal, y es compatible con Docker.
- qBittorrent con VPN: El protocolo bittorrent permite acceso a librería muy grande de archivos, distribuida, gratuita y en la mayoría de los casos pública. Para poder mantener la privacidad en linea es necesaria una VPN anónima remota para el protocolo bittorrent.
- WireGuard como protocolo para VPN local: Para poder acceder a sistemas críticos remotamente, es necesario no exponerlos públicamente sino a través de una VPN segura. WireGuard es un protocolo de VPN de código abierto, moderno, seguro y eficiente y es ideal para crear una VPN personal conectada a nuestra red local.
- DuckDNS: DuckDNS ofrece un servicio de DDNS gratuito que además suporta múltiples niveles de subdominio. Por ejemplo: `micasa.duckdns.org` y `jellyfin.micasa.duckdns.org` serán mapeados a el mismo IP. Esto es muy útil ya que nos permite tener subdominios propios que el reverse proxy puede usar en sus reglas.

[<img width="50%" src="buttons/prev-Features.es.svg" alt="Características">](Features.es.md)[<img width="50%" src="buttons/next-Minimum prerequisites.es.svg" alt="Prerequisitos mínimos">](Minimum%20prerequisites.es.md)

<details><summary>Indice</summary>

1. [Objetivo](Objective.es.md)
2. [Motivación](Motivation.es.md)
3. [Características](Features.es.md)
4. [Diseño y justificación](Design%20and%20justification.es.md)
5. [Prerequisitos mínimos](Minimum%20prerequisites.es.md)
6. [Guía](Guide.es.md)
    1. [Instalar Fedora Server](Install%20fedora%20server.es.md)
    2. [Configurar Secure Boot](Configure%20secure%20boot.es.md)
    3. [Instalar y configurar Zsh (Opcional)](Install%20and%20configure%20zsh%20optional.es.md)
    4. [Configurar usuarios](Configure%20users.es.md)
    5. [Instalar ZFS](Install%20zfs.es.md)
    6. [Configurar ZFS](Configure%20zfs.es.md)
    7. [Configurar red del anfitrión](Configure%20hosts%20network.es.md)
    8. [Configurar shares](Configure%20shares.es.md)
    9. [Registrar DDNS](Register%20ddns.es.md)
    10. [Instalar Docker](Install%20docker.es.md)
    11. [Crear stack de Docker](Create%20docker%20stack.es.md)
    12. [Configurar aplicaciones](Configure%20applications.es.md)
    13. [Configurar tareas programadas](Configure%20scheduled%20tasks.es.md)
    14. [Configurar tráfico externo público](Configure%20public%20external%20traffic.es.md)
    15. [Configurar tráfico externo privado](Configure%20private%20external%20traffic.es.md)
    16. [Instalar Cockpit](Install%20cockpit.es.md)
7. [Glosario](Glossary.es.md)

</details>

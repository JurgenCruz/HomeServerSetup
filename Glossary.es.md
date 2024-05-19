# Glosario

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Glossary.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Glossary.es.md)

### Bittorrent

Es un protocolo de comunicación para intercambio de archivos entre pares, es decir, sin un servidor central, que permite compartir datos de manera descentralizada. Se utiliza un servidor llamado rastreador que contiene la lista de archivos disponibles y los clientes que tienen una copia total o parcial del archivo. Un cliente puede usar esta lista para entonces solicitar a otros clientes partes del archivo y reconstruirlo al final. El cliente puede empezar a compartirlo a otros clientes desde el momento en que recibe su primera pieza de manera que se optimice el uso de recursos para no sobrecargar a un solo cliente. Más información: https://en.wikipedia.org/wiki/BitTorrent.

### Certificado SSL

El protocolo SSL (así como su sucesor TLS) utilizan un "Certificado de Llave Pública" para garantizar que la comunicación entre un cliente y un servidor sea segura. Un certificado de llave pública es un documento electrónico usado para probar la validez de una llave pública. Este contiene la llave pública, la identidad del dueño y una firma digital de una entidad que ha verificado el certificado. El certificado es presentado por el servidor al cliente, el cliente valida que el certificado concuerde con la dirección a la que se quiere conectar y que el certificado haya sido firmado por una autoridad confiable (el cliente puede decidir que autoridades son confiables), probando así que el servidor es efectivamente el destino deseado. Más información: https://en.wikipedia.org/wiki/Public_key_certificate.

#### Certificado de dominio comodín

Un certificado de dominio comodín (wildcard domain certificate) es un certificado que no solo cubre el tráfico a un dominio o subdominio especifico, sino también cualquier otro subdominio debajo del dominio especificado en el certificado. Por ejemplo un certificado con el destino *.micasa.duckdns.org cubre micasa.duckdns.org, jellyfin.micasa.duckdns.org, sonarr.micasa.duckdns.org, etc.

### Cockpit

Cockpit es una interfaz gráfica basada en web que permite la administración del servidor de manera remota, en un solo lugar, a través de un explorador web. Cockpit permite administrar usuarios, la red, el almacenamiento, las actualizaciones, SELinux, ZFS, Systemd, el journal, el cortafuegos, las métricas y si no fuera suficiente, tiene una terminal donde se puede hacer todo lo que no se puede hacer gráficamente. Cockpit usa los usuarios y contraseñas de Linux por lo que no es necesario crear una cuenta pero también es muy importante no exponer este servicio públicamente y proteger la contraseña. Mas información: https://cockpit-project.org.

### Contenedores

Es una técnica de virtualización a nivel de sistema operativo para que múltiples aplicaciones puedan ejecutarse en espacios de usuario asilados llamados contenedores con su propio ambiente evitando colisiones con otros contenedores y el mismo SO anfitrión. Mas información: https://en.wikipedia.org/wiki/Containerization_(computing).

### DNS

El Sistema de Nombres de Dominio (Domain Name System) es un sistema para nombrar computadoras de manera jerárquica y distribuida en redes que usan el protocolo IP. Asocia cierta información con "Nombres de Dominio" que son asignadas a las entidades asociadas. El uso más común es el de traducir un nombre de dominio fácilmente memorizable a una dirección IP numérica para localizar una computadora en la red. Es jerárquica ya que los servidores que mapean un dominio pueden delegar un subdominio a otro servidor múltiples niveles hasta llegar al último subdominio. Más información: https://en.wikipedia.org/wiki/Domain_Name_System.

#### Dominio

Es una cadena de caracteres que identifica una esfera de administración autónoma o autoridad o control. Es usualmente usado para identificar servicios proveídos a través del internet. Un nombre de dominio Identifica un dominio de red o a un recurso en una red que usa el protocolo de Internet.

#### Subdominio

Los dominios están organizados en niveles subordinados (subdominios) del dominio raíz del DNS, el cual no tiene nombre. A el primer nivel de dominios se les llama dominios de nivel-superior como "com", "net", "org", etc. Debajo de estos están los dominios de segundo y tercer nivel que están libres para reservación por usuarios que desean conectar su red a la internet y crear recursos públicos como un sitio web.

#### Split Horizon DNS

Si intentamos acceder a un URL con un dominio desde la red local (LAN) al que ese dominio pertenece en vez de una IP local, el DNS público (por ejemplo DuckDNS) nos regresará el IP público de la red y el router no podrá resolverlo, ya que estaremos intentando acceder al IP público desde el mismo IP público. Si configuramos un DNS interno dentro de la red local (por ejemplo Technitium) para que mapee el dominio o incluso subdominios a IPs locales, entonces crearemos una máscara que evitará redireccionar erróneamente las direcciones locales. Cuando un dispositivo es conectado a esta LAN, el DHCP asignará el DNS interno (Technitium) y este interceptará el dominio en vez de preguntarle al DNS público (DuckDNS). Si el mismo dispositivo se conectara fuera de la red local, el cliente DNS llamará a un DNS público (DuckDNS) como siempre, haciendo transparente para los clientes acceder a un dominio desde cualquier red sin necesidad de que el cliente manipule archivos del ordenador o que use el IP local en vez del dominio. A esta técnica se le conoce como DNS de horizonte dividido (Split Horizon DNS).

#### DDNS

Un problema común para los hogares que desean exponerse al tráfico externo es que el IP público puede cambiar en cualquier momento si el ISP así lo desea. Comúnmente solo a las empresas o instituciones se les asigna un IP estático. Si se intenta usar un DNS para mapear un dominio, eventualmente el IP al que apunta expirará y el dominio estará caído. Un DNS dinámico (DDNS) resuelve esto. Todo DDNS (como DuckDNS) requiere de un cliente que lo actualice cada determinado tiempo con el IP público de la red haciendo una llamada (con algún tipo de autenticación, claro) desde adentro de esa red, el DDNS automáticamente detectará el IP público del que se está haciendo la llamada y actualizará el DNS con ese IP.

### DHCP

El Protocolo Dinámico de Configuración de Anfitriones (Dynamic Host Configuration Protocol) es un protocolo de redes parte del Protocolo de Internet (IP) para asignar automáticamente una dirección IP y otros parámetros como la dirección de router y el DNS de la red. Esto elimina la necesidad de configurar manual e individualmente cada dispositivo en la red. El protocolo funciona con servidor DHCP central y un cliente DHCP en cada dispositivo que se quiera conectar. El cliente solicita los parámetros de la red cuando se conecta a la red y periódicamente después de esto usando el protocolo DHCP difundiendo un mensaje a la red en espera que un servidor DHCP lo escuche y le responda. Más información: https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol.

### Firewall

El Cortafuegos (Firewall) es un sistema de seguridad para redes que monitorea y controla el tráfico basado en reglas de seguridad predefinidas que permiten o bloquean el tráfico. Usualmente se utiliza como una barrera entre una red de confianza y una red no confiable (Como el Internet). Más información: https://en.wikipedia.org/wiki/Firewall_(computing).

### IP

Una dirección IP es una etiqueta numérica que es asignada a un dispositivo conectado a una red de computadoras que usa el Protocolo de Internet para comunicarse. Sirve dos propósitos: identificación y direccionamiento. Las versiones mas usadas son IPv4 e IPv6. Más información: https://en.wikipedia.org/wiki/IP_address.

#### IPv4

Una dirección IPv4 consiste de 32 bits. Usualmente es representada con 4 números decimales del 0 al 255 separados por un punto, por ejemplo 192.168.1.0. Cada número representa un grupo de 8 bits. Algunos rangos de IPv4 son comúnmente usados para propósitos especiales como redes privadas.

#### IPv6

En IPv6 se incrementó el tamaño de 32 bits a 128 bits. Esto debido a que el crecimiento exponencial de dispositivos conectados a la internet estaba acabando rápidamente con los IPs disponibles. La notación es normalmente 8 grupos de números de 4 dígitos Hexadecimales separados por `:`. por ejemplo 2001:0db8:85a3:0000:0000:8a2e:0370:7334

#### Máscara de Subred/CIDR

Para poder definir la arquitectura de las redes se usaban originalmente las máscaras de subred, pero poco a poco han sido reemplazadas por CIDR. La idea es dividir la dirección IP en 2 partes: el prefijo de red, que identifica una subred, y el identificador de dispositivo, que identifica un dispositivo único en la subred. Tanto la máscara de subred como el CIDR son maneras de indicar la división del IP. Por ejemplo, la notación CIDR "10.0.0.0/8" denota una subred IPv4 con 8 bits de prefijo (indicado por /8) y 24 bits de identificador (el restante de los 32 bits de IPv4), dando un rango de subred desde 10.0.0.0 hasta 10.255.255.255.

### LUKS

La Configuración Linux de Llave Unificada (Linux Unified Key Setup) es una especificación para encriptación de discos. La encriptación es a nivel de bloques así que cualquier sistema de archivos puede ser encriptado con LUKS. Más información: https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup.

### NAS

El Almacenamiento Conectado a la Red (Network Attached Storage, abreviado NAS) es un servidor de almacenamiento a nivel de archivo (en vez de a nivel de bloque) conectado a una red para proveer acceso a datos a un grupo de clientes. El servidor está optimizado para servir archivos por medio de su configuración de hardware y software. Usualmente ocupan los protocolos para compartir archivos NFS o SMB. Más información: https://en.wikipedia.org/wiki/Network-attached_storage.

### NAT

La Traducción de Direcciones de Red (Network Address Translation) es un método para mapear un rango de direcciones IP a otro. Normalmente se usa en modo "uno a muchos" que permite mapear múltiples clientes privados a un IP público. Los hogares normalmente son asignados un IP público por su proveedor de internet (ISP). Sin embargo, ese IP es compartido por todos los dispositivos del hogar gracias a un router que asigna IPs privados a cada uno de ellos y maneja su tráfico. Esto funciona ya que el tráfico es iniciado desde adentro de la red local y el router puede saber a quien redirigir la respuesta del trafico usando NAT. Más información: https://en.wikipedia.org/wiki/Network_address_translation.

#### Port Forwarding

El Redireccionamiento de Puerto (Port Forwarding) es una aplicación del NAT que traduce una dirección y puerto a otra cuando el tráfico es iniciado desde afuera de la red. Sin esto, el router no tiene manera de saber quien debe recibir la petición (recordemos que el NAT uno a muchos funciona de adentro hacia afuera). Otra manera de resolver esto sería configurar el router para redirigir todo el tráfico iniciado externamente al servidor. Esto no es muy recomendable ya que expondría el servidor a usuarios mal intencionados por ejemplo, a través del puerto SSH. La mejor solución es hacer Port Forwarding unicamente al tráfico recibido en los puertos deseados como el 80 (HTTP) y 443 (HTTPS) hacia el servidor desde el router.

### Reverse Proxy

Un Proxy en Reversa (Reverse Proxy) es una aplicación que se encuentra en medio de un cliente y múltiples servidores y ayuda a redirigir el trafico iniciado por el cliente al servidor correcto. Pueden tener muchos usos, pero en un servidor casero busca solucionar un problema con el Port Forwarding del router. con Port Forwarding podemos exponer unicamente un puerto, sin embargo, no todas las aplicaciones del servidor pueden escuchar en el mismo puerto. Un reverse proxy hace entonces algo similar al NAT pero en reversa y redirecciona el tráfico recibido en el puerto expuesto con Port Forwarding a las diferentes aplicaciones con el puerto correcto. Esto se logra a través de reglas que usan el URL (el subdominio por ejemplo) en la petición para identificar la aplicación a la cual redireccionar el tráfico. Más información: https://en.wikipedia.org/wiki/Reverse_proxy.

### Router

Un Enrutador (Router) es un dispositivo de red que redirecciona paquetes de datos entre redes. Los paquetes son enviados de un router a otro a través de múltiples redes hasta que alcanza su destino. Un router por ende está conectado a dos o más redes a la vez. El router utiliza un tabla de enrutamiento para comparar la dirección del paquete para determinar el siguiente destino en el camino del paquete. Más información: https://en.wikipedia.org/wiki/Router_(computing).

### Samba

Samba es una implementación de código libre del protocolo SMB para compartir archivos e impresoras pensado para clientes Microsoft. Hoy en día tanto Linux como macOS tienen clientes para conectarse a servidores Samba. Samba define recursos compartidos conocidos como shares para directorios definidos en el sistema. Los Samba shares se administran en un archivo de configuración que nos permite definir que directorios compartir, que usuarios tienen acceso a los diferentes shares, y que redes pueden acceder al servidor Samba. Samba usa los mismos usuarios que Linux, pero tiene su propia base de datos de contraseñas. Por eso es necesario asignar una contraseña Samba a cada usuario que se creo para usar los shares. Mas información: https://en.wikipedia.org/wiki/Samba_(software).

### Secure Boot

Inicio Seguro (Secure Boot) es un protocolo definido en la especificación UEFI diseñado para asegurar el proceso de inicio al prevenir cargar controladores UEFI o gestores de arranque que no estén firmados por una llave aceptable. Para habilitarlo se requiere cambiar en el BIOS primero a modo "Setup" para poder configurar nuestras llaves públicas. Para poder cargar un gestor de arranque al inicio se requiere firmar los archivos de la partición `/efi` con la llave privada. Igualmente, para cargar controladores al inicio, es necesario registrar la firma del controlador a la base de datos de firmas confiables. Después es necesario salir del modo "Setup" y habilitar Secure Boot. Normalmente se protege el BIOS con contraseña para impedir su desactivación. Más información: https://en.wikipedia.org/wiki/UEFI#Secure_Boot.

### SELinux

Linux de Seguridad Mejorada (Security-Enhanced-Linux abreviado SELinux) es un módulo de seguridad del kernel Linux que provee un mecanismo para soportar pólizas de seguridad de control de acceso incluyendo Controles de Acceso Mandatorio (MAC). Permite imponer la separación de información basada en los requerimientos de integridad y confidencialidad, confinando el daño que una aplicación maliciosa pudiera causar. Más información: https://en.wikipedia.org/wiki/Security-Enhanced_Linux.

### SMART

SMART, o S.M.A.R.T., es un sistema de monitoreo incluido en discos duros (HDDs) y discos de estado sólido (SSDs). Sirve para detectar y reportar indicadores del estado del disco con el propósito de anticipar una falla inminente en el disco. Esto le da tiempo al usuario de prevenir perdida de datos y reemplazar el disco para continuar con la integridad de los datos. Más información: https://en.wikipedia.org/wiki/Self-Monitoring,_Analysis_and_Reporting_Technology.

#### smartd

Smartd es un daemon parte del paquete "SMART monitor tools" que monitorea de manera configurable el SMART de los diferentes discos del servidor y notifica cuando hay un problema por medio de un script.

### VPN

Una Red Privada Virtual (Virtual Private Network) es un mecanismo para crear una conexión segura entre un dispositivo y una red o entre dos redes usando un medio inseguro como el internet. Esta es creada usando una conexión punto a punto por medio de protocolos de túnel. Una VPN nos permite acceder a nuestra red local como si estuviéramos físicamente conectados a ella. Podremos acceder a servicios que no expusimos públicamente con nuestro Reverse Proxy como Portainer y Cockpit, los cuales son demasiado críticos como para exponer a ataques en la internet publica. Más información: https://en.wikipedia.org/wiki/Virtual_private_network.

#### Split Tunneling

Normalmente una VPN redirecciona todo el trafico de un cliente al través de ella. Es posible configurar la VPN para solo redireccionar trafico en cierto rango de IPs (como su red local) y no redireccionar el resto. Si navega a cualquier otro IP desde ese cliente (por ejemplo a google.com), usará su red normal y por ende el IP público del dispositivo cliente. A esta configuración se le llama Tunelización Dividida (Split Tunneling).

#### WireGuard

Es una implementación de VPN que usa encriptación asimétrica para garantizar que nadie pueda conectarse si no tiene la llave generada por el servidor. Su objetivo es ser una VPN sencilla, rápida, moderna, y eficiente.

### ZFS

Es un sistema de archivos con capacidades de manejo de volúmenes tanto físicos como lógicos. Al tener el conocimiento tanto del sistema de archivos como del disco físico, le permite manejar eficientemente los datos. Está enfocado en garantizar que los datos no se pierdan por errores físicos, errores del sistema operativo o corrupción por el paso del tiempo. Emplea técnicas como COW, snapshots y replicación para mayor robustez. Mas información: https://en.wikipedia.org/wiki/ZFS.

#### COW

Copiar-al-escribir (Copy-on-write abreviado COW) es una técnica en la cual cualquier dato modificado no sobrescribe el dato original sino que es escrito aparte y luego el original puede ser borrado, garantizando que no se pierdan los datos en caso de un error durante la escritura.

#### Snapshots

COW permite retener los bloques viejos que serían descartados en un "instante de tiempo" (Snapshot) que permite restaurar a una versión anterior del dataset. Solo se guarda el diferencial entre dos snapshots por lo que es muy eficiente en términos de espacio.

#### RAID

Es una tecnología que permite combinar múltiples discos físicos en una o más unidades lógicas con el propósito de redundancia de datos, mejora de rendimiento o ambos. ZFS tiene su propia implementación de RAID. En ZFS `raidz` es equivalente a RAID5 que permite tener un disco de redundancia, es decir, puede fallar un solo disco antes de que la alberca pierda datos. Mientras que `raidz2` es equivalente a RAID6 permite 2 discos de redundancia.

[<img width="50%" src="buttons/prev-Configure scheduled tasks.es.svg" alt="Configurar tareas programadas">](Configure%20scheduled%20tasks.es.md)[<img width="50%" src="buttons/jump-Index2.es.svg" alt="Índice">](README.es.md)

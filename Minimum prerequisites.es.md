# Prerequisitos mínimos

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Minimum%20prerequisites.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Minimum%20prerequisites.es.md)

- Una computadora vieja de no más de 7 años.
- Un SSD para el SO.
- Al menos 3 HDDs del mismo tamaño de al menos 6 TB. Recomendado 6 HDDs de 8 TB.
- Mínimo 8GB de RAM. Se recomienda toda la RAM que pueda soportar la tarjeta madre ya que ZFS puede hacer uso de la RAM como cache para mejor desempeño.
- Conexión a internet. Si se desea ver los medios fuera de casa, es recomendable una buena velocidad de subida.
- Una memoria USB de al menos 1 GB para el ISO de Fedora Server.
- Un proveedor de VPN anónima para bittorrent. Se recomienda Mulvad ya que no requiere ninguna información para usar el servicio y la única información que se expone es la IP. El pago se puede hacer con Monero para aún mayor privacidad.
- Opcional: Tarjeta de red Ethernet de 2.5 Gb. Si la tarjeta madre ya tiene un puerto Ethernet de al menos 1 Gb puede omitirse al menos que se desee mejor rendimiento en la transferencia de datos. La guía asume que conectó el servidor al router a través de este puerto Ethernet.
- Opcional: Tarjeta de video capaz de codificación/decodificación de video para aceleración por hardware. La guía asumirá una tarjeta de video Nvidia.
- Opcional: Tarjeta HBA en modo "passthrough" (i.e. no RAID por hardware). Si su tarjeta madre tiene suficientes puertos para todos los discos, no es necesaria. Es importante revisar el manual de la tarjeta madre y ver si soporta la tarjeta de video, la de red (si no está integrada) y el HBA al mismo tiempo, tanto físicamente (tiene las suficientes ranuras para las tarjetas) como lógicamente (soporta las múltiples ranuras al mismo tiempo. Algunas tarjetas madre solo pueden tener cierta combinación de ranuras funcionando al mismo tiempo).
- La guía asume que el usuario está familiarizado con el manual de su tarjeta madre y el BIOS y ha configurado correctamente el BIOS para su hardware.

[<img width="33.3%" src="buttons/prev-Design and justification.es.svg" alt="Diseño y justificación">](Design%20and%20justification.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Guide.es.svg" alt="Guía">](Guide.es.md)

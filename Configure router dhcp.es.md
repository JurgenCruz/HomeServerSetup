# Configurar DHCP del router

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20router%20dhcp.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20router%20dhcp.es.md)

Configuraremos el DHCP del router para usar Technitium como DNS para toda la LAN. Cada router es diferente, así que tendrá que consultar su manual para poder hacer los pasos siguientes.

## Pasos

1. Navegar al portal web de su router.
2. Configurar el DHCP para que use el IP de Technitium como DNS en vez del que el ISP brinda. Puede encontrar el IP de Technitium en Portainer si ve el stack en el editor y ve la configuración del contenedor `technitium`.
3. Ajustar los campos `Starting Address` y `Ending Address` con el rango de IPs de su red local. Asegurarse de dejar algunos IPs no asignables al principio de la red. Por ejemplo si el rango de su red local es 192.168.1.0/24, empiece en 192.168.1.64.
4. Ajustar el campo `Domain Name` a `lan`.
5. Verificar que el DHCP del router esté funcionando (conectar un dispositivo a la red y verificar que se le asignara un IP en el rango configurado y que el DNS sea la IP del servidor).

[<img width="33.3%" src="buttons/prev-Configure technitium dns.es.svg" alt="Configurar DNS de Technitium">](Configure%20technitium%20dns.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create and configure public external traffic stack optional.es.svg" alt="Crear y configurar stack de tráfico externo público (Opcional)">](Create%20and%20configure%20public%20external%20traffic%20stack%20optional.es.md)

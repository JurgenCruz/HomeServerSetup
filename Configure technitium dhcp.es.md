# Configurar DHCP de Technitium

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20technitium%20dhcp.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20technitium%20dhcp.es.md)

Configuraremos Technitium como servidor DHCP para que pueda autoasignarse como DNS ya que el router no nos permite cambiar el DNS del DHCP. Configuraremos el cortafuegos para permitir los puertos necesarios; deshabilitaremos IPv6, ya que complicaría demasiado la configuración; y finalmente, desactivaremos el DHCP del router.

## Pasos

1. Ejecutar: `./scripts/dhcp_firewalld_services.sh`. Configura Firewalld para los contenedores. El script abre el puerto para DHCP para Technitium.
2. Acceder a Technitium a través de https://192.168.1.10/.
3. Hacer clic en la pestaña `DHCP`.
4. Hacer clic en la pestaña `Scopes`.
5. Hacer clic en el botón `Edit`.
6. Ajustar los campos `Starting Address` y `Ending Address` con el rango de IPs de su red local. Asegurarse de dejar algunos IPs no asignables al principio de la red. Por ejemplo si el rango de su red local es 192.168.1.0/24, empiece en 192.168.1.64.
7. Ajustar el campo `Domain Name` a `lan`.
8. Ajustar el campo `Router Address` con el IP de su router.
9. Hacer clic en el botón `Save`.
10. Hacer clic en el botón `Enable` en la fila del scope `Default`.
11. Navegar al portal web de su router.
12. Deshabilitar el DHCP para que no colisione con el de Technitium.
13. Disable IPv6 because Technitium can only do IPv4 with the established configuration and it is more complex to configure it for IPv6.
14. Verificar que el DHCP de Technitium esté funcionando (conectar un dispositivo a la red y verificar que se le asignara un IP en el rango configurado y que el DNS sea la IP del servidor).

[<img width="33.3%" src="buttons/prev-Configure technitium dns.es.svg" alt="Configurar DNS de Technitium">](Configure%20technitium%20dns.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Create and configure public external traffic stack optional.es.svg" alt="Crear y configurar stack de tráfico externo público">](Create%20and%20configure%20public%20external%20traffic%20stack.es.md)

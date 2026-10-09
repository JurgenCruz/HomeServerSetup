# Instalar Cockpit

Finalmente, instalaremos Cockpit con algunos plugins y configuraremos el cortafuegos para permitir el servicio de Cockpit a la red local.

## Pasos

1. Ejecutar: `./scripts/cockpit_setup.sh`. Instala Cockpit y sus plugins ademas de configurar Firewalld para permitir Cockpit en la red.
2. Para probar que funcionó acceder a Cockpit a través de https://server.lan:9090. Usar sus credenciales de `admin`.

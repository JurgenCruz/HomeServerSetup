---
next: false
---

# Configurar DNS

Necesitamos configurar el DNS de nuestra LAN principalmente para "Split Horizon DNS" para poder usar el mismo dominio que registramos en DuckDNS.org tanto dentro como fuera de nuestra LAN. Pero incluso si no desea exponer su servidor a Internet, existen otras razones para configurar el DNS, como habilitar DoH (DNS-over-HTTPS) para toda su LAN y filtrado de dominio para anuncios y malware para toda su LAN. El DNS también se encarga de resolver el dominio `lan` para que podamos usar URL locales como `server.lan` en lugar de la IP.

Dependiendo de su hardware, el DNS se configurará de manera diferente. Por favor seleccione la opción que se ajuste a su situación. Si tiene control total del DNS de su router (por ejemplo, si su router usa OpenWrt), seleccione `Configurar DNS del router`. De lo contrario, seleccione `Configurar DNS Technitium`.

<ChoiceButton title="Configurar DNS del router" href="Configure router dns"></ChoiceButton>
<ChoiceButton title="Configurar DNS Technitium" href="Configure technitium dns"></ChoiceButton>

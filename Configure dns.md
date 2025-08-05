# Configure DNS

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20dns.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20dns.es.md)

We need to configure the DNS of our LAN mainly for split horizon DNS so that we can use the same domain we registered in DuckDNS.org both inside and outside our LAN. But even if you don't want to expose your server to the internet there are other reasons for configuring the DNS like enabling DoH (DNS-over-HTTPS) for your entire LAN and domain filtering for ads and malware for the entire LAN. The DNS is also in charge of resolving the `lan` domain so that we can use local URLs like `server.lan` instead of the IP.

Depending on your hardware the DNS will be configured differently. Please select the option that matches your situation. If you have full control of your router's DNS (for example if your router uses OpenWrt), select `Configure router DNS`. Otherwise, select `Configure Technitium DNS`.

[<img width="100%" src="buttons/jump-Configure router dns.svg" alt="Configure router DNS">](Configure%20router%20dns.md)
[<img width="100%" src="buttons/jump-Configure technitium dns.svg" alt="Configure Technitium DNS">](Configure%20technitium%20dns.md)
[<img width="33.3%" src="buttons/prev-Create shared networks stack.svg" alt="Create shared networks stack">](Create%20shared%20networks%20stack.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Configure router dns.svg" alt="Configure router DNS">](Configure%20router%20dns.md)
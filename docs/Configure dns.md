---
next: false
---

# Configure DNS

We need to configure the DNS of our LAN mainly for split horizon DNS so that we can use the same domain we registered in DuckDNS.org both inside and outside our LAN. But even if you don't want to expose your server to the internet there are other reasons for configuring the DNS like enabling DoH (DNS-over-HTTPS) for your entire LAN and domain filtering for ads and malware for the entire LAN. The DNS is also in charge of resolving the `lan` domain so that we can use local URLs like `server.lan` instead of the IP.

Depending on your hardware the DNS will be configured differently. Please select the option that matches your situation. If you have full control of your router's DNS (for example if your router uses OpenWrt), select `Configure router DNS`. Otherwise, select `Configure Technitium DNS`.

<ChoiceButton title="Configure router DNS" href="Configure router dns"></ChoiceButton>
<ChoiceButton title="Configure Technitium DNS" href="Configure technitium dns"></ChoiceButton>

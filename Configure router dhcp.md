# Configure router DHCP

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20router%20dhcp.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20router%20dhcp.es.md)

We will configure the DHCP of the router to use Technitium as DNS for all the LAN. Each router is different, so you will have to consult your manual to be able to do the following steps.

## Steps

1. Navigate to your router's web portal.
2. Configure the DHCP to use Technitium's IP as DNS server instead of the one provided by the ISP. You can find Technitium's IP in Portainer if you view the stack in the editor and look at the `technitium` container configuration.
3. Set the `Starting Address` and `Ending Address` fields with the IP range of your local network. Make sure to leave some IPs unassignable at the beginning of the network. For example if your local network range is 192.168.1.0/24, start at 192.168.1.64.
4. Set the `Domain Name` field to `lan`.
5. Verify that the router's DHCP is working (connect a device to the network and verify that it was assigned an IP in the configured range and that the DNS is the server's IP).

[<img width="33.3%" src="buttons/prev-Configure technitium dns.svg" alt="Configure Technitium DNS">](Configure%20technitium%20dns.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Create and configure public external traffic stack optional.svg" alt="Create and configure public external traffic stack (Optional)">](Create%20and%20configure%20public%20external%20traffic%20stack%20optional.md)

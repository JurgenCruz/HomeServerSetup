# Configure Technitium DHCP

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20technitium%20dhcp.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20technitium%20dhcp.es.md)

We will configure Technitium as a DHCP server so that it is able to assign itself as DNS since the router won't allow us to change the DNS of the DHCP. We will configure the firewall to allow the necessary ports; we will disable IPv6 as it would complicate the configuration too much; and finally, we will disable the router's DHCP.

## Steps

1. Run: `./scripts/dhcp_firewalld_services.sh`. Configure Firewalld for containers. The script opens the port for DHCP for Technitium.
2. Access Technitium through https://192.168.1.10/.
3. Click the `DHCP` tab.
4. Click the `Scopes` tab.
5. Click the `Edit` button.
6. Set the `Starting Address` and `Ending Address` fields with the IP range of your local network. Make sure to leave some IPs unassignable at the beginning of the network. For example if your local network range is 192.168.1.0/24, start at 192.168.1.64.
7. Set the `Domain Name` field to `lan`.
8. Set the `Router Address` field with the IP of your router.
9. Click the `Save` button.
10. Click the `Enable` button on the `Default` scope row.
11. Navigate to your router's web portal.
12. Disable DHCP so that it won't collide with Technitium's.
13. Deshabilitar IPv6 porque Technitium solo puede hacer IPv4 con la configuración establecida y es mas complejo configurarlo para IPv6.
14. Verify that the Technitium's DHCP is working (connect a device to the network and verify that it was assigned an IP in the configured range and that the DNS is the server's IP).

[<img width="33.3%" src="buttons/prev-Configure technitium dns.svg" alt="Configure Technitium DNS">](Configure%20technitium%20dns.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Create and configure public external traffic stack optional.svg" alt="Create and configure public external traffic stack (Optional)">](Create%20and%20configure%20public%20external%20traffic%20stack%20optional.md)

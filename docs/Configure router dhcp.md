---
next:
  text: "Create and configure public external traffic stack"
  link: ./Create and configure public external traffic stack
---

# Configure router DHCP

We will configure the DHCP of the router to use Technitium as DNS for all the LAN. Each router is different, so you will have to consult your manual to be able to do the following steps.

## Steps

1. Navigate to your router's web portal.
2. Configure the DHCP to use Technitium's IP as DNS server instead of the one provided by the ISP. You can find Technitium's IP in Arcane if you view the stack in the editor and look at the `technitium` container configuration.
3. Set the `Starting Address` and `Ending Address` fields with the IP range of your local network. Make sure to leave some IPs unassignable at the beginning of the network. For example if your local network range is 192.168.1.0/24, start at 192.168.1.64.
4. Set the `Domain Name` field to `lan`.
5. Verify that the router's DHCP is working (connect a device to the network and verify that it was assigned an IP in the configured range and that the DNS is the server's IP).

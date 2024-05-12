# Configure private external traffic

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20private%20external%20traffic.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20private%20external%20traffic.es.md)

WireGuard has actually already been configured in the Portainer stack and should already be running the VPN. The only thing left is to configure the clients that are going to connect to it. This can be done in 2 ways: through a QR code or through a `.conf` file. Once connected to this VPN, we will be able to access services that we did not expose publicly with our Reverse Proxy such as Portainer and Cockpit, which are too critical to expose to attacks on the public internet.

> [!NOTE]
> WireGuard was configured with split tunneling. If you want to redirect all client traffic, then you must change the `ALLOWEDIPS` variable in the stack in Portainer to `0.0.0.0/0`.

## Steps

1. If you want to configure with a QR code, do the following:
    1. Access Portainer on your local network from a device that is not the client you are configuring.
    2. Navigate to `local` > `Containers`.
    3. In the `wireguard` container row press the `exec console` button.
    4. Press `Connect`.
    5. Show the QR code for the client `phone` in the console with: `/app/show-peer phone`.
    6. From the device that will be the `phone` client (your cell phone for example), open the WireGuard application and select `Add tunnel`.
    7. Choose `Scan QR code` and scan the code that was displayed on the console.
    8. If you want to test that it works correctly, disconnect your device from the local network (turn off Wi-Fi for example) and enable the VPN. Try to access an IP on your local network.
2. If you want to configure with a configuration file, do the following (Note: the guide assumes a Linux device that already has the `wireguard-tools` package or equivalent installed. For other OS, please read the WireGuard documentation):
    1. Connect to the server from the device that will be the client with SSH: `ssh admin@server.lan` .
    2. We show the configuration for the `laptop` client: `sudo cat /Apps/wireguard/peer_laptop/peer_laptop.conf`.
    3. Copy the contents of the file to the clipboard.
    4. Return to the client device console with `exit` or open a new console.
    5. We create the configuration file for a virtual network with the name `wg0`: `sudo nano /etc/wireguard/wg0.conf`.
    6. Paste the contents of the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
    7. If you want to test that it works correctly, disconnect your device from the local network (connect to your guest Wi-Fi network or from the public network of a cafe or use your cell phone as a modem) and enable the virtual network `wg0` with : `wg-quick up wg0`. Try to access an IP on your local network.

[<img width="50%" src="buttons/prev-Configure public external traffic.svg" alt="Configure public external traffic">](Configure%20public%20external%20traffic.md)[<img width="50%" src="buttons/next-Install cockpit.svg" alt="Install Cockpit">](Install%20cockpit.md)

<details><summary>Index</summary>

1. [Objective](Objective.md)
2. [Motivation](Motivation.md)
3. [Features](Features.md)
4. [Design and justification](Design%20and%20justification.md)
5. [Minimum prerequisites](Minimum%20prerequisites.md)
6. [Guide](Guide.md)
    1. [Install Fedora Server](Install%20fedora%20server.md)
    2. [Configure Secure Boot](Configure%20secure%20boot.md)
    3. [Install and configure Zsh (Optional)](Install%20and%20configure%20zsh%20optional.md)
    4. [Configure users](Configure%20users.md)
    5. [Install ZFS](Install%20zfs.md)
    6. [Configure ZFS](Configure%20zfs.md)
    7. [Configure host's network](Configure%20hosts%20network.md)
    8. [Configure shares](Configure%20shares.md)
    9. [Register DDNS](Register%20ddns.md)
    10. [Install Docker](Install%20docker.md)
    11. [Create Docker stack](Create%20docker%20stack.md)
    12. [Configure applications](Configure%20applications.md)
    13. [Configure scheduled tasks](Configure%20scheduled%20tasks.md)
    14. [Configure public external traffic](Configure%20public%20external%20traffic.md)
    15. [Configure private external traffic](Configure%20private%20external%20traffic.md)
    16. [Install Cockpit](Install%20cockpit.md)
7. [Glossary](Glossary.md)

</details>

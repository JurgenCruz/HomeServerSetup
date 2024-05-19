# Install Cockpit

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Install%20cockpit.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Install%20cockpit.es.md)

Finally we will install Cockpit with some plugins and configure the firewall to allow the Cockpit service to the local network.

## Steps

1. Run: `./scripts/cockpit_setup.sh`. Installs Cockpit and its plugins and configures Firewalld to allow Cockpit on the network.
2. To test that it worked, access Cockpit through https://server.lan:9090. Use your `admin` credentials.

[<img width="33.3%" src="buttons/prev-Install and configure zsh optional.svg" alt="Install and configure Zsh (Optional)">](Install%20and%20configure%20zsh%20optional.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Register ddns optional.svg" alt="Register DDNS (Optional)">](Register%20ddns%20optional.md)

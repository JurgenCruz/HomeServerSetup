# Install Cockpit

Finally, we will install Cockpit with some plugins and configure the firewall to allow the Cockpit service to the local network.

## Steps

1. Run: `./scripts/cockpit_setup.sh`. Installs Cockpit and its plugins and configures Firewalld to allow Cockpit on the network.
2. To test that it worked, access Cockpit through https://server.lan:9090. Use your `admin` credentials.

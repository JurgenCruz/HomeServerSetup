# Register DDNS (Optional)

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Register%20ddns.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Register%20ddns.es.md)

If you do not plan to access your server outside of your local network, or if you have a static public IP and your own domain, you can skip this section.

This guide will use the DuckDNS.org service as DDNS in order to map a subdomain to our server. We will register a subdomain on DuckDNS.org and configure our server to update the IP on DuckDNS.org.

## Steps

1. Register a subdomain on DuckDNS.org.
    1. Access and create an account at https://www.duckdns.org/.
    2. Register a subdomain of your preference. Write down the generated token because we are going to need it next.
2. Copy the script that updates the DDNS with our public IP to `sbin`: `cp ./scripts/duck.sh /usr/local/sbin/`.
3. Edit the script: `nano /usr/local/sbin/duck.sh`. Replace `XXX` with the subdomain we registered and `YYY` with the token we generated during registration. Save and exit with `Ctrl + X, Y, Enter`.
4. We change the permissions of the script so that only `root` can access it: `chmod 700 /usr/local/sbin/duck.sh`. The script contains our token, which is the only thing that allows only us to change the IP to which the subdomain points, hence the importance of securing it.

[<img width="33.3%" src="buttons/prev-Install cockpit.svg" alt="Install Cockpit">](Install%20cockpit.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Configure users.svg" alt="Configure users">](Configure%20users.md)

# Glossary

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Glossary.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Glossary.es.md)

### Bittorrent

It is a communication protocol for peer-to-peer file sharing, that is, without a central server, which allows data to be shared in a decentralized manner. It uses a server called a tracker that contains the list of available files and clients that have a full or partial copy of the file. A client can use this list to then request parts of the file from other clients and rebuild it at the end. The client can start sharing it with other clients from the moment they receive their first piece so that the use of resources is optimized so as not to overload a single client. More information: https://en.wikipedia.org/wiki/BitTorrent.

### SSL Certificate

The SSL protocol (as well as its successor TLS) use a "Public Key Certificate" to ensure that communication between a client and a server is secure. A public key certificate is an electronic document used to prove the validity of a public key. This contains the public key, the identity of the owner and a digital signature of an entity that has verified the certificate. The certificate is presented by the server to the client, the client validates that the certificate matches the address to which it wants to connect and that the certificate has been signed by a trusted authority (the client can decide which authorities are trustworthy), thus proving that the server is indeed the desired destination. More information: https://en.wikipedia.org/wiki/Public_key_certificate.

#### Wildcard domain certificate

A wildcard domain certificate is a certificate that not only covers traffic to a specific domain or subdomain, but also any other subdomains below the domain specified in the certificate. For example a certificate with the destination *.myhome.duckdns.org covers myhome.duckdns.org, jellyfin.myhome.duckdns.org, sonarr.myhome.duckdns.org, etc.

### Cockpit

Cockpit is a web-based graphical interface that allows server administration remotely, in one place, through a web browser. Cockpit allows you to manage users, the network, storage, updates, SELinux, ZFS, Systemd, the journal, the firewall, the metrics and if that were not enough, it has a terminal where you can do everything that cannot be done graphically. Cockpit uses Linux users and passwords so it is not necessary to create an account but it is also very important not to expose this service publicly and protect the password. More information: https://cockpit-project.org.

### Containers

It is a virtualization technique at the operating system level so that multiple applications can run in isolated user spaces called containers with their own environment, avoiding collisions with other containers and the same host OS. More information: https://en.wikipedia.org/wiki/Containerization_(computing).

### DNS

The Domain Name System is a system for naming computers in a hierarchical and distributed manner on networks that use the IP protocol. Associates certain information with "Domain Names" that are assigned to the associated entities. The most common use is to translate an easily memorized domain name into a numerical IP address to locate a computer on the network. It is hierarchical since the servers that map a domain can delegate a subdomain to another server multiple levels until reaching the last subdomain. More information: https://en.wikipedia.org/wiki/Domain_Name_System.

#### Domain

It is a string of characters that identifies a sphere of autonomous administration or authority or control. It is usually used to identify services provided over the Internet. A domain name identifies a network domain or resource on a network that uses the Internet protocol.

#### Subdomain

Domains are organized into subordinate levels (subdomains) of the root DNS domain, which has no name. The first level of domains are called top-level domains such as "com", "net", "org", etc. Below these are second and third level domains that are available for reservation by users who want to connect their network to the Internet and create public resources such as a website.

#### Split Horizon DNS

If we try to access a URL with a domain from the local network (LAN) to which that domain belongs instead of a local IP, the public DNS (for example DuckDNS) will return the public IP of the network and the router will not be able to resolve it, since we will be trying to access the public IP from the same public IP. If we configure an internal DNS within the local network (for example Technitium) to map the domain or even subdomains to local IPs, then we will create a mask that will avoid erroneously redirecting local addresses. When a device is connected to this LAN, DHCP will assign the internal DNS (Technitium) and it will intercept the domain instead of asking the public DNS (DuckDNS). If the same device were to connect outside the local network, the DNS client will call a public DNS (DuckDNS) as usual, making it transparent for clients to access a domain from any network without the need for the client to manipulate files on the computer or use the local IP instead of the domain. This technique is known as Split Horizon DNS.

#### DDNS

A common problem for homes that want to expose themselves to external traffic is that the public IP can change at any time if the ISP so wishes. Commonly only companies or institutions are assigned a static IP. If you try to use DNS to map a domain, eventually the IP it points to will expire and the domain will be down. A dynamic DNS (DDNS) solves this. Every DDNS (like DuckDNS) requires a client to update it from time to time with the public IP of the network by making a call (with some type of authentication, of course) from within that network, the DDNS will automatically detect the public IP of which the call is being made and it will update the DNS with that IP.

### DHCP

Dynamic Host Configuration Protocol is a networking protocol part of the Internet Protocol (IP) to automatically assign an IP address and other parameters such as the router address and DNS of the network. This eliminates the need to manually and individually configure each device on the network. The protocol works with a central DHCP server and a DHCP client on each device that wants to connect. The client requests network parameters when it connects to the network and periodically thereafter using the DHCP protocol broadcasting a message to the network waiting for a DHCP server to listen and respond. More information: https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol.

### Firewall

The Firewall is a network security system that monitors and controls traffic based on predefined security rules that allow or block traffic. It is usually used as a barrier between a trusted network and an untrusted network (such as the Internet). More information: https://en.wikipedia.org/wiki/Firewall_(computing).

### IP

An IP address is a numerical label that is assigned to a device connected to a computer network that uses the Internet Protocol to communicate. It serves two purposes: identification and addressing. The most used versions are IPv4 and IPv6. More information: https://en.wikipedia.org/wiki/IP_address.

#### IPv4

An IPv4 address consists of 32 bits. It is usually represented with 4 decimal numbers from 0 to 255 separated by a period, for example 192.168.1.0. Each number represents a group of 8 bits. Some IPv4 ranges are commonly used for special purposes such as private networks.

#### IPv6

In IPv6 the size was increased from 32 bits to 128 bits. This is because the exponential growth of devices connected to the Internet was quickly depleting available IPs. The notation is normally 8 groups of 4-digit Hexadecimal numbers separated by `:`. for example 2001:0db8:85a3:0000:0000:8a2e:0370:7334

#### Subnet Mask/CIDR

In order to define the architecture of the networks, subnet masks were originally used, but little by little they have been replaced by CIDR. The idea is to split the IP address into 2 parts: the network prefix, which identifies a subnet, and the device identifier, which identifies a unique device on the subnet. Both the subnet mask and the CIDR are ways of indicating the IP division. For example, the CIDR notation "10.0.0.0/8" denotes an IPv4 subnet with 8 prefix bits (denoted by /8) and 24 identifier bits (the remainder of the 32 IPv4 bits), giving a subnet range from 10.0.0.0 to 10.255.255.255.

### LUKS

The Linux Unified Key Setup is a specification for disk encryption. The encryption is at the block level so any file system can be encrypted with LUKS. More information: https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup.

### NAS

Network Attached Storage (NAS) is a file-level (rather than block-level) storage server connected to a network to provide data access to a group of clients. The server is optimized to serve files through its hardware and software configuration. They usually use the NFS or SMB file sharing protocols. More information: https://en.wikipedia.org/wiki/Network-attached_storage.

### NAT

Network Address Translation is a method of mapping one range of IP addresses to another. It is typically used in "one-to-many" mode which allows multiple private clients to be mapped to a public IP. Homes are typically assigned a public IP by their Internet Service Provider (ISP). However, that IP is shared by all the devices in the home thanks to a router that assigns private IPs to each of them and manages their traffic. This works because the traffic is initiated from within the local network and the router can know who to redirect the response traffic to using NAT. More information: https://en.wikipedia.org/wiki/Network_address_translation.

#### Port Forwarding

Port Forwarding is an application of NAT that translates one address and port to another when traffic is initiated from outside the network. Without this, the router has no way of knowing who should receive the request (remember that one-to-many NAT works from the inside out). Another way to solve this would be to configure the router to redirect all externally initiated traffic to the server. This is not highly recommended as it would expose the server to malicious users, for example, through the SSH port. The best solution is to port forward only the traffic received on the desired ports such as 80 (HTTP) and 443 (HTTPS) to the server from the router.

### Reverse Proxy

A Reverse Proxy is an application that sits between a client and multiple servers and helps redirect traffic initiated by the client to the correct server. They can have many uses, but in a home server it seeks to solve a problem with the router's port forwarding. With port forwarding we can expose only one port, however, not all server applications can listen on the same port. A reverse proxy then does something similar to NAT but in reverse and redirects the traffic received on the port exposed with port forwarding to the different applications with the correct port. This is achieved through rules that use the URL (the subdomain for example) in the request to identify the application to which to redirect the traffic. More information: https://en.wikipedia.org/wiki/Reverse_proxy.

### Router

A Router is a network device that redirects data packets between networks. Packets are sent from one router to another across multiple networks until they reach their destination. A router is therefore connected to two or more networks at the same time. The router uses a routing table to compare the address of the packet to determine the next destination on the packet's path. More information: https://en.wikipedia.org/wiki/Router_(computing).

### Samba

Samba is an open source implementation of the SMB file and printer sharing protocol intended for Microsoft clients. Today both Linux and macOS have clients to connect to Samba servers. Samba defines shared resources known as shares for directories defined on the system. Samba shares are managed in a configuration file that allows us to define which directories to share, which users have access to the different shares, and which networks can access the Samba server. Samba uses the same users as Linux, but has its own password database. That is why it is necessary to assign a Samba password to each user created to use the shares. More information: https://en.wikipedia.org/wiki/Samba_(software).

### SecureBoot

Secure Boot is a protocol defined in the UEFI specification designed to secure the boot process by preventing loading UEFI drivers or bootloaders that are not signed by an acceptable key. To enable it, you must first change the BIOS to "Setup" mode in order to configure our public keys. Being able to load a bootloader at boot requires signing the files on the `/efi` partition with the private key. Likewise, to load drivers at startup, it is necessary to register the driver signature to the trusted signature database. Then it is necessary to exit "Setup" mode and enable Secure Boot. The BIOS is normally password protected to prevent deactivation. More information: https://en.wikipedia.org/wiki/UEFI#Secure_Boot.

### SELinux

Security-Enhanced-Linux (abbreviated SELinux) is a security module of the Linux kernel that provides a mechanism to support access control security policies including Mandatory Access Controls (MAC). It allows imposing the separation of information based on integrity and confidentiality requirements, limiting the damage that a malicious application could cause. More information: https://en.wikipedia.org/wiki/Security-Enhanced_Linux.

### SMART

SMART, or S.M.A.R.T., is a monitoring system included in hard drives (HDDs) and solid state drives (SSDs). It is used to detect and report disk status indicators in order to anticipate an imminent disk failure. This gives the user time to prevent data loss and replace the drive to maintain data integrity. More information: https://en.wikipedia.org/wiki/Self-Monitoring,_Analysis_and_Reporting_Technology.

#### smartd

Smartd is a daemon part of the "SMART monitor tools" package that in a configurable way monitors the SMART of the different server disks and notifies when there is a problem through a script.

### VPN

A Virtual Private Network is a mechanism to create a secure connection between a device and a network or between two networks using an insecure medium such as the Internet. This is created using a point-to-point connection through tunneling protocols. A VPN allows us to access our local network as if we were physically connected to it. We will be able to access services that we did not expose publicly with our Reverse Proxy such as Portainer and Cockpit, which are too critical to expose to attacks on the public internet. More information: https://en.wikipedia.org/wiki/Virtual_private_network.

#### Split Tunneling

Typically a VPN redirects all of a client's traffic through it. It is possible to configure the VPN to only redirect traffic in a certain range of IPs (such as your local network) and not redirect the rest. If you browse to any other IP from that client (for example to google.com), it will use its normal network and therefore the public IP of the client device. This configuration is called Split Tunneling.

#### WireGuard

It is a VPN implementation that uses asymmetric encryption to ensure that no one can connect without the server-generated key. Its goal is to be a simple, fast, modern, and efficient VPN.

### ZFS

It is a file system with both physical and logical volume management capabilities. Having knowledge of both the file system and the physical disk allows it to efficiently manage data. It is focused on ensuring that data is not lost due to physical errors, operating system errors, or corruption over time. It employs techniques such as COW, snapshots and replication for greater robustness. More information: https://en.wikipedia.org/wiki/ZFS.

#### COW

Copy-on-write (abbreviated COW) is a technique in which any modified data does not overwrite the original data but is written separately and then the original can be deleted, ensuring that the data is not lost in case of an error while writing.

#### Snapshots

COW allows retaining old blocks that would be discarded in a "snapshot" that allows restoring to a previous version of the dataset. Only the differential between two snapshots is saved so it is very efficient in terms of space.

#### RAID

It is a technology that allows multiple physical disks to be combined into one or more logical drives for the purpose of data redundancy, performance improvement, or both. ZFS has its own RAID implementation. In ZFS `raidz` is equivalent to RAID5 which allows you to have one redundant disk, that is, a single disk can fail before the pool loses data. While `raidz2` is equivalent to RAID6 it allows 2 redundant disks.

[<img width="50%" src="buttons/prev-Configure scheduled tasks.svg" alt="Configure scheduled tasks">](Configure%20scheduled%20tasks.md)[<img width="50%" src="buttons/jump-Index2.svg" alt="Index">](README.md)

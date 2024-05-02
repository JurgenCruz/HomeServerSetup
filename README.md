# NAS, Media Center and Home Automation Server

[![en](https://img.shields.io/badge/lang-en-blue.svg)](https://github.com/jurgencruz/homeserversetup/blob/master/README.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](https://github.com/jurgencruz/homeserversetup/blob/master/README.es.md)

This is a guide on how to set up a home server from scratch. If you are not familiar with a concept, the guide provides
a glossary at the end of the guide for your convenience.

## Index

1. [Objective](#1-objective)
2. [Motivation](#2-motivation)
3. [Features](#3-features)
4. [Design and justification](#4-design-and-justification)
5. [Minimum prerequisites](#5-minimum-prerequisites)
6. [Guide](#6-guide)
    1. [Install Fedora Server](#61-install-fedora-server)
    2. [Configure Secure Boot](#62-configure-secure-boot)
    3. [Install and configure Zsh (Optional)](#63-install-and-configure-zsh-optional)
    4. [Configure users](#64-configure-users)
    5. [Install ZFS](#65-install-zfs)
    6. [Configure ZFS](#66-configure-zfs)
    7. [Configure host's network](#67-configure-hosts-network)
    8. [Configure shares](#68-configure-shares)
    9. [Register DDNS](#69-register-ddns)
    10. [Install Docker](#610-install-docker)
    11. [Prepare Pi-hole configuration](#611-prepare-pi-hole-configuration)
    12. [Create Docker stack](#612-create-docker-stack)
    13. [Configure applications](#613-configure-applications)
    14. [Configure scheduled tasks](#614-configure-scheduled-tasks)
    15. [Configure public external traffic](#615-configure-public-external-traffic)
    16. [Configure private external traffic](#616-configure-private-external-traffic)
    17. [Install Cockpit](#617-install-cockpit)
7. [Glossary](#7-glossary)
8. [Buy me a coffee](#8-buy-me-a-coffee)

## 1. Objective

Set up a simple, accessible, secure, cheap and useful home server.

## 2. Motivation

When I started my home server I started with an already established product: TrueNAS Scale. It worked really well but
right from the start I felt limited. TrueNAS does not support Full System Encryption. I decided to compromise as the
data itself could be encrypted, no big deal.

I then tried using the native TrueNAS Apps to set up my media center but some of them were not working. Following a few
guides, I stumbled upon a third party catalog of apps called TrueCharts. I gave them a shot and the apps were working
this time. I had to jump several hoops, but I finally had it working. Except, a few months later, it broke. I had to
join the TrueCharts Discord server and subscribe to their announcement channel because they introduced breaking changes
and users had to follow some instructions to fix their system. I thought "OK, fair enough. This should be a rare
occurrence". Turns out, it was more regular than I expected.

As months passed, I noticed several people complaining about TrueCharts breaking too often. I also noticed that there
was some kind of feud or at least some tension between the devs of TrueCharts and TrueNAS. I seldomly needed help during
a breakage from TrueCharts team and asked help in the Discord server, and while I did get support, the attitude of some
of the persons was rude. I endured it as my home server was on the line and I needed to get it running.

At one point I needed to do a sensitive operation on my server and I once again asked for help. I wanted to be very sure
that I was not going to break my system and lose precious data. I asked a lot of questions but the responses I was
getting were basically "Just follow the guide" in a condescending and elitist tone. While I can follow a guide blindly,
I would prefer to understand what is happening to my system. Specially if the guide asks you to run commands that you
don't know what they do. Things did not end well and I decided that was the last time I used their products.

That is also when I decided I was going to make my own server and not depend on a single entity, and here we are now.

## 3. Features

- Secure.
- Private.
- Robust.
- Resilient.
- File backup and remote access to them.
- Media service.
- Home automation.
- Server administration through a browser and graphical interface.
- Use free and open source.

## 4. Design and justification

- Fedora Server: Fedora Server provides a combination of stability and modernity as an operating system. By having a
  short release cycle we can have access to new technologies and it is not necessary to do a complete update like
  Debian. At the same time, it is not a rolling release distribution, so we will not have instabilities after updating.
- Entire system encryption: A secure and private system requires avoiding modification and reading of the system without
  user consent. This is why it is necessary to encrypt data on all media. The OS is encrypted using LUKS with a
  password, while the hard drives will be encrypted using native ZFS encryption with a key. The key will remain in the
  encrypted OS partition, such that it cannot be accessed without first unlocking the OS with the password, while also
  allowing not to require a second password.
- Secure Boot enabled: To ensure the security and privacy of the server, it is necessary to secure the computer's boot
  chain. This can only be achieved with Secure Boot enabled.
- ZFS File system: ZFS is a robust file system selected for using COW (copy-on-write), RAIDZ feature for disk
  redundancy, native snapshots, native encryption and compression. It is one of the best options as a file system for a
  NAS.
- Samba shares for multiple users: Samba allows remote access to NAS files securely and compatible with multiple
  operating systems. Allows the use of ACLs to specify file access permissions and ensure privacy.
- Docker as a containerization engine: Docker is the most used and simplest containerization engine. To keep the server
  accessible, we are going to avoid using other more complex engines such as Kubernetes and Podman.
- ARR application ecosystem: This group of microservices provides a home entertainment system with access to movies and
  series that is completely automated and customizable with an intuitive interface and complete control.
- Pi-hole as DNS and DHCP server: Pi-hole helps us block domains from advertising, tracking and malware while allowing
  us to configure split horizon DNS and DHCP in a single service.
- Home Assistant as a home automation system: Home Assistant is free software and completely independent of the cloud,
  providing privacy, security and complete control of your home.
- Cockpit as server manager: Cockpit provides a one stop remote server administration through a web browser with a
  graphical user interface for greater convenience.
- Portainer as a container manager: Although Cockpit has the ability to manage containers, it only supports Podman and
  not Docker. Portainer allows us to manage containers remotely from a web browser with a graphical interface, instead
  of the terminal, and is compatible with Docker.
- qBittorrent with VPN: The bittorrent protocol allows access to a very large, distributed, free and, in most cases,
  public file library. In order to maintain online privacy, a remote anonymous VPN for the bittorrent protocol is
  necessary.
- WireGuard as protocol for local VPN: To be able to access critical systems remotely, it is necessary not to expose
  them publicly but through a secure VPN. WireGuard is an open source, modern, secure and efficient VPN protocol and is
  ideal for creating a personal VPN connected to our local network.
- DuckDNS: DuckDNS offers a free DDNS service that also supports multiple subdomain levels. For
  example: `myhome.duckdns.org` and `jellyfin.myhome.duckdns.org` will be mapped to the same IP. This is very useful as
  it allows us to have our own subdomains that the reverse proxy can use in its rules.

## 5. Minimum prerequisites

- An old computer no more than 7 years old.
- An SSD for the OS.
- At least 3 HDDs of the same size of at least 6 TB. Recommended 6 HDDs of 8 TB.
- Minimum 8GB of RAM. All the RAM that the motherboard can support is recommended since ZFS can use the RAM as cache for
  better performance.
- Internet connection. If you want to watch media away from home, a good upload speed is recommended.
- A USB stick of at least 1 GB for the Fedora Server ISO.
- An anonymous VPN provider for bittorrent. Mulvad is recommended as it does not require any information to use the
  service and the only information exposed is the IP. Payment can be made with Monero for even greater privacy.
- Optional: 2.5 Gb Ethernet network card. If the motherboard already has an Ethernet port of at least 1 Gb, it can be
  skipped unless better data transfer performance is desired. The guide assumes that you connected the server to the
  router through this Ethernet port.
- Optional: Video card capable of video encoding/decoding for hardware acceleration. The guide will assume an Nvidia
  video card.
- Optional: HBA card in "passthrough" mode (i.e. not hardware RAID). If your motherboard has enough ports for all
  drives, it is not necessary. It is important to check the motherboard manual and see if it supports the video card,
  the network card (if it is not integrated) and the HBA at the same time, both physically (it has enough slots for the
  cards) and logically (it supports the multiple slots at the same time. Some motherboards can only have a certain
  combination of slots working at the same time).
- The guide assumes that the user is familiar with their motherboard manual and BIOS and has correctly configured the
  BIOS for their hardware.

## 6. Guide

This guide is just that, a guide. Feel free to modify and adapt the steps to your taste and convenience. The guide will
use some names and parameters that you can customize, please be aware if you decide to use different names or parameters
you will need to adjust some steps and files of the guide.

### 6.1. Install Fedora Server

To install Fedora Server we will need a USB stick and to download the ISO from the official Fedora website. We will
write the ISO to the USB and start the operating system installer. We'll configure our installation and let the wizard
do the rest. The guide assumes that you will prepare the installation media from a Linux operating system. If you are
doing this from Windows, you can try using the Rufus tool and its guide: https://rufus.ie/.

> [!CAUTION]
> **Before starting make sure to backup the data on the USB stick as it will be formatted and all the data on it will be
lost!**

> [!CAUTION]
> **Before starting make sure to backup the data on the server disks as these will be formatted and all data on them
will be lost!**

#### 6.1.1 Steps

1. Go to https://fedoraproject.org/server/download and download the "Network Install" ISO for your architecture (
   normally x86_64). If you want, you can verify the file signature with the hash on the same page.
2. Insert the USB stick and determine the device using `lsblk`. Find the USB stick in the list and write down the name,
   for example `sdc`.
3. If your system mounted the USB automatically, unmount with `sudo umount /dev/sdc*`.
4. Write the ISO to the USB with `dd if=./Fedora-Server-netinst-x86_64-39-1.5.iso of=/dev/sdc bs=8M status=progress`.
   Set the address to the ISO file in the command.
5. Remove the USB stick and insert it into the server. If the server is on, turn it off.
6. Turn on the server and access the BIOS (try the F2 or Insert key or read your motherboard manual).
7. Disable Secure Boot if it is active. Each BIOS is different so consult your manual to find the option.
8. Select the option to boot from USB. If you can't, try changing the order of boot devices and putting the USB before
   other disks. Save and restart. The Fedora installer should start. If not, try changing the boot order again.
9. Select "Test media & install Fedora".
10. Select the language of your preference and Continue. The guide will assume English.
11. If you want to use another keyboard layout, click `Keyboard` and select one or more layouts. Press `Done` to return
    to the main menu.
12. If you want to install more languages, click `Language Support` and select one or more languages. Press `Done` to
    return to the main menu.
13. Click on `Time & Date` and choose your region and city to select your time zone. Make sure you
    enable `Network Time`. Press `Done` to return to the main menu.
14. Click on `Software Selection`.
15. `Fedora Server Edition` should be selected by default, if not, select it. In `Additional Software` you don't need to
    select anything, but if you like you can install whatever you want. Press `Done` to return to the main menu.
16. Click `Network & Host Name` and set the `Host Name`. The guide will use `server.lan` but you can use another name.
    Press `Done` to return to the main menu.
17. Click on `User Creation`. Enter `admin` in `User name` (if you want to use another name, use another one, but the
    guide will assume `admin` and you will need to adjust files in the future with the name you choose). Do not uncheck
    any boxes.
18. Enter a strong password and confirm it. Press `Done` to return to the main menu.
19. Click on `Installation Destination` and configure the partitions. The guide assumes that nothing else will be
    running on this server and will wipe all partitions. If you know what you're doing and want a different setup, skip
    the steps below and configure the partitions however you want.
    1. Select only the SSD as the installation disk.
    2. Select `Advanced Custom` in `Storage Configuration`. Click `Done`
    3. Select the only disk and delete all existing partitions.
    4. Add new EFI partition.
        1. Click `Add New Device`.
        2. `Device Type` must be `Partition`.
        3. `Size` must be 512 MiB.
        4. `Filesystem` must be `EFI System Partition`.
        5. `Label` must be `EFI`.
        6. `Mountpoint` must be `/boot/efi`.
        7. Accept.
    5. Select `free space`.
    6. Add boot partition.
        1. Click `Add New Device`.
        2. `Device Type` must be `Partition`.
        3. `Size` must be 512 MiB.
        4. `Filesystem` must be `ext4`.
        5. `Label` must be `boot`
        6. `Mountpoint` must be `/boot`.
        7. Accept.
    7. Select `free space`.
    8. Add LVM.
        1. Click `Add New Device`.
        2. `Device Type` must be `LVM2 Volume Group`.
        3. Use all remaining space.
        4. `Name` must be `root-vg`.
        5. Enable `Encrypt`.
        6. Set a password for the disk and confirm it.
        7. Accept.
    9. Select `root-vg`.
    10. Add swap.
        1. Click `Add New Device`.
        2. `Device Type` must be `LVM2 Logical Volume`.
        3. `Size` should be 2 to 8 GiB depending on how much space on the SSD and RAM you have.
        4. `Filesystem` must be `swap`.
        5. `Label` must be `swap`
        6. `Name` must be `swap`.
        7. Accept.
    11. Select `free space`.
    12. Add root partition.
        1. Click `Add New Device`.
        2. `Device Type` must be `LVM2 Logical Volume`.
        3. `Size` should be the remaining space.
        4. `Filesystem` must be `ext4`. If you prefer `btrfs` you can change it.
        5. `Label` must be `root`.
        6. `Name` must be `root`.
        6. `Mountpoint` must be `/`.
        7. Accept.
    13. Click `Done`. Review the changes and Accept if they match the previous steps.
20. Click on `Begin Installation`. Let the installer do its job.
21. Click `Reboot System` to reboot.
22. Enter the BIOS again.
23. Change the startup order again and put Fedora at the top of the list. Save and exit.
24. Enter the disk's password.
25. From your computer (not the server) connect remotely with SSH `ssh admin@server`
26. Install git: `sudo dnf install -y git`.
27. Download this repository: `git clone https://github.com/JurgenCruz/HomeServerSetup.git`.
28. Delete the .git folder: `rm -rf HomeServerSetup/.git`.
29. Move everything up one level; `mv HomeServerSetup/* ./`
30. Update the system: `dnf up`.
30. Shut down the server: `shutdown`.

### 6.2. Configure Secure Boot

Secure Boot will be configured with owner keys and a password will be set to the BIOS to prevent its deactivation.

#### 6.2.1. Steps

1. Turn on the server and enter the BIOS (usually with the `F2` key).
2. Configure Secure Boot in "Setup" mode, save and reboot.
3. After logging in with `admin`, run: `sudo ./scripts/secureboot.sh`.
4. If there were no errors, then run `reboot` to reboot and enter the BIOS again.
5. Exit "Setup" mode and enable Secure Boot.
6. Set a password to the BIOS, save and reboot.
7. After logging in with `admin`, run: `sbctl status`. The message should say that it is installed and Secure Boot is
   enabled.

### 6.3. Install and configure Zsh (Optional)

If you want to continue using Bash as a terminal, you can skip this section. Zsh is a more powerful terminal than Bash,
but in the end it is a personal decision and not relevant to the server configuration.

#### 6.3.1. Steps

1. Run: `./scripts/zsh_setup.sh`. The script will install Zsh and configure it as the default terminal for the `admin`
   and `root` users.

### 6.4. Configure users

Apart from the `admin` user, a user that we will call `mediacenter` is necessary to manage access to Media Center files
and manage the AAR application ecosystem. You also need one user for each Samba share you want to make. The guide will
use 2 example Samba shares and thus, 2 users: `nasj` and `nask`. The user `admin` will be added to the groups of each
created user so that it also have access to the files.

#### 6.4.1. Steps

1. Assume the `root` role by running `sudo -i`.
2. We create users `nasj`, `nask` and `mediacenter` and add `admin` to their
   groups: `printf "nasj\nnask\nmediacenter" | ./scripts/users_setup.sh admin`.

### 6.5. Install ZFS

Since ZFS is a kernel module, it means that it also has to pass the Secure Boot check. We will install ZFS and register
the key used to sign it in the Secure Boot boot chain. This registration requires restarting the server and navigating a
wizard as explained later.

#### 6.5.1. Steps

1. Run: `./scripts/zfs_setup.sh`. The script will ask you to enter a password. This password will be used one time on
   the next reboot to add the signature to the Secure Boot chain. You can use a temporary password or you can reuse your
   user's password if you wish.
2. Reboot with: `reboot`.
3. A blue screen with a menu will appear. Select the following options:
    1. "Enroll MOK".
    2. "Continue."
    3. "Yes."
    4. Enter the password you defined in the first step.
    5. "OK."
    6. "Reboot".

### 6.6. Configure ZFS

Now we will configure the ZFS pool and its datasets. If you have 3 to 4 disks, `raidz` is recommended. If you have 5 to
6 disks, `raidz2` is recommended. Less than 3 disks is not recommended since the only possible redundancy would be with
2 disks in mirror mode with only one redundancy disk and only 50% capacity. For more than 6 discs it is recommended that
you make 2 or more pools. Directories will also be prepared for the configuration of the containers in the OS partition,
that is, on the SSD. This provides better performance in their execution. The container configuration will be backed up
to the hard drives once a day.

#### 6.6.1. Steps

1. After logging in, assume `root` by running `sudo -i`.
2. Depending on whether this is your first installation, a reinstallation, or a hard drive migration, complete the
   appropriate steps.
    - A) First installation: an encryption key will be generated and a new disk pool will be created.
        1. Run: `./scripts/generate_zfs_key.sh`. A hex key will be generated in `/keys/Tank.dat`. It is recommended that
           you back up this key in a safe place because if the SSD fails and the key is lost, the data in the pool will
           be lost forever.
        2.
      Run: `./scripts/create_zfs_pool.sh raidz2 /dev/disk/by-id/disk1 /dev/disk/by-id/disk2 /dev/disk/by-id/disk3 /dev/disk/by- id/disk4 /dev/disk/by-id/disk5 /dev/disk/by-id/disk6`.
      Adjust the parameters to choose the appropriate type of `raidz`. It is advisable to use disk names by id, uuid
      or label. **Do not use the disk name** (for example /dev/sda) as these can change after a reboot and the pool
      will not work.
        3. Execute: `printf "nasj\nnask" | ./scripts/create_zfs_datasets.sh`. Datasets will be created with the user
           name in capital letters, for example `Tank/NASJ`. Additionally, it will create a `Tank/Apps` dataset to
           backup the container configuration and a `Tank/MediaCenter` dataset to store the media files. The datasets
           that will be used as Samba shares will be configured so that SELinux allows access to them by Samba.
        4. Run: `./scripts/create_app_folders.sh` to generate the container directories on the SSD.
    - B) OS reinstallation: the encryption key will be restored and the existing pool will be imported.
        1. Create the keys directory: `mkdir /keys`. It is assumed that this address is the same one used before
           reinstalling the OS and that the pool will look for the key in the same directory. Adjust the address if not.
        2. Copy the key from another computer: `scp user@host:/path/to/keyfile /keys/Tank.dat`.
           Change `{user@host:/path/to/keyfile}` to the address of the key on the computer containing the backup. If you
           prefer, you can also use a USB stick to transfer the key backup.
        3. Import the existing pools: `zpool import -d /dev/disk/by-id -a`. If the pool was not exported before, try
           using `-f` to force the import.
        4. Mount all datasets and load the key if necessary: ​​`zfs mount -al`.
        5. Restore the container folders from the hard drives to the SSD: `rsync -avz /mnt/Tank/Apps/ /Apps/`.
    - C) Migrate to new hard drives: It is assumed that the new pool will use the same key as the previous one and that
      it is already in place.
        1.
      Run: `./scripts/migrate_pool.sh Tank raidz2 /dev/disk/by-id/disk1 /dev/disk/by-id/disk2 /dev/disk/by-id/disk3 /dev/disk/by -id/disk4 /dev/disk/by-id/disk5 /dev/disk/by-id/disk6`. `Tank`
      is the name of the current pool. It is the same name used by the script that initially creates the pool. The
      other parameters are the same as for `create_zfs_pool.sh`. See information in option A).
        2. Mount all datasets and load the key if necessary: ​​`zfs mount -al`.
3. Run: `./scripts/generate_dataset_mount_units.sh`. This will generate Systemd units that will mount the datasets
   in `Tank` automatically after loading the key upon rebooting the server. Run this
   command `cat /etc/zfs/zfs-list.cache/Tank` to verify that the cache file is not empty. If it is empty, try running
   the script again as it means the cache and units were not generated.

> [!NOTE]
> If you performed a migration or reinstallation, there will be certain steps in the guide that you can skip. For
> example if certain directories or files already existed. It is left to the reader's discretion to see which steps are
> no
> longer necessary.

> [!TIP]
> To adjust the max size of ZFS ARC use the command `echo {size_in_bytes} > /sys/module/zfs/parameters/zfs_arc_max`
> replacing `{size_in_bytes}` with the size in bytes you wish to set. To make the change permanent execute the
> command `echo "options zfs zfs_arc_max={size_in_bytes}" > /etc/modprobe.d/zfs.conf && dracut --force`.

> [!Caution]
> Assigning a very high value can cause instability in the system, only change it if you know what you are doing.

### 6.7. Configure host's network

To prevent connection configurations from being broken in the future, it is useful to assign the server a static IP on
the local network. We will configure the server to not use DHCP and assign itself an IP on the network. Also, we will
create an auxiliary macvlan network to be able to communicate with Home Assistant which will be in a Docker macvlan. The
guide will assume a local network with CIDR range 192.168.1.0/24, with the router at the second to last address (
192.168.1.254) and the server at the third to last address (192.168.1.253). If you need to use another range, just
replace it with the correct range in the rest of the guide.

#### 6.7.1. Steps

1. Look for the name of the active physical network device, for example `enp1s0` or `eth0`: `nmcli device status`. If
   there is more than one physical device, select the one that is connected to the router with the best speed.
   Replace `enp1s0` in the following commands with the correct device.
2. Assign static IP and CIDR range: `nmcli with mod enp1s0 ipv4.addresses 192.168.1.253/24`. Typically home routers use
   a CIDR range of `/24` or its equivalent subnet mask `255.255.255.0`. Check your router's manual for more information.
3. Disable DHCP client: `nmcli with mod enp1s0 ipv4.method manual`.
4. Configure the router IP: `nmcli with mod enp1s0 ipv4.gateway 192.168.1.254`. Normally the router assigns itself a
   static IP which is the second to last IP in the IP range.
5. Configure Cloudflare as DNS: `nmcli with mod enp1s0 ipv4.dns 1.1.1.1`. If you like to use another DNS like Google's,
   you can change it.
6. Reactivate the device for the changes to take effect: `nmcli con up enp1s0`. This may terminate the SSH session. if
   so, `ssh` to the server again.
7. Run: `./scripts/disable_resolved.sh`. We disable the local DNS service "systemd-resolved" to free up the DNS port
   that Pi-hole needs and configure Cloudflare as DNS. If you like, you can modify the script to use another DNS like
   Google.
8. Add auxiliary macvlan
   connection: `nmcli con add con-name macvlan-shim type macvlan ifname macvlan-shim ip4 192.168.1.12/32 dev enp1s0 mode bridge`. `192.168.1.12`
   is the server's IP inside this auxiliary network. If your local network is in another prefix, adjust this IP to one
   inside the prefix but outside the DHCP assignable range to avoid collisions.
9. Add route to auxiliary connection to macvlan
   network: `nmcli con mod macvlan-shim +ipv4.routes "192.168.1.0/27"`. `192.168.1.0/27` is the IP range of the macvlan
   network which matches with the local network's prefix at the same time it is outside the DHCP assignable IP range.
10. Activate auxiliary connection: `nmcli con up macvlan-shim`.

### 6.8. Configure shares

Samba will be installed, Samba shares will be configured, user passwords will be created that are separate from Linux
passwords (you can use the same passwords as Linux if you like), and the firewall will be configured to allow the Samba
service to the local network.

#### 6.8.1. Steps

1. Run: `./scripts/smb_setup.sh`. Installs Samba service.
2. Run: `./scripts/set_samba_passwords.sh`. Enter the username and set a password for it. This guide assumes that
   passwords will be set for 3 users: `mediacenter`, `nasj` and `nask`.
3. Copy the preconfigured Samba server configuration with 3 shares for the users from the previous
   step: `cp ./files/smb.conf /etc/samba`.
4. Edit the file: `nano /etc/samba/smb.conf`. You can change the names of the shares (eg \[NASJ\]), and the `path`
   and `valid users` properties. The guide assumes that the local network is in the range 192.168.1.0/24. If your
   network is different, then also change the `allow hosts` property so that it has the correct range of your local
   network. Save and exit with `Ctrl + X, Y, Enter`.
5. Run: `./scripts/smb_firewalld_services.sh`. Configure Firewalld by opening the ports for Samba and then enable the
   Samba service.

### 6.9. Register DDNS

If you do not plan to access your server outside of your local network, or if you have a static public IP and your own
domain, you can skip this section.

This guide will use the DuckDNS.org service as DDNS in order to map a subdomain to our server. We will register a
subdomain on DuckDNS.org and configure our server to update the IP on DuckDNS.org.

#### 6.9.1. Steps

1. Register a subdomain on DuckDNS.org.
    1. Access and create an account at https://www.duckdns.org/.
    2. Register a subdomain of your preference. Write down the generated token because we are going to need it next.
2. Copy the script that updates the DDNS with our public IP to `sbin`: `cp ./scripts/duck.sh /usr/local/sbin/`.
3. Edit the script: `nano /usr/local/sbin/duch.sh`. Replace `XXX` with the subdomain we registered and `YYY` with the
   token we generated during registration. Save and exit with `Ctrl + X, Y, Enter`.
4. We change the permissions of the script so that only `root` can access it: `chmod 700 /usr/local/sbin/duck.sh`. The
   script contains our token, which is the only thing that allows only us to change the IP to which the subdomain
   points, hence the importance of securing it.

### 6.10. Install Docker

We will install Docker as our container engine; optionally we will install Nvidia drivers and "Nvidia Container
Toolkit"; and we will configure SELinux to secure Docker.

#### 6.10.1. Steps

1. Run: `./scripts/docker_setup.sh admin`. Adds the Docker repository, installs it, enables the service, and adds
   the `admin` user to the `docker` group.
2. Run: `./scripts/selinux_setup.sh`. Enables SELinux in Docker; restarts the Docker service for the changes to take
   effect; enables the flag that allows containers to manage the network and use the GPU; and installs the SELinux
   policies. These are required for some containers to be able to access Samba files and interact with WireGuard and for
   rsync to be able to backup the apps.
3. Optional: If you have a relatively modern Nvidia card, run: `./scripts/nvidia_setup.sh`. Adds "RPM Fusion" and Nvidia
   repositories to install the driver and "Nvidia Container Toolkit" for Docker. It also registers the "Akmods" key in
   the Secure Boot chain. It is necessary to reboot and repeat the key enrollment process as we did with ZFS. After
   rebooting and logging in, don't forget to assume `root` with `sudo -i`.

### 6.11. Prepare Pi-hole configuration

We will create a Docker secret to set the Pi-hole password and optionally configure Pi-hole as DHCP so it can assign
itself as DNS and do split horizon DNS.

#### 6.11.1. Steps

1. Create credentials file for Pi-hole. This file sets the password for Pi-hole, so it should only be accessible
   to `root`.
    1. Create password file: `nano /Apps/pihole_pwd.txt`.
    2. Write a random and strong password. It is recommended to use Bitwarden password manager to generate and save the
       password securely. Save and exit with `Ctrl + X, Y, Enter`.
    3. Set the permissions so that only `root` can access it: `chmod 700 /Apps/pihole_pwd.txt`.
    4. Manually change the SELinux label of the file: `semanage fcontext -a -t container_file_t '/Apps/pihole_pwd.txt'`.
       There is a bug in docker-compose that does not allow using secrets with SELinux since it does not automatically
       change the label before mounting the secret.
    5. We refresh the label for the change to take effect: `restorecon -v /Apps/pihole_pwd.txt`.
2. Configure Pi-hole as a DHCP server to be able to assign itself as DNS. If your router has the option to change the
   DNS assigned by DHCP or if you do not plan to expose your server to the internet, follow path B)
   A) Use Pi-hole as DHCP:
    1. Edit the stack file: `nano ./files/docker-compose.yml`.
    2. Set the `DHCP_START` and `DHCP_END` variables with the IP range of your local network. Make sure to leave some
       IPs
       unassignable at the beginning of the network. For example if your local network range is 192.168.1.0/24, start at
       192.168.1.64.
    3. Set the `DHCP_ROUTER` variable with the IP of your router.
    4. Set the attribute `ipv4_address` in the `pihole` container with an IP in the non-assignable range of the DHCP.
       For
       example 192.168.1.11.
       B) Do not use Pi-hole as DHCP:
    1. Edit the stack file: `nano ./files/docker-compose.yml`.
    2. Delete the
       variables `DHCP_ACTIVE`, `DHCP_START`, `DHCP_END`, `DHCP_ROUTER`, `DHCP_LEASETIME`, `PIHOLE_DOMAIN`, `DHCP_IPv6`
       and `DHCP_rapid_commit` of the `pihole` container.
3. Optional: If you do not want to use Cloudflare as DNS, Set `PIHOLE_DNS_` to the DNS of your choice such as Google.
   Save and exit with `Ctrl + X, Y, Enter`.
4. If you are going to expose your server to the internet, configure split horizon
   DNS: `echo "address=/myhome.duckdns.org/192.168.1.253" > /Apps/pihole/etc-dnsmasq.d/03-my- wildcard-dns.conf`.
5. Configure the server's hostname since the server will not be part of the DHCP network: `echo "192.168.1.253 server.lan" > /Apps/pihole/etc-pihole/custom.list`.

### 6.12. Create Docker stack

We will prepare the anonymous VPN configuration file that qBittorrent requires; we will configure the stack; we will
configure the firewall to allow the necessary ports; and we will bring the stack up through Portainer. The stack
consists of the following containers:

- qBittorrent: Download manager through the bittorrent protocol.
- Sonarr: Series manager.
- Radarr: Movie manager.
- Prowlarr: Search engine manager.
- Bazarr: Subtitle manager.
- Flaresolverr: CAPTCHA solver.
- Jellyfin: Media service.
- Jellyseerr: Media request manager and catalog service.
- Pi-hole: DNS and DHCP server.
- Nginx Proxy Manager: Reverse Proxy engine and manager.
- Home Assistant: Home automation engine.
- WireGuard: VPN for the local network.

#### 6.12.1. Steps

1. Copy the anonymous VPN configuration file for
   bittorrent: `scp user@host:/path/to/vpn.conf /Apps/qbittorrent/wireguard/tun0.conf`.
   Change `{user@host:/path/to/vpn.conf}` to the address of the file on the computer that contains the file. This file
   must be provided by your VPN provider if you select WireGuard as the protocol. You can also use a USB stick to
   transfer the configuration file. If your provider requires using OpenVPN you will have to change the container
   configuration. For more information read the container's guide: https://github.com/Trigus42/alpine-qbittorrentvpn.
2. If you are going to use a local VPN, run: `./scripts/iptable_setup.sh`. Adds a kernel module at system startup
   required for WireGuard.
3. Edit the stack file: `nano ./files/docker-compose.yml`.
4. Replace `TZ=America/New_York` with your system time zone. You can use this list as a
   reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
5. Replace the XXX with the `uid` and `gid` of the user `mediacenter`. You can use `id mediacenter` to get the `uid`
   and `gid`.
6. If a GPU is not going to be used, delete the `runtime` and `deploy` sections of the `jellyfin` container.
7. If you are going to use OpenVPN for bittorrent, update the `qbittorrent` container according to the official guide.
8. If you are not going to use a local VPN, remove the `wireguard` container, otherwise replace `myhome` with the
   subdomain you registered on DuckDNS.org and set the `ALLOWEDIPS` variable in case `192.168 .1.0/24` is not the CIDR
   range of your local network. Do not remove `10.13.13.0` as it is the internal WireGuard network and you will lose
   connectivity if you remove it. The guide assumes 2 clients that will connect to the VPN with the IDs: `phone`
   and `laptop`. If you require more or fewer clients, add or remove or rename the client IDs as you wish.
9. If you are not going to expose the server to the internet, remove the `nginx` container.
10. Set the `lanvlan` network.
    1. Set the `parent` attribute with the device you used to create the auxiliary macvlan network before. For
       example`enp1s0`.
    2. Set the `subnet` attribute with your local network's range.
    3. Set the `gateway` attribute with your router's IP.
    4. Set the`ip_range` attribute with your local network's range that the DHCP does not assign. The guide configured
       Pi-hole not to assign the first 64 addresses, thus we use a range of 192.168.1.0/27. If you configured your DHCP
       with another non-assignable range, use that here.
    5. Set the `host` attribute with the server's IP in the auxiliary macvlan network.
11. Set the attribute `ipv4_address` in the `homeassistant` container with an IP in the non-assignable range of the
    DHCP. For example 192.168.1.10.
12. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
13. Run: `./scripts/container_firewalld_services.sh`. Configure Firewalld for containers. The script opens the ports for
    DHCP and DNS for Pi-hole; the ports for HTTP and HTTPS for Nginx and the port for WireGuard. If you are not going to
    use any of these services, edit the script and remove any unnecessary rules.
14. Run: `./scripts/run_portainer.sh`. This runs a Portainer Community Edition container and will listen on port `9443`.
15. Configure Portainer from the browser.
    1. Access Portainer through https://192.168.1.253:9443. If you get a security alert, you can accept the risk since
       Portainer uses a self-signed SSL certificate.
    2. Set a random password and create user `admin`. Bitwarden is recommended again for this.
    3. Click "Get Started" and then select "local."
    4. Select "Stacks" and create a new stack.
    5. Name it "apps" and paste the content of the docker-compose.yml that you copied to the clipboard and create the
       stack. From now on, modifications to the stack must be made through Portainer and not in the file.
    6. Navigate to "Environments" > "local" and change "Public IP" with the server's static IP `192.168.1.253`.

### 6.13. Configure applications

The containers should be running now, however, they require some configuration to work with each other.

#### 6.13.1. Configure qBittorrent

1. Access qBittorrent through http://192.168.1.253:10095.
2. Use `admin` and `adminadmin` as username and password.
3. Click the `Options` button.
4. Configure `Downloads` tab. Make the following changes:
    1. "Default Torrent Management Mode" : "Automatic".
    2. "Default Save Path": "/MediaCenter/torrents".
    3. Optional: If you want to save the `.torrent` files in case you need to download something again, you can enable "
       Copy .torrent files for finished downloads to" and assign: "/MediaCenter/torrents/backup".
5. Configure `Connection` tab. Make the following changes:
    1. Disable "Use UPnP / NAT-PMP port forwarding from my router".
    2. If you like, you can adjust the connection limits.
6. Configure `Speed` tab. Make the following changes:
    1. In the "Alternative Rate Limits" > "Upload" section: Set it to one third of your provider's upload speed.
    2. In the "Alternative Rate Limits" > "Download" section: Set it to one third of your provider's download speed.
    3. Enable "Schedule the use of alternative rate limits".
    4. Choose the time when the Internet is used at home for other things. For example: 08:00 - 01:00 every day.
7. Configure `BitTorrent` tab. Make the following changes:
    1. Disable `Enable Local Peer Discovery to find more peers` since there is nothing local in the container.
    2. If you like to stop seeding after a goal, you can enable and adjust the limits here. For example "When the rate
       reaches 1".
8. Configure `Web UI` tab. Make the following changes:
    1. Change the password to a more secure one. It is again recommended to use Bitwarden for the same.
    2. Enable "Bypass authentication for clients on localhost".
    3. Enable "Bypass authentication for clients in whitelisted IP subnets".
    4. Add `172.21.0.0/24` to the list below. This will allow containers in Docker's `arr` network to be accessed
       without a password.
9. Configure `Advanced` tab. Make the following changes:
    1. Ensure that the "Network Interface" is `tun0`. If not it means you are not using your VPN and the traffic will
       not be anonymous.
    2. Enable "Reannounce to all trackers when IP or port changed".
    3. Enable "Always announce to all trackers in a tier".
    4. Enable "Always announce to all tiers".
10. Save.

#### 6.13.2. Configure Radarr

1. Access Radarr through http://192.168.1.253:7878.
2. Set password. It is again recommended to use Bitwarden for the same. Leave the authentication method as `Forms` and
   do not disable authentication.
3. Navigate to "Settings" > "Media Management" and configure.
    1. "Standard Movie
       Format": `{Movie CleanTitle} {(Release Year)} [imdbid-{ImdbId}] - {Edition Tags }{[Custom Formats]}{[Quality Full]}{[MediaInfo 3D]}{ [MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels}]{MediaInfo AudioLanguages}[{MediaInfo VideoBitDepth}bit][{Mediainfo VideoCodec}]{-Release Group}`.
    2. Click "Add Root Folder" and select "/MediaCenter/media/movies".
4. Navigate to "Settings" > "Download Clients" and configure.
    1. Add new client.
    2. Select "qBittorrent".
    3. "Name": "qBittorrent".
    4. "Host": "qbittorrent".
    5. "Port": "8080".
    6. "Category": "movies".
    7. Click "Test" and then "Save."
5. Navigate to "Settings" > "General".
6. Copy the API Key to a notepad as we will need it later.
7. To configure the "Profiles", "Quality" and "Custom Formats" tabs, it is recommended to use the following
   guide: https://trash-guides.info/Radarr/

#### 6.13.3. Configure Sonarr

1. Access Sonarr through http://192.168.1.253:8989.
2. Set password. It is again recommended to use Bitwarden for the same. Leave the authentication method as `Forms` and
   do not disable authentication.
3. Navigate to "Settings" > "Media Management" and configure.
    1. "Standard Episode
       Format": `{Series TitleYear} - S{season:00}E{episode:00} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}`.
    2. "Daily Episode
       Format": `{Series TitleYear} - {Air-Date} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]} {[MediaInfo VideoCodec]}{-Release Group}`.
    3. "Anime Episode
       Format": `{Series TitleYear} - S{season:00}E{episode:00} - {absolute:000} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}[{MediaInfo VideoBitDepth}bit]{[MediaInfo VideoCodec]}[{Mediainfo AudioCodec} { Mediainfo AudioChannels}]{MediaInfo AudioLanguages}{-Release Group}`.
    4. "Season Folder Format": "Season {season:00}".
    5. Click "Add Root Folder" and select "/MediaCenter/media/tv".
4. Navigate to "Settings" > "Download Clients" and configure.
    1. Add new client.
    2. Select "qBittorrent".
    3. "Name": "qBittorrent".
    4. "Host": "qbittorrent".
    5. "Port": "8080".
    6. "Category": "tv".
    7. Click "Test" and then "Save."
5. Navigate to "Settings" > "General".
6. Copy the API Key to a notepad as we will need it later.
7. To configure the "Profiles", "Quality" and "Custom Formats" tabs, it is recommended to use the following
   guide: https://trash-guides.info/Sonarr/

#### 6.13.4. Configure Prowlarr

1. Access Prowlarr through http://192.168.1.253:8989.
2. Set password. It is again recommended to use Bitwarden for the same. Leave the authentication method as `Forms` and
   do not disable authentication.
3. Navigate to "Settings" > "Indexers" and configure.
    1. Add new proxy.
    2. Select "FlareSolverr".
    3. "Name": "FlareSolverr".
    4. "Tags": "proxy".
    5. "Host": "http://flaresolverr:8191/".
    6. Click "Test" and then "Save."
4. Navigate to "Settings" > "Apps" and configure.
    1. Add new application.
    2. Select "Radarr"
    3. "Name": "Radarr".
    4. "Sync Level": "Full Sync".
    5. "Tags": "radarr".
    6. "Prowlarr Server": "http://prowlarr:9696".
    7. "Radarr Server": "http://radarr:7878".
    8. "API Key": paste the Radarr API Key that we copied before.
    9. Click "Test" and then "Save."
    10. Add new application.
    11. Select "Sonarr"
    12. "Name": "Sonarr".
    13. "Sync Level": "Full Sync".
    14. "Tags": "sonarr".
    15. "Prowlarr Server": "http://prowlarr:9696".
    16. "Sonarr Server": "http://sonarr:8989".
    17. "API Key": paste the Sonarr API Key that we copied before.
    18. Click "Test" and then "Save."
5. Navigate to "Settings" > "Download Clients" and configure.
    1. Add new client.
    2. Select "qBittorrent".
    3. "Name": "qBittorrent".
    4. "Host": "qbittorrent".
    5. "Port": "8080".
    6. "Default Category": "manual".
    7. Click "Test" and then "Save."
6. Navigate to "Indexers" and configure.
    1. Add indexer.
    2. Choose the indexer of your preference.
    3. Configure the indexer to your preference.
    4. "Tags": Add "sonarr" if you want to use this indexer with Sonarr. Add "radarr" if you want to use this indexer
       with Radarr. Add "proxy" if this indexer requires FlareSolverr.
    5. Click "Test" and then "Save."
    6. Repeat the steps for any other indexers you want. Prowlarr will push the indexers' details to Radarr and Sonarr.

#### 6.13.5. Configure Bazarr

1. Access Bazarr through http://192.168.1.253:6767.
2. Set password. It is again recommended to use Bitwarden for the same. Leave the authentication method as `Forms` and
   do not disable authentication.
3. Navigate to "Settings" > "Languages" and configure.
    1. "Languages ​​Filter": Select the languages ​​you are interested in downloading. It's a good idea to have a backup
       language in case one doesn't exist for your preferred one.
    2. Click "Add New Profile".
    3. "Name": The name of the primary language.
    4. Add primary language and backup languages ​​in the order of your preference.
    5. "Cutoff": Select the primary language.
    6. Save.
    7. If you want other languages, you can repeat adding another profile.
    8. Select the default language for series and movies.
    9. Save.
4. Navigate to "Settings" > "Providers" and configure.
    1. Add the subtitle providers of your choice.
5. Navigate to “Settings” > “Sonarr” and configure.
    1. Enable Sonarr.
    2. "Host" > "Address": "sonarr".
    3. "Host" > "Port": "8989".
    4. "Host" > "API Key": Paste the Sonarr API Key that we copied before.
    5. Click "Test" and then "Save."
6. Navigate to “Settings” > “Radarr” and configure.
    1. Enable Radarr.
    2. "Host" > "Address": "radarr".
    3. "Host" > "Port": "7878".
    4. "Host" > "API Key": Paste the Radarr API Key that we copied before.
    5. Click "Test" and then "Save."
7. To configure other tabs, it is recommended to use the following guide: https://trash-guides.info/Bazarr/

#### 6.13.6. Configure Jellyfin

1. Access Jellyfin through http://192.168.1.253:8096.
2. Follow the wizard to create a new username and password. It is again recommended to use Bitwarden for the same.
3. Open side panel and navigate to "Administration" > "Dashboard".
4. If you have GPU, navigate to "Playback" and configure.
    1. Select your GPU. The guide will assume "NVidia NVENC".
    2. Enable the codecs that your GPU model supports.
    3. Enable "Enable enhanced NVDEC decoder".
    4. Enable "Enable hardware encoding".
    5. Enable "Allow encoding in HEVC format".
    6. If you like, you can configure other parameters to your liking.
    7. Save.
5. Navigate to "Networking" and configure:
    1. "Known proxies": "nginx".
    2. Save.
6. Navigate to "Plugins" > "Catalog" and configure.
    1. If there will be Anime in your collection, install "AniDB" and "AniList".
    2. Install "TMBd Box Sets", "TVmaze" and "TheTVDB".
7. For the plugins to take effect, restart Jellyfin from Portainer.
8. Navigate to “Libraries” and configure.
    1. Add library.
    2. "Content Type": "Movies".
    3. "Name": "Movies".
    4. "Folders": Add "/MediaCenter/media/movies".
    5. Sort "Metadata downloaders": "TheMovieDb", "AniDB", "AniList", "The Open Movie Database".
    6. Sort "Image fetchers": "TheMovieDb", "The Open Movie Database", "AniDB", "AniList", "Embedded Image Extractor", "
       Screen Grabber".
    7. Configure the other options to your liking and Save.
    8. Add library.
    9. "Content Type": "Shows".
    10. "Name": "Shows".
    11. "Folders": Add "/MediaCenter/media/tv".
    12. Sort "Metadata downloaders (TV Shows)": "TheTVDB", "TVmaze", "TheMovieDb", "AniDB", "AniList", "The Open Movie
        Database".
    13. Sort "Metadata downloaders (Seasons)": "TVmaze", "TheMovieDb", "AniDB".
    14. Sort "Metadata downloaders (Episodes)": "TheTVDB", "TVmaze", "TheMovieDb", "AniDB", "The Open Movie Database".
    15. Sort "Image fetchers (TV Shows)": "TheTVDB", "TVmaze", "TheMovieDb", "AniList", "AniDB".
    16. Sort "Image fetchers (Seasons)": "TheTVDB", "TVmaze", "TheMovieDb", "AniDB", "AniList".
    17. Sort "Image fetchers (Episodes)": "TheTVDB", "TVmaze", "TheMovieDb", "The Open Movie Database", "Embedded Image
        Extractor", "Screen Grabber".
    18. Configure the other options as you like and Save.
9. Navigate to "Users" and configure.
    1. If more people are going to use Jellyfin, Create more users and configure them as you like.
10. Navigate to your profile (User icon top right) > "Subtitles".
    1. "Preferred subtitle language": Your primary language. Save.
    2. You can configure the rest of your profile if you wish.

#### 6.13.7. Configure Jellyseerr

1. Access Jellyseerr through http://192.168.1.253:5055.
2. Login with Jellyfin.
    1. Click "Use Jellyfin Account".
    2. "Jellyfin URL": "http://192.168.1.253:8096"
    3. Log in with your username and password.
3. Configure libraries.
    1. Click "Sync Libraries".
    2. Enable "Movies", "Shows" and "Collections".
    3. Click "Start Scan".
    4. Click "Continue".
4. Configure Sonarr and Radarr.
    1. Click "Add Radarr Server".
    2. Enable "Default Server".
    3. "Server Name": "Movies".
    4. "Hostname or IP Address": "radarr".
    5. "Port": "7878".
    6. "API Key": Paste the Radarr API Key that we copied before.
    7. Click on "Test".
    8. "Quality Profile": choose the default quality profile you want to use.
    9. "Root Folder": "/MediaCenter/media/movies".
    10. "Minimum Availability": "Announced."
    11. Enable "Enable Scan".
    12. Save.
    13. Click "Add Sonarr Server".
    14. Enable "Default Server".
    15. "Server Name": "Series".
    16. "Hostname or IP Address": "sonarr".
    17. "Port": "8989".
    18. "API Key": Paste the Sonarr API Key that we copied before.
    19. Click on "Test".
    20. "Quality Profile": choose the default quality profile you want to use.
    21. "Root Folder": "/MediaCenter/media/tv".
    22. "Anime Quality Profile": choose the default quality profile you want to use for Anime. Leave blank if you will
        not be having anime in your collection.
    23. "Anime Root Folder": "/MediaCenter/media/tv".
    24. Enable "Season Folders".
    25. Enable "Enable Scan".
    26. Save.
5. Import users.
    1. Navigate to "Users".
    2. Click on "Import Jellyfin Users".
    3. You can configure users by clicking "Edit" in the row of the user you want to configure.
6. If you wish to configure more options, Navigate to "Settings" and make the desired changes.

#### 6.13.8. Configure Pi-hole

1. Access Pi-hole through http://192.168.1.11/admin.
2. Enter the Pi-hole password you set in the secret file.
3. Navigate to "Adlists" and configure.
    1. Add blocklist addresses. Some recommendations of pages where you can get lists: https://easylist.to/
       and https://firebog.net/.
4. If any page is being blocked and you do not want to block it, Navigate to "Domains" and add domain or regular
   expression to the inclusion list.

#### 6.13.9. Configure Home Assistant

1. Access Home Assistant through http://192.168.1.10:8123.
2. Use the wizard to create a user account and password. It is again recommended to use Bitwarden for the same.
3. Configure the name of the Home Assistant instance and your data and preferences with the wizard.
4. Choose whether you want to send usage data to the Home Assistant page.
5. Finish the wizard.
6. Configure Webhook for notifications.
    1. Navigate to "Settings" > "Automations & Scenes".
    2. Click "Create Automation".
    3. Click "Create new Automation".
    4. Click "Add Trigger".
    5. Search for "Webhook" and select.
    6. Name the trigger "A Problem is reported".
    7. Change the webhook id to "notify".
    8. Click on the configuration gear and enable only "POST" and "Only accessible from the local network".
    9. Click "Add Action".
    10. Search for "send persistent notification" and select.
    11. Click on the Action Menu and select "Edit in YAML" and add the following:
        ```yaml
        alias: Notify Web
        service: notify.persistent_notification
        metadata: {}
        data:
            title: Issue found in server!
            message: "Issue in server: {{trigger.json.problem}}"
        ```
    12. If you want to receive notifications on your cell phone, you must first download the application to your cell
        phone and log in to Home Assistant from it. Then configure the following:
    13. Click "Add Action".
    14. Search for "mobile" and select "Send notification via mobile_app".
    15. Click on the Action Menu and select "Edit in YAML" and add the following:
        ```yaml
        alias: Notify Mobile
        service: notify.mobile_app_{mobile_name}
        metadata: {}
        data:
            title: Issue found in server!
            message: "Issue in server: {{trigger.json.problem}}"
        ```
    16. Save.

### 6.14. Configure scheduled tasks

We will automate the following tasks: automatic creation and purging of ZFS snapshots; ZFS pool scrubbing; container
configuration backup; container images update to the latest version; short and long hard drive tests with SMART; and
public IP update in DDNS. If you notice that any script does not have the executable flag, make it executable with the
command `chmod 775 <file>` replacing `<file>` with the name of the script.

#### 6.14.1. Steps

1. Copy script for managing ZFS snapshots: `cp ./scripts/snapshot-with-purge.sh /usr/local/sbin/`. This script creates
   recursive snapshots of all datasets in a pool with the same time stamp. Then it purges the old snapshots according to
   the retention policy. Note that the retention policy is not by time but by the number of snapshots created by the
   script (snapshots created manually with different naming scheme will be ignored).
2. Copy notification script using Home Assistant to report problems: `cp ./scripts/notify.sh /usr/local/sbin/`. If you
   used a different IP for Home Assistant in the macvlan, update the script with `nano /usr/local/sbin/notify.sh` with
   the correct IP.
3. If you are not going to use DDNS, edit the script: `nano ./scripts/systemd-timers_setup.sh`. Remove the last line
   referring to DDNS. Save and exit with `Ctrl + X, Y, Enter`.
4. Run: `./scripts/systemd-timers_setup.sh`. We create scheduled tasks for ZFS pool scrubbing monthly on the 15th at 01:
   00; creating and purging ZFS snapshots daily at 00:00; container configuration backup daily at 23:00; update Docker
   images daily at 23:30; and IP update to DDNS every 5 minutes. If any task fails, the user will be notified via the
   Home Assistant webhook.
5. Copy notification script for smartd: `cp ./scripts/smart_error_notify.sh /usr/local/sbin/`. With this script we will
   write to the system log and also call our notification system.
6. Copy SMART tests configuration: `cp ./files/smartd.conf /etc/`. We run SHORT test weekly on Sundays at 00:00 and LONG
   test 1 time every two months, the first of the month at 01:00; and we use our notifications script.
7. Reload smartd for the changes to take effect: `systemctl restart smartd.service`.
8. Modify the ZED configuration to intercept mails: `nano /etc/zfs/zed.d/zed.rc`. Modify the `ZED_EMAIL_PROG` line
   with `ZED_EMAIL_PROG="/usr/local/sbin/notify.sh"`. Modify the `ZED_EMAIL_OPTS` line
   with `ZED_EMAIL_OPTS="'@SUBJECT@'"`. Save and exit with `Ctrl + X, Y, Enter`.
9. Reload ZED for the changes to take effect: `systemctl restart zed.service`.

### 6.15. Configure public external traffic

If you do not plan to access your server outside of your local network, you can skip this section.

We will do Port Forwarding of the HTTP and HTTPS ports for Nginx and port 51820 for WireGuard; we will disable IPv6 as
it would complicate the configuration too much; conditionally we will disable DHCP on the router or configure Pi-hole as
the DHCP DNS; we will configure Nginx to redirect traffic to the containers; and we will allow Nginx to act as a proxy
for Home Assistant.

#### 6.15.1. Steps

1. Configure the router. Each router is different, so you will have to consult your manual to be able to do the
   following steps.
    1. Forward port 80 and 443 in TCP protocol to the server so that Nginx can reverse proxy the internal services. If
       you plan to use private VPN with WireGuard, then also forward port 51820 in UDP to the server.
    2. Disable IPv6 because Pi-hole can only do IPv4 with the established configuration and it is more complex to
       configure it for IPv6.
    3. If your router allows you to configure the DNS that DHCP assigns to all devices in the house, then use Pi-hole's
       IP instead of the one provided by the ISP. Otherwise, you will have to disable DHCP so that Pi-hole is the DHCP
       and can assign itself as DNS. You can find Pi-hole's IP in Portainer if you view the stack in the editor and look
       at the `pihole` container configuration.
    4. Verify that the Pi-hole or router's DHCP is working (connect a device to the network and verify that it was
       assigned an IP in the configured range and that the DNS is the server's IP).
2. Configure proxy hosts in Nginx using DDNS.
    1. Access Nginx through http://192.168.1.253:8181.
    2. Use ` admin@example.com ` and `changeme` as username and password and change the details and password to a secure
       one. It is again recommended to use Bitwarden for the same.
    3. Navigate to the `SSL Certificates` tab.
    4. Press `Add SSL Certificate`. Select `Let's Encrypt` as certificate provider.
        1. Set up a wildcard domain SSL certificate with Let's Encrypt. For example `*.myhome.duckdns.org` (note the `*`
           at the beginning of the domain).
        2. You need to enable `Use DNS Challenge`.
        3. Select DuckDNS as the DNS provider.
        4. Replace `your-duckdns-token` with the token you generated on DuckDNS.org
        5. Accept the terms of service and save.
    5. Navigate to the “Proxy Hosts” tab and configure a proxy host for Jellyfin.
        1. In the `Details` tab fill out:
            - "Domain Names": jellyfin.myhome.duckdns.org.
            - "Scheme": http.
            - "Forward Hostname/IP": jellyfin. We can use the container name because Docker has an internal DNS that
              maps the container name to Docker's internal IP.
            - "Forward Port": 8096. Use the internal port of the container, not the port of the server to which it was
              mapped. Check the port of each container in the Portainer stack.
            - "BlockCommonExploits": enabled.
            - "Websockets Support": enabled. Jellyfin and Home Assistant need it, the other services don't seem to need
              it. If you notice any problems with any service when accessing it through Nginx (and not from the direct
              port), try enabling this option.
        2. In the `SSL` tab fill out:
            - "SSL Certificate": *.myhome.duckdns.org. We use the certificate created in step 4.
            - "Force SSL": enabled.
            - "HTTP/2 Support": enabled.
            - "HSTS Enabled": enabled.
            - "HSTS Subdomains": enabled.
        3. In the `Advanced` tab fill in (Note: this is only necessary for Jellyfin, the other services do not require
           anything in the `Advanced` tab):
            ```sh
            # Disable buffering when the nginx proxy gets very resource heavy upon streaming
            proxy_buffering off;

            # Proxy main Jellyfin traffic
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_headers_hash_max_size 2048;
            proxy_headers_hash_bucket_size 128;

            #Security/XSS Mitigation Headers
            # NOTE: X-Frame-Options may cause issues with the webOS app
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-XSS-Protection "0";
            add_header X-Content-Type-Options "nosniff";
            ```
        4. Repeat this step for Bazarr, Home Assistant, Jellyseerr, Prowlarr, Radarr, Sonarr and qBittorrent. **Do not
           expose Portainer or Cockpit with Nginx!**
3. Configure Home Assistant to allow traffic redirected by the Nginx Reverse Proxy.
    1. Edit Home Assistant configuration: `nano /Apps/homeassistant/configuration.yaml`.
    2. Add the following section to the end of the file. We allow proxies from the `172.21.3.0/24` network which is
       the `nginx` network that we configured in the stack in Portainer.
        ```yml
        http:
            use_x_forwarded_for: true
            trusted_proxies:
                - 172.21.3.0/24
        ```
    3. Save and exit with `Ctrl + X, Y, Enter`.
4. Reload the Home Assistant settings from the UI for the changes to take effect.
    1. Access Home Assistant through http://192.168.1.10:8123.
    2. Navigate to `Developer tools`.
    3. Press `Restart`.
5. You can test that Nginx works by accessing a service through the URL with its subdomain. For
   example https://jellyfin.myhome.duckdns.org. Try it from inside your local network to test split horizon DNS and from
   outside to test DDNS.

### 6.16. Configure private external traffic

WireGuard has actually already been configured in the Portainer stack and should already be running the VPN. The only
thing left is to configure the clients that are going to connect to it. This can be done in 2 ways: through a QR code or
through a `.conf` file. Once connected to this VPN, we will be able to access services that we did not expose publicly
with our Reverse Proxy such as Portainer and Cockpit, which are too critical to expose to attacks on the public
internet.

> [!NOTE]
> WireGuard was configured with split tunneling. If you want to redirect all client traffic, then you must change
> the `ALLOWEDIPS` variable in the stack in Portainer to `0.0.0.0/0`.

#### 6.16.1. Steps

1. If you want to configure with a QR code, do the following:
    1. Access Portainer on your local network from a device that is not the client you are configuring.
    2. Navigate to `local` > `Containers`.
    3. In the `wireguard` container row press the `exec console` button.
    4. Press `Connect`.
    5. Show the QR code for the client `phone` in the console with: `/app/show-peer phone`.
    6. From the device that will be the `phone` client (your cell phone for example), open the WireGuard application and
       select `Add tunnel`.
    7. Choose `Scan QR code` and scan the code that was displayed on the console.
    8. If you want to test that it works correctly, disconnect your device from the local network (turn off Wi-Fi for
       example) and enable the VPN. Try to access an IP on your local network.
2. If you want to configure with a configuration file, do the following (Note: the guide assumes a Linux device that
   already has the `wireguard-tools` package or equivalent installed. For other OS, please read the WireGuard
   documentation):
    1. Connect to the server from the device that will be the client with SSH: `ssh admin@192.168.1.253` .
    2. We show the configuration for the `laptop` client: `sudo cat /Apps/wireguard/peer_laptop/peer_laptop.conf`.
    3. Copy the contents of the file to the clipboard.
    4. Return to the client device console with `exit` or open a new console.
    5. We create the configuration file for a virtual network with the name `wg0`: `sudo nano /etc/wireguard/wg0.conf`.
    6. Paste the contents of the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
    7. If you want to test that it works correctly, disconnect your device from the local network (connect to your guest
       Wi-Fi network or from the public network of a cafe or use your cell phone as a modem) and enable the virtual
       network `wg0` with : `wg-quick up wg0`. Try to access an IP on your local network.

### 6.17. Install Cockpit

Finally we will install Cockpit with some plugins and configure the firewall to allow the Cockpit service to the local
network.

#### 6.17.1. Steps

1. Run: `./scripts/cockpit_setup.sh`. Installs Cockpit and its plugins and configures Firewalld to allow Cockpit on the
   network.
2. To test that it worked, access Cockpit through https://192.168.1.253:9090. Use your `admin` credentials.

**Congratulations! You now have your home server up and running and ready to go!**

## 7. Glossary

### Bittorrent

It is a communication protocol for peer-to-peer file sharing, that is, without a central server, which allows data to be
shared in a decentralized manner. It uses a server called a tracker that contains the list of available files and
clients that have a full or partial copy of the file. A client can use this list to then request parts of the file from
other clients and rebuild it at the end. The client can start sharing it with other clients from the moment they receive
their first piece so that the use of resources is optimized so as not to overload a single client. More
information: https://en.wikipedia.org/wiki/BitTorrent.

### SSL Certificate

The SSL protocol (as well as its successor TLS) use a "Public Key Certificate" to ensure that communication between a
client and a server is secure. A public key certificate is an electronic document used to prove the validity of a public
key. This contains the public key, the identity of the owner and a digital signature of an entity that has verified the
certificate. The certificate is presented by the server to the client, the client validates that the certificate matches
the address to which it wants to connect and that the certificate has been signed by a trusted authority (the client can
decide which authorities are trustworthy), thus proving that the server is indeed the desired destination. More
information: https://en.wikipedia.org/wiki/Public_key_certificate.

#### Wildcard domain certificate

A wildcard domain certificate is a certificate that not only covers traffic to a specific domain or subdomain, but also
any other subdomains below the domain specified in the certificate. For example a certificate with the destination *
.myhome.duckdns.org covers myhome.duckdns.org, jellyfin.myhome.duckdns.org, sonarr.myhome.duckdns.org, etc.

### Cockpit

Cockpit is a web-based graphical interface that allows server administration remotely, in one place, through a web
browser. Cockpit allows you to manage users, the network, storage, updates, SELinux, ZFS, Systemd, the journal, the
firewall, the metrics and if that were not enough, it has a terminal where you can do everything that cannot be done
graphically. Cockpit uses Linux users and passwords so it is not necessary to create an account but it is also very
important not to expose this service publicly and protect the password. More information: https://cockpit-project.org.

### Containers

It is a virtualization technique at the operating system level so that multiple applications can run in isolated user
spaces called containers with their own environment, avoiding collisions with other containers and the same host OS.
More information: https://en.wikipedia.org/wiki/Containerization_(computing).

### DNS

The Domain Name System is a system for naming computers in a hierarchical and distributed manner on networks that use
the IP protocol. Associates certain information with "Domain Names" that are assigned to the associated entities. The
most common use is to translate an easily memorized domain name into a numerical IP address to locate a computer on the
network. It is hierarchical since the servers that map a domain can delegate a subdomain to another server multiple
levels until reaching the last subdomain. More information: https://en.wikipedia.org/wiki/Domain_Name_System.

#### Domain

It is a string of characters that identifies a sphere of autonomous administration or authority or control. It is
usually used to identify services provided over the Internet. A domain name identifies a network domain or resource on a
network that uses the Internet protocol.

#### Subdomain

Domains are organized into subordinate levels (subdomains) of the root DNS domain, which has no name. The first level of
domains are called top-level domains such as "com", "net", "org", etc. Below these are second and third level domains
that are available for reservation by users who want to connect their network to the Internet and create public
resources such as a website.

#### Split Horizon DNS

If we try to access a URL with a domain from the local network (LAN) to which that domain belongs instead of a local IP,
the public DNS (for example DuckDNS) will return the public IP of the network and the router will not be able to resolve
it, since we will be trying to access the public IP from the same public IP. If we configure an internal DNS within the
local network (for example Pi-hole) to map the domain or even subdomains to local IPs, then we will create a mask that
will avoid erroneously redirecting local addresses. When a device is connected to this LAN, DHCP will assign the
internal DNS (Pi-hole) and it will intercept the domain instead of asking the public DNS (DuckDNS). If the same device
were to connect outside the local network, the DNS client will call a public DNS (DuckDNS) as usual, making it
transparent for clients to access a domain from any network without the need for the client to manipulate files on the
computer or use the local IP instead of the domain. This technique is known as Split Horizon DNS.

#### DDNS

A common problem for homes that want to expose themselves to external traffic is that the public IP can change at any
time if the ISP so wishes. Commonly only companies or institutions are assigned a static IP. If you try to use DNS to
map a domain, eventually the IP it points to will expire and the domain will be down. A dynamic DNS (DDNS) solves this.
Every DDNS (like DuckDNS) requires a client to update it from time to time with the public IP of the network by making a
call (with some type of authentication, of course) from within that network, the DDNS will automatically detect the
public IP of which the call is being made and it will update the DNS with that IP.

### DHCP

Dynamic Host Configuration Protocol is a networking protocol part of the Internet Protocol (IP) to automatically assign
an IP address and other parameters such as the router address and DNS of the network. This eliminates the need to
manually and individually configure each device on the network. The protocol works with a central DHCP server and a DHCP
client on each device that wants to connect. The client requests network parameters when it connects to the network and
periodically thereafter using the DHCP protocol broadcasting a message to the network waiting for a DHCP server to
listen and respond. More information: https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol.

### Firewall

The Firewall is a network security system that monitors and controls traffic based on predefined security rules that
allow or block traffic. It is usually used as a barrier between a trusted network and an untrusted network (such as the
Internet). More information: https://en.wikipedia.org/wiki/Firewall_(computing).

### IP

An IP address is a numerical label that is assigned to a device connected to a computer network that uses the Internet
Protocol to communicate. It serves two purposes: identification and addressing. The most used versions are IPv4 and
IPv6. More information: https://en.wikipedia.org/wiki/IP_address.

#### IPv4

An IPv4 address consists of 32 bits. It is usually represented with 4 decimal numbers from 0 to 255 separated by a
period, for example 192.168.1.0. Each number represents a group of 8 bits. Some IPv4 ranges are commonly used for
special purposes such as private networks.

#### IPv6

In IPv6 the size was increased from 32 bits to 128 bits. This is because the exponential growth of devices connected to
the Internet was quickly depleting available IPs. The notation is normally 8 groups of 4-digit Hexadecimal numbers
separated by `:`. for example 2001:0db8:85a3:0000:0000:8a2e:0370:7334

#### Subnet Mask/CIDR

In order to define the architecture of the networks, subnet masks were originally used, but little by little they have
been replaced by CIDR. The idea is to split the IP address into 2 parts: the network prefix, which identifies a subnet,
and the device identifier, which identifies a unique device on the subnet. Both the subnet mask and the CIDR are ways of
indicating the IP division. For example, the CIDR notation "10.0.0.0/8" denotes an IPv4 subnet with 8 prefix bits (
denoted by /8) and 24 identifier bits (the remainder of the 32 IPv4 bits), giving a subnet range from 10.0.0.0 to
10.255.255.255.

### LUKS

The Linux Unified Key Setup is a specification for disk encryption. The encryption is at the block level so any file
system can be encrypted with LUKS. More information: https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup.

### NAS

Network Attached Storage (NAS) is a file-level (rather than block-level) storage server connected to a network to
provide data access to a group of clients. The server is optimized to serve files through its hardware and software
configuration. They usually use the NFS or SMB file sharing protocols. More
information: https://en.wikipedia.org/wiki/Network-attached_storage.

### NAT

Network Address Translation is a method of mapping one range of IP addresses to another. It is typically used in "
one-to-many" mode which allows multiple private clients to be mapped to a public IP. Homes are typically assigned a
public IP by their Internet Service Provider (ISP). However, that IP is shared by all the devices in the home thanks to
a router that assigns private IPs to each of them and manages their traffic. This works because the traffic is initiated
from within the local network and the router can know who to redirect the response traffic to using NAT. More
information: https://en.wikipedia.org/wiki/Network_address_translation.

#### Port Forwarding

Port Forwarding is an application of NAT that translates one address and port to another when traffic is initiated from
outside the network. Without this, the router has no way of knowing who should receive the request (remember that
one-to-many NAT works from the inside out). Another way to solve this would be to configure the router to redirect all
externally initiated traffic to the server. This is not highly recommended as it would expose the server to malicious
users, for example, through the SSH port. The best solution is to port forward only the traffic received on the desired
ports such as 80 (HTTP) and 443 (HTTPS) to the server from the router.

### Reverse Proxy

A Reverse Proxy is an application that sits between a client and multiple servers and helps redirect traffic initiated
by the client to the correct server. They can have many uses, but in a home server it seeks to solve a problem with the
router's port forwarding. With port forwarding we can expose only one port, however, not all server applications can
listen on the same port. A reverse proxy then does something similar to NAT but in reverse and redirects the traffic
received on the port exposed with port forwarding to the different applications with the correct port. This is achieved
through rules that use the URL (the subdomain for example) in the request to identify the application to which to
redirect the traffic. More information: https://en.wikipedia.org/wiki/Reverse_proxy.

### Router

A Router is a network device that redirects data packets between networks. Packets are sent from one router to another
across multiple networks until they reach their destination. A router is therefore connected to two or more networks at
the same time. The router uses a routing table to compare the address of the packet to determine the next destination on
the packet's path. More information: https://en.wikipedia.org/wiki/Router_(computing).

### Samba

Samba is an open source implementation of the SMB file and printer sharing protocol intended for Microsoft clients.
Today both Linux and macOS have clients to connect to Samba servers. Samba defines shared resources known as shares for
directories defined on the system. Samba shares are managed in a configuration file that allows us to define which
directories to share, which users have access to the different shares, and which networks can access the Samba server.
Samba uses the same users as Linux, but has its own password database. That is why it is necessary to assign a Samba
password to each user created to use the shares. More information: https://en.wikipedia.org/wiki/Samba_(software).

### SecureBoot

Secure Boot is a protocol defined in the UEFI specification designed to secure the boot process by preventing loading
UEFI drivers or bootloaders that are not signed by an acceptable key. To enable it, you must first change the BIOS to "
Setup" mode in order to configure our public keys. Being able to load a bootloader at boot requires signing the files on
the `/efi` partition with the private key. Likewise, to load drivers at startup, it is necessary to register the driver
signature to the trusted signature database. Then it is necessary to exit "Setup" mode and enable Secure Boot. The BIOS
is normally password protected to prevent deactivation. More
information: https://en.wikipedia.org/wiki/UEFI#Secure_Boot.

### SELinux

Security-Enhanced-Linux (abbreviated SELinux) is a security module of the Linux kernel that provides a mechanism to
support access control security policies including Mandatory Access Controls (MAC). It allows imposing the separation of
information based on integrity and confidentiality requirements, limiting the damage that a malicious application could
cause. More information: https://en.wikipedia.org/wiki/Security-Enhanced_Linux.

### SMART

SMART, or S.M.A.R.T., is a monitoring system included in hard drives (HDDs) and solid state drives (SSDs). It is used to
detect and report disk status indicators in order to anticipate an imminent disk failure. This gives the user time to
prevent data loss and replace the drive to maintain data integrity. More
information: https://en.wikipedia.org/wiki/Self-Monitoring,_Analysis_and_Reporting_Technology.

#### smartd

Smartd is a daemon part of the "SMART monitor tools" package that in a configurable way monitors the SMART of the
different server disks and notifies when there is a problem through a script.

### VPN

A Virtual Private Network is a mechanism to create a secure connection between a device and a network or between two
networks using an insecure medium such as the Internet. This is created using a point-to-point connection through
tunneling protocols. A VPN allows us to access our local network as if we were physically connected to it. We will be
able to access services that we did not expose publicly with our Reverse Proxy such as Portainer and Cockpit, which are
too critical to expose to attacks on the public internet. More
information: https://en.wikipedia.org/wiki/Virtual_private_network.

#### Split Tunneling

Typically a VPN redirects all of a client's traffic through it. It is possible to configure the VPN to only redirect
traffic in a certain range of IPs (such as your local network) and not redirect the rest. If you browse to any other IP
from that client (for example to google.com), it will use its normal network and therefore the public IP of the client
device. This configuration is called Split Tunneling.

#### WireGuard

It is a VPN implementation that uses asymmetric encryption to ensure that no one can connect without the
server-generated key. Its goal is to be a simple, fast, modern, and efficient VPN.

### ZFS

It is a file system with both physical and logical volume management capabilities. Having knowledge of both the file
system and the physical disk allows it to efficiently manage data. It is focused on ensuring that data is not lost due
to physical errors, operating system errors, or corruption over time. It employs techniques such as COW, snapshots and
replication for greater robustness. More information: https://en.wikipedia.org/wiki/ZFS.

#### COW

Copy-on-write (abbreviated COW) is a technique in which any modified data does not overwrite the original data but is
written separately and then the original can be deleted, ensuring that the data is not lost in case of an error while
writing.

#### Snapshots

COW allows retaining old blocks that would be discarded in a "snapshot" that allows restoring to a previous version of
the dataset. Only the differential between two snapshots is saved so it is very efficient in terms of space.

#### RAID

It is a technology that allows multiple physical disks to be combined into one or more logical drives for the purpose of
data redundancy, performance improvement, or both. ZFS has its own RAID implementation. In ZFS `raidz` is equivalent to
RAID5 which allows you to have one redundant disk, that is, a single disk can fail before the pool loses data.
While `raidz2` is equivalent to RAID6 it allows 2 redundant disks.

## 8. Buy me a coffee

You can always buy me a coffee here:

[![PayPal](https://img.shields.io/badge/PayPal-Donate-blue.svg?logo=paypal&style=for-the-badge)](https://www.paypal.com/donate/?business=AKVCM878H36R6&no_recurring=0&item_name=Buy+me+a+coffee&currency_code=USD)
[![Ko-Fi](https://img.shields.io/badge/Ko--fi-Donate-blue.svg?logo=kofi&style=for-the-badge)](https://ko-fi.com/jurgencruz)

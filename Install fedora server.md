# Install Fedora Server

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Install%20fedora%20server.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Install%20fedora%20server.es.md)

To install Fedora Server we will need a USB stick and to download the ISO from the official Fedora website. We will write the ISO to the USB and start the operating system installer. We'll configure our installation and let the wizard do the rest. The guide assumes that you will prepare the installation media from a Linux operating system. If you are doing this from Windows, you can try using the Rufus tool and its guide: https://rufus.ie/.

> [!CAUTION]
> **Before starting make sure to backup the data on the USB stick as it will be formatted and all the data on it will be lost!**

> [!CAUTION]
> **Before starting make sure to backup the data on the server disks as these will be formatted and all data on them will be lost!**

## Steps

1. Go to https://fedoraproject.org/server/download and download the "Network Install" ISO for your architecture (normally x86_64). If you want, you can verify the file signature with the hash on the same page.
2. Insert the USB stick and determine the device using `lsblk`. Find the USB stick in the list and write down the name, for example `sdc`.
3. If your system mounted the USB automatically, unmount with `sudo umount /dev/sdc*`.
4. Write the ISO to the USB with `dd if=./Fedora-Server-netinst-x86_64-39-1.5.iso of=/dev/sdc bs=8M status=progress`. Set the address to the ISO file in the command.
5. Remove the USB stick and insert it into the server. If the server is on, turn it off.
6. Turn on the server and access the BIOS (try the F2 or Insert key or read your motherboard manual).
7. Disable Secure Boot if it is active. Each BIOS is different so consult your manual to find the option.
8. Select the option to boot from USB. If you can't, try changing the order of boot devices and putting the USB before other disks. Save and restart. The Fedora installer should start. If not, try changing the boot order again.
9. Select "Test media & install Fedora".
10. Select the language of your preference and Continue. The guide will assume English.
11. If you want to use another keyboard layout, click `Keyboard` and select one or more layouts. Press `Done` to return to the main menu.
12. If you want to install more languages, click `Language Support` and select one or more languages. Press `Done` to return to the main menu.
13. Click on `Time & Date` and choose your region and city to select your time zone. Make sure you enable `Network Time`. Press `Done` to return to the main menu.
14. Click on `Software Selection`.
15. `Fedora Server Edition` should be selected by default, if not, select it. In `Additional Software` you don't need to select anything, but if you like you can install whatever you want. Press `Done` to return to the main menu.
16. Click `Network & Host Name` and set the `Host Name`. The guide will use `server.lan` but you can use another name. Press `Done` to return to the main menu.
17. Click on `User Creation`. Enter `admin` in `User name` (if you want to use another name, use another one, but the guide will assume `admin` and you will need to adjust files in the future with the name you choose). Do not uncheck any boxes.
18. Enter a strong password and confirm it. Press `Done` to return to the main menu.
19. Click on `Installation Destination` and configure the partitions. The guide assumes that nothing else will be running on this server and will wipe all partitions. If you know what you're doing and want a different setup, skip the steps below and configure the partitions however you want.
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
        7. `Mountpoint` must be `/`.
        8. Accept.
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
31. Shut down the server: `shutdown`.

[<img width="33.3%" src="buttons/prev-Guide.svg" alt="Guide">](Guide.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Configure secure boot.svg" alt="Configure Secure Boot">](Configure%20secure%20boot.md)

# Configure Secure Boot

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20secure%20boot.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20secure%20boot.es.md)

Secure Boot will be configured with owner keys and a password will be set to the BIOS to prevent its deactivation.

## Steps

1. Turn on the server and enter the BIOS (usually with the `F2` key).
2. Configure Secure Boot in "Setup" mode, save and reboot.
3. After logging in with `admin`, run: `sudo ./scripts/secureboot.sh`.
4. If there were no errors, then run `reboot` to reboot and enter the BIOS again.
5. Exit "Setup" mode and enable Secure Boot.
6. Set a password to the BIOS, save and reboot.
7. After logging in with `admin`, run: `sbctl status`. The message should say that it is installed and Secure Boot is enabled.

[<img width="33.3%" src="buttons/prev-Install fedora server.svg" alt="Install Fedora Server">](Install%20fedora%20server.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Install and configure zsh optional.svg" alt="Install and configure Zsh (Optional)">](Install%20and%20configure%20zsh%20optional.md)

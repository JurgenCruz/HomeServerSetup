# Configure scheduled tasks

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20scheduled%20tasks.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20scheduled%20tasks.es.md)

We will automate the following tasks: automatic creation and purging of ZFS snapshots; ZFS pool scrubbing; container configuration backup; container images update to the latest version; short and long hard drive tests with SMART; and public IP update in DDNS. If you notice that any script does not have the executable flag, make it executable with the command `chmod 775 <file>` replacing `<file>` with the name of the script.

## Steps

1. Copy script for managing ZFS snapshots: `cp ./scripts/snapshot-with-purge.sh /usr/local/sbin/`. This script creates recursive snapshots of all datasets in a pool with the same time stamp. Then it purges the old snapshots according to the retention policy. Note that the retention policy is not by time but by the number of snapshots created by the script (snapshots created manually with different naming scheme will be ignored).
2. Copy notification script using Home Assistant to report problems: `cp ./scripts/notify.sh /usr/local/sbin/`. If you used a different IP for Home Assistant in the macvlan, update the script with `nano /usr/local/sbin/notify.sh` with the correct IP.
3. If you are not going to use DDNS, edit the script: `nano ./scripts/systemd-timers_setup.sh`. Remove the last line referring to DDNS. Save and exit with `Ctrl + X, Y, Enter`.
4. Run: `./scripts/systemd-timers_setup.sh`. We create scheduled tasks for ZFS pool scrubbing monthly on the 15th at 01:00; creating and purging ZFS snapshots daily at 00:00; container configuration backup daily at 23:00; update Docker images daily at 23:30; and IP update to DDNS every 5 minutes. If any task fails, the user will be notified via the Home Assistant webhook.
5. Copy notification script for smartd: `cp ./scripts/smart_error_notify.sh /usr/local/sbin/`. With this script we will write to the system log and also call our notification system.
6. Copy SMART tests configuration: `cp ./files/smartd.conf /etc/`. We run SHORT test weekly on Sundays at 00:00 and LONG test 1 time every two months, the first of the month at 01:00; and we use our notifications script.
7. Reload smartd for the changes to take effect: `systemctl restart smartd.service`.
8. Modify the ZED configuration to intercept mails: `nano /etc/zfs/zed.d/zed.rc`. Modify the `ZED_EMAIL_PROG` line with `ZED_EMAIL_PROG="/usr/local/sbin/notify.sh"`. Modify the `ZED_EMAIL_OPTS` line with `ZED_EMAIL_OPTS="'@SUBJECT@'"`. Save and exit with `Ctrl + X, Y, Enter`.
9. Reload ZED for the changes to take effect: `systemctl restart zed.service`.

[<img width="50%" src="buttons/prev-Configure applications.svg" alt="Configure applications">](Configure%20applications.md)[<img width="50%" src="buttons/next-Configure public external traffic.svg" alt="Configure public external traffic">](Configure%20public%20external%20traffic.md)

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

# Configure scheduled tasks

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20scheduled%20tasks.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20scheduled%20tasks.es.md)

We will automate the following tasks: automatic creation and purging of ZFS snapshots; ZFS pool scrubbing; container configuration backup; container images update to the latest version; short and long hard drive tests with SMART; and public IP update in DDNS. If you notice that any script does not have the executable flag, make it executable with the command `chmod 775 <file>` replacing `<file>` with the name of the script.

## Steps

1. Copy script for managing ZFS snapshots: `cp ./scripts/snapshot-with-purge.sh /usr/local/sbin/`. This script creates recursive snapshots of all datasets in a pool with the same time stamp. Then it purges the old snapshots according to the retention policy. Note that the retention policy is not by time but by the number of snapshots created by the script (snapshots created manually with different naming scheme will be ignored).
2. Copy notification script using Home Assistant to report problems: `cp ./scripts/notify.sh /usr/local/sbin/`. If you used a different IP for Home Assistant in the macvlan, update the script with `nano /usr/local/sbin/notify.sh` with the correct IP.
3. Copy the Docker apps image update script: `cp ./scripts/apps-update.sh /usr/local/sbin/`. This script loops the Portainer list of stacks and updates the images and restarts the containers that have new images.
4. If you are not going to use DDNS, edit the script: `nano ./scripts/systemd-timers_setup.sh`. Remove the last line referring to DDNS. Save and exit with `Ctrl + X, Y, Enter`.
5. Run: `./scripts/systemd-timers_setup.sh`. We create scheduled tasks for ZFS pool scrubbing monthly on the 15th at 01:00; creating and purging ZFS snapshots daily at 00:00; container configuration backup daily at 23:00; update Docker images daily at 23:30; and IP update to DDNS every 5 minutes. If any task fails, the user will be notified via the Home Assistant webhook.
6. Copy notification script for smartd: `cp ./scripts/smart_error_notify.sh /usr/local/sbin/`. With this script we will write to the system log and also call our notification system.
7. Copy SMART tests configuration: `cp ./files/smartd.conf /etc/`. We run SHORT test weekly on Sundays at 00:00 and LONG test 1 time every two months, the first of the month at 01:00; and we use our notifications script.
8. Reload smartd for the changes to take effect: `systemctl restart smartd.service`.
9. Modify the ZED configuration to intercept mails: `nano /etc/zfs/zed.d/zed.rc`. Modify the `ZED_EMAIL_PROG` line with `ZED_EMAIL_PROG="/usr/local/sbin/notify.sh"`. Modify the `ZED_EMAIL_OPTS` line with `ZED_EMAIL_OPTS="'@SUBJECT@'"`. Save and exit with `Ctrl + X, Y, Enter`.
10. Reload ZED for the changes to take effect: `systemctl restart zed.service`.

**Congratulations! You now have your home server up and running and ready to go!**

[<img width="33.3%" src="buttons/prev-Create and configure public external traffic stack optional.svg" alt="Create and configure public external traffic stack (Optional)">](Create%20and%20configure%20public%20external%20traffic%20stack%20optional.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Glossary.svg" alt="Glossary">](Glossary.md)

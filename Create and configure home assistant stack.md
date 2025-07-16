# Create and configure Home Assistant stack

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20home%20assistant%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20home%20assistant%20stack.es.md)

We will configure the Home Assistant Docker stack and bring the stack up through Portainer. The stack consists of the following container:

- Home Assistant: Home automation engine.

## Steps

1. Run: `./scripts/create_home_assistant_folder.sh` to generate the container directory on the SSD.
2. Edit the stack file: `nano ./files/home-assistant-stack.yml`.
3. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Set the attribute `ipv4_address` in the `homeassistant` container with an IP in the non-assignable range of the DHCP. For example 192.168.1.11.
5. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
6. Add stack in Portainer from the browser.
    1. Access Portainer through https://192.168.1.253:9443. If you get a security alert, you can accept the risk since Portainer uses a self-signed SSL certificate.
    2. Click "Get Started" and then select "local."
    3. Select "Stacks" and create a new stack.
    4. Name it "home-assistant" and paste the content of the home-assistant-stack.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Portainer and not in the file.
7. Access Home Assistant through http://192.168.1.11:8123.
8. Use the wizard to create a user account and password. It is again recommended to use Bitwarden for the same.
9. Configure the name of the Home Assistant instance and your data and preferences with the wizard.
10. Choose whether you want to send usage data to the Home Assistant page.
11. Finish the wizard.
12. Configure Webhook for notifications.
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
    12. If you want to receive notifications on your cell phone, you must first download the application to your cell phone and log in to Home Assistant from it. Then configure the following:
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

[<img width="33.3%" src="buttons/prev-Create shared networks stack.svg" alt="Create shared networks stack">](Create%20shared%20networks%20stack.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Create and configure private external traffic stack optional.svg" alt="Create and configure private external traffic stack (Optional)">](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.md)

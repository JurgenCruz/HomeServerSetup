# Create and configure Home Assistant stack

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20home%20assistant%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20home%20assistant%20stack.es.md)

We will configure the Home Assistant Docker stack and bring the stack up through Portainer. The stack consists of the following container:

- Home Assistant: Home automation engine.
- Whisper: Speech-to-text through AI service.
- Piper: Text-to-speech through AI service.
- Ollama: LLM chat engine.
- Z-WaveJS: Z-Wave device driver.

## Steps

1. If you are not going to use Z-Wave devices, edit the script: `nano ./scripts/create_home_assistant_folder.sh` and delete the last 3 lines related to `zwavejs`. Save and exit with `Ctrl + X, Y, Enter`.
2. Run: `./scripts/create_home_assistant_folder.sh` to generate the containers' directories on the SSD.
3. If you are going to use Zigbee or Z-Wave usb dongles, make sure to connect them to your server in an usb port.
4. Run: `ls /dev/serial/by-id/` and write down the paths of your usb dongles. For example `/dev/serial/by-id/usb-Itead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_V2_12345678901234567890123456789012-1234-port0`.
5. Edit the stack file: `nano ./files/home-assistant-stack.yml`.
6. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
7. Set the attribute `ipv4_address` in the `homeassistant` container with an IP in the non-assignable range of the DHCP. For example 192.168.1.11.
8. If you have an Nvidia GPU, skip this step. Delete or comment out the uncommented `whisper` and `piper` sections and then uncomment the commented `whisper` and `piper` sections. Under the `ollama` section, delete or comment out the entire `runtime` and `deploy` properties.
9. If you want, you can change the whisper container's model (`medium-int8`) to a smaller or bigger model depending on your hardware. Available options are: `tiny, base, small, medium, large & turbo`.
10. Under the `homeassistant` container, under `devices`, replace the device `/dev/serial/by-id/usb-zigbee_dongle` with the path to your Zigbee dongle. If you don't have a Zigbee dongle, delete the `devices` section from this container.
11. Under the `zwavejs` container, under `devices`, replace the device `/dev/serial/by-id/usb-zwavejs_dongle` with the path to your Z-Wave dongle. If you don't have a Z-Wave dongle, delete the entire container. Notice that the device is being mapped to `:/dev/zwave`. This is important because it is the default path the service will look for. If you don't map it, you will need to manually configure the path of the device.
12. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
13. Add stack in Portainer from the browser.
    1. Access Portainer through https://portainer.myhome.duckdns.org.
    2. Click "Get Started" and then select "local."
    3. Select "Stacks" and create a new stack.
    4. Name it "home-assistant" and paste the content of the home-assistant-stack.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Portainer and not in the file.
14. Access Home Assistant through https://homeassistant.myhome.duckdns.org.
15. Use the wizard to create a user account and password. It is again recommended to use Bitwarden for the same.
16. Configure the name of the Home Assistant instance and your data and preferences with the wizard.
17. Choose whether you want to send usage data to the Home Assistant page.
18. Finish the wizard.
19. Configure Restful Command for notifications.
    1. Edit Home Assistant configuration: `nano /Apps/homeassistant/configuration.yaml`.
    2. Add the following section to the end of the file. Replace the `{your_token_here}` with the Home Assistant token you generated in Gotify and `myhome` with your domain registered in DuckDNS. We register a restful command that communicates with Gotify to send notifications.
        ```yml
        rest_command:
            notify_through_gotify:
                url: "https://gotify.myhome.duckdns.org/message?token={your_token_here}"
                method: "post"
                content_type: "application/json"
                payload: '{ "title": "{{ title }}", "message": "{{ message }}", "priority": {{ priority }} }'
        ```
    3. Add the following section to the end of the file. We allow proxies from the `172.21.1.0/24` network which is the `homeassistant` network that we configured in the stack in Portainer.
        ```yml
        http:
            use_x_forwarded_for: true
            trusted_proxies:
                - 172.21.1.0/24
        ```
    4. Save and exit with `Ctrl + X, Y, Enter`.
    5. Back in Home Assistant, navigate to `Developer tools`.
    6. Press `Restart`. Now you can create automations that call this service and get notifications through Gotify.
20. Configure Voice Assistant.
    1. Navigate to "Settings" > "Devices & Services".
    2. Click "Add Integration".
    3. Search for "Wyoming Protocol" and select it.
    4. Set Host to `whisper`.
    5. Set Port to `10300`.
    6. Click "Submit".
    7. Click "Wyoming Protocol".
    8. Click "Add Service".
    9. Set Host to `piper`.
    10. Set Port to `10200`.
    11. Click "Submit".
    12. Go back to "Integrations".
    13. Click "Add Integration".
    14. Search for "Ollama" and select it.
    15. Set Url to `http://ollama:11434`.
    16. Click "Submit".
    17. Click "Ollama".
    18. Click the "..." button next to "http://ollama:11434".
    19. Click "Add conversation agent".
    20. Select the model you wish to use. The recommended is `qwen2.5:7b-instruct`.
    21. Enable "Assist" under "Control Home Assistant".
    22. Click "Submit".
    23. If "Ollama Conversation" does not show "1 service and 1 entity", click the same "..." as before and click "Reload".
    24. Navigate to "Settings" > "Voice Assistants".
    25. Select "Home Assistant".
    26. Set "Conversation agent" to `Ollama Conversation`.
    27. Set "Speech-to-text" to `faster-whisper`.
    28. Set "Text-to-speech" to `piper`.
    29. You can change the Language for the assistant, Speech-to-Text and Text-to-Speech. You can also change the voice for Text-to-Speech.
    30. Click "Update".
21. Configure Zigbee Automation (Only if you have Zigbee dongle).
    1. Navigate to "Settings" > "Devices & Services".
    2. Home Assistant should autodetect and suggest you to add the "Zigbee Home Automation". Add the integration.
    3. Select from the dropdown the device path of your Zigbee dongle and click "Submit".
    4. You can now register your Zigbee devices, but that is out of the scope of this guide.
22. Configure Z-Wave Automation (Only if you have Z-Wave dongle).
    1. Access in another tab to https://zwavejs.myhome.duckdns.org.
    2. Click the settings icon.
    3. Under `General`, enable `Auth`. This will log you out.
    4. Log back in using `admin` and `zwave` as credentials.
    5. Click the lock pad icon to change the password. It is again recommended to use Bitwarden for the same.
    6. Back in the settings page, Under `Z-Wave`, generate the 6 Security Keys using the randomizer icon. Backup these keys in a safe location like Bitwarden.
    7. Choose your RF Region.
    8. Under `Home Assistant`, enable `WS Server` and set the `Server Host` to `zwavejs`.
    9. Click "Save".
    10. Back in Home Assistant tab, navigate to "Settings" > "Devices & Services".
    11. Click "Add integration".
    12. Search for `Z-Wave` integration.
    13. Enter `ws://zwavejs:3000` and click "Submit".
    14. You can now register your Z-Wave devices, but that is out of the scope of this guide.

> [!TIP]
> If you want to use a small external device for voice commands similar to Alexa, check this guide to build you own Wyoming Satellite: https://www.youtube.com/watch?v=Bd9qlR0mPB0.

> [!TIP]
> You can test your new voice assistant from your mobile phone with the Home Assistant app. From the Dashboard, click the "..." at the top and select "Assistant" to launch the Assistant.

[<img width="33.3%" src="buttons/prev-Create and configure arr applications stack.svg" alt="Create and configure arr applications stack">](Create%20and%20configure%20arr%20applications%20stack.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Create and configure private external traffic stack optional.svg" alt="Create and configure private external traffic stack (Optional)">](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.md)
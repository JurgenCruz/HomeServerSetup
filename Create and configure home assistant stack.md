# Create and configure Home Assistant stack

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20home%20assistant%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20home%20assistant%20stack.es.md)

We will configure the Home Assistant Docker stack and bring the stack up through Portainer. The stack consists of the following container:

- Home Assistant: Home automation engine.
- Whisper: Speech-to-text through AI service.
- Piper: Text-to-speech through AI service.
- Ollama: LLM chat engine.

## Steps

1. Run: `./scripts/create_home_assistant_folder.sh` to generate the containers' directories on the SSD.
2. Edit the stack file: `nano ./files/home-assistant-stack.yml`.
3. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Set the attribute `ipv4_address` in the `homeassistant` container with an IP in the non-assignable range of the DHCP. For example 192.168.1.11.
5. If you have an Nvidia GPU, skip this step. Delete or comment out the uncommented `whisper` and `piper` sections and then uncomment the commented `whisper` and `piper` sections. Under the `ollama` section, delete or comment out the entire `runtime` and `deploy` properties.
6. If you want, you can change the whisper container's model (`medium-int8`) to a smaller or bigger model depending on your hardware. Available options are: `tiny, base, small, medium, large & turbo`.
7. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
8. Add stack in Portainer from the browser.
    1. Access Portainer through https://192.168.1.253:9443. If you get a security alert, you can accept the risk since Portainer uses a self-signed SSL certificate.
    2. Click "Get Started" and then select "local."
    3. Select "Stacks" and create a new stack.
    4. Name it "home-assistant" and paste the content of the home-assistant-stack.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Portainer and not in the file.
9. Access Home Assistant through http://192.168.1.11:8123.
10. Use the wizard to create a user account and password. It is again recommended to use Bitwarden for the same.
11. Configure the name of the Home Assistant instance and your data and preferences with the wizard.
12. Choose whether you want to send usage data to the Home Assistant page.
13. Finish the wizard.
14. Configure Webhook for notifications.
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
15. Configure Voice Assistant.
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
    20. Select the model you wish to use. The recommended is `llama3.2`.
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

> [!TIP]
> If you want to use a small external device for voice commands similar to Alexa, check this guide to build you own Wyoming Satellite: https://www.youtube.com/watch?v=Bd9qlR0mPB0.

> [!TIP]
> You can test your new voice assistant from your mobile phone with the Home Assistant app. From the Dashboard, click the "..." at the top and select "Assistant" to launch the Assistant.

[<img width="33.3%" src="buttons/prev-Create and configure nextcloud stack.svg" alt="Create and configure Nextcloud stack">](Create%20and%20configure%20nextcloud%20stack.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Create and configure private external traffic stack optional.svg" alt="Create and configure private external traffic stack (Optional)">](Create%20and%20configure%20private%20external%20traffic%20stack%20optional.md)

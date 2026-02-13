# Create and configure AI stack

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Create%20and%20configure%20ai%20stack.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Create%20and%20configure%20ai%20stack.es.md)

We will configure the Artificial Intelligence Docker stack and bring the stack up through Portainer. The stack consists of the following containers:

- Whisper: Speech-to-text through AI service.
- Piper: Text-to-speech through AI service.
- Ollama: LLM chat engine.
- Open WebUI: AI platform for local AI execution
- ComfyUI: Node-based generative AI workflow engine

## Steps

1. Run: `./scripts/create_ai_folder.sh` to generate the containers' directories on the SSD.
2. Edit the stack file: `nano ./files/ai-stack.yml`.
3. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. If you have an Nvidia GPU, skip this step. Delete or comment out the uncommented `whisper` and `piper` sections and then uncomment the commented `whisper` and `piper` sections. Under the `ollama` and `comfyui` sections, delete or comment out the entire `runtime` and `deploy` properties.
5. If you don't have an Nvidia GPU, under the `comfyui` section. change the property `image` to `sinfallas/comfyui:0.9.2-intel` if you have an Intel GPU or to `sinfallas/comfyui:0.9.2-amd` if you have AMD GPU.
6. If you want, you can change the whisper container's model (`medium-int8`) to a smaller or bigger model depending on your hardware. Available options are: `tiny, base, small, medium, large & turbo`.
7. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
8. Add stack in Portainer from the browser.
    1. Access Portainer through https://portainer.myhome.duckdns.org.
    2. Click "Get Started" and then select "local."
    3. Select "Stacks" and create a new stack.
    4. Name it "ai" and paste the content of the ai-stack.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Portainer and not in the file.
9. Configure ComfyUI.
    1. Access ComfyUI through https://comfyui.myhome.duckdns.org.
    2. Click "Manager".
    3. Click "Model Manager".
    4. Search the model you would like to use for image generation and click "Install".
    5. Close the dialogs and in the `Load Checkpoint` node, change the model to the one you just installed.
    6. Click the file menu and select `Export (API)` and save the file on your PC. If you don't see this option, click `Settings` and under `Comfy` tab, enable `Dev Mode` and try again.
10. Configure Open WebUI.
    1. Access Open WebUI through https://openwebui.myhome.duckdns.org.
    2. Use the wizard to create a user account and password. It is again recommended to use Bitwarden for the same.
    3. Click on your user's icon and select `Admin Panel`.
    4. Click the `Settings` tab.
    5. If you want to allow more people to create accounts, enable `Enable New Sign Ups`. By default, an admin needs to approve it. If you don't want to need to approve, change `Default User Role` to `user` and click `Save`.
    6. Click the `Connections` section.
    7. Disable `OpenAI API` and enable `Ollama API`.
    8. Set `http://ollama:11434` as the url.
    9. Click `Save`.
    10. Click the `Models` section.
    11. Click the `Manage Models` icon in the top right corner. Here you can download and delete models to your ollama instance. For Home Assistant, it is recommended to download `qwen2.5:7b-instruct`. For regular chatting, you can also use `gemma3:12b`, `mistral-nemo:12b` or `qwen3:14b`.
    12. Click the `Web Search` section.
    13. If you want to allow your model to search the internet, enable `Web Search`. You can use `DDGS` search engine with `DuckDuckGo` as the backend or which ever engine you prefer. Click `Save`.
    14. Click the `Images` section.
    15. Enable `Image Generation`.
    16. Set `Model` to the filename of the model you downloaded in ComfyUI including the extension.
    17. Set `Image Generation Engine` to `ComfyUI`.
    18. Set `ComfyUI Base URL` to `http://comfyui:8188`.
    19. Under `ComfyUI Workflow` click `Upload` and upload the file you saved from ComfyUI.
    20. Under `ComfyUI Workflow Nodes` you will need to map the properties to the node's ids. For a detailed guide see: https://docs.openwebui.com/features/image-generation-and-editing/comfyui/#identifying-node-ids-and-input-keys-in-comfyui.
    21. Click `Save`.

[<img width="33.3%" src="buttons/prev-Create and configure arr applications stack.svg" alt="Create and configure arr applications stack">](Create%20and%20configure%20arr%20applications%20stack.md)[<img width="33.3%" src="buttons/jump-Index.svg" alt="Index">](README.md)[<img width="33.3%" src="buttons/next-Create and configure home assistant stack.svg" alt="Create and configure Home Assistant stack (Optional)">](Create%20and%20configure%20home%20assistant%20stack.md)
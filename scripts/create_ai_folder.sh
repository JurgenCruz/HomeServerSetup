#!/bin/bash

mkdir /Apps/whisper
chown mediacenter:mediacenter /Apps/whisper
chmod 774 /Apps/whisper
mkdir /Apps/piper
chown mediacenter:mediacenter /Apps/piper
chmod 774 /Apps/piper
mkdir /Apps/ollama
chown mediacenter:mediacenter /Apps/ollama
chmod 774 /Apps/ollama
mkdir /Apps/openwebui
chown mediacenter:mediacenter /Apps/openwebui
chmod 774 /Apps/openwebui
mkdir -p /Apps/comfyui/models
mkdir /Apps/comfyui/output
mkdir /Apps/comfyui/custom_nodes
chmod -R 774 /Apps/comfyui
git clone https://github.com/Comfy-Org/ComfyUI-Manager /Apps/comfyui/custom_nodes/comfyui-manager
chown -R mediacenter:mediacenter /Apps/comfyui

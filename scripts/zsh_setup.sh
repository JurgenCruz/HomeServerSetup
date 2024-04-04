#!/bin/bash

sudo dnf install -y zsh zsh-autosuggestions zsh-syntax-highlighting
cp ./files/.zshrc "$HOME" # Copy an already configured .zshrc file for the user
chsh -s /usr/bin/zsh # Make Zsh the default shell for the user
sudo cp ./files/.zshrc /root # Repeat for root user
sudo chsh -s /usr/bin/zsh

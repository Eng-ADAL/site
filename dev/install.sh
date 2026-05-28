#!/usr/bin/env bash

set -e

echo "Updating package lists..."
sudo apt update

echo "Installing Sway environment..."

sudo apt install -y \
    sway \
    swaybg \
    swayidle \
    swaylock \
    waybar \
    wofi \
    foot \
    mako-notifier \
    network-manager \
    network-manager-gnome \
    pipewire \
    wireplumber \
    pipewire-audio \
    pipewire-pulse \
    pavucontrol \
    brightnessctl \
    playerctl \
    wl-clipboard \
    grim \
    slurp \
    xdg-desktop-portal-wlr \
    policykit-1 \
    fonts-noto \
    fonts-font-awesome \
    firmware-linux \
    firmware-iwlwifi \
    firmware-sof-signed

echo "Installation complete."
echo "Reboot recommended."

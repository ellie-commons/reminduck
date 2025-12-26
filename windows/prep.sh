#!/bin/bash
# Script to prepare the environment

# Line below for copypaste in msis2 console because im not retyping that
# cd /c/Documents\ and\ Settings/TC/Desktop/jorts

mkdir -pv windows/deploy

alias pacman='pacman --noconfirm'
pacman -Syu
pacman -S meson gcc ninja
pacman -S mingw-w64-x86_64-desktop-file-utils
pacman -S mingw-w64-ucrt-x86_64-{gtk4,vala,ninja,meson,nsis,gcc}
pacman -S mingw-w64-ucrt-x86_64-granite7
pacman -S mingw-w64-libgee mingw-w64-gsettings-desktop-schemas
pacman -S mingw-w64-x86_64-gtk-elementary-theme mingw-w64-x86_64-elementary-icon-theme
pacman -S mingw-w64-ucrt-x86_64-vala mingw-w64-x86_64-vala
pacman -S mingw-w64-x86_64-librsvg

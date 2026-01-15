#!/usr/bin/env bash

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro --filesystem=xdg-config/gtk-2.0:ro --filesystem=xdg-config/gtk-4.0:ro --filesystem=xdg-config/gtkrc:ro
flatpak override --user --filesystem=~/.themes
flatpak override --user --filesystem=~/.icons

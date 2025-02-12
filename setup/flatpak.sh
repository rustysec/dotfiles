#!/usr/bin/env bash

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak override --system --filesystem=xdg-config/gtk-3.0:ro --filesystem=xdg-config/gtk-2.0:ro --filesystem=xdg-config/gtk-4.0:ro --filesystem=xdg-cronfig/gtkrc:ro

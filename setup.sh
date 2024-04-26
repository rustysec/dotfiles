#!/usr/bin/env bash

DISTRO=`lsb_release -a | grep Description | awk '{print $2}' | tr A-Z a-z`

if [ -e ./distro/$DISTRO.sh ];
then
    echo "- Running $DISTRO setup"
    ./distro/$DISTRO.sh
else
    echo "! Unknown setup distro $DISTRO"
fi

(mkdir -p ~/.config 2>/dev/null && echo "- Created ~/.config") || echo "- ~/.config already created..."

echo "- Linking all config folders"

for dir in config/*;
do
    echo "-- Setting up $dir"
    if test -f ~/.$dir;
    then
        rm -f ~/.$dir
    fi

    mkdir ~/.$dir 2>/dev/null

    for file in `pwd`/$dir;
    do
        rm -f ~/.$file 2>/dev/null || true
        ln -s `pwd`/$file ~/.$file
    done
done

mkdir ~/.zsh 2>/dev/null || true

git clone https://github.com/tmux-plugins/tmux-sensible ~/.config/tmux/plugins/sensible
git clone https://github.com/catppuccin/tmux ~/.config/tmux/plugins/catppuccin

# Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh syntax
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# syntax theme
git clone https://github.com/catppuccin/zsh-syntax-highlighting.git \
    ~/.zsh/catppuccin

CTP_VERSION="v0.7.3"
if [ ! -e ~/.themes/Catppuccin-Mocha-Standard-Blue-Dark ]; then \
  mkdir -p ~/.themes \
  && curl -L https://github.com/catppuccin/gtk/releases/download/$CTP_VERSION/Catppuccin-Mocha-Standard-Blue-Dark.zip -o ~/.themes/catppuccin.zip \
  && unzip ~/.themes/catppuccin.zip -d ~/.themes/ \
  && rm -rf ~/.themes/catppuccin.zip;
fi

CTP_CURSOR_VERSION="v0.2.0"
if [ ! -e ~/.themes/Catppuccin-Mocha-Dark-Cursors ]; then \
  mkdir -p ~/.icons \
  && curl -L https://github.com/catppuccin/cursors/releases/download/$CTP_CURSOR_VERSION/Catppuccin-Mocha-Dark-Cursors.zip -o ~/.themes/catppuccin.zip \
  && unzip ~/.themes/catppuccin.zip -d ~/.icons/ \
  && rm -rf ~/.themes/catppuccin.zip;
fi

curl \
    -L https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-nineish-dark-gray.png \
    -o ~/.config/sway/lockscreen.png

curl \
    -L https://w.wallhaven.cc/full/m9/wallhaven-m9lxe9.jpg \
    -o ~/.config/sway/background.jpg


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
    if test -s ~/.$dir;
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

##############
# tmux plugins
git clone https://github.com/tmux-plugins/tmux-sensible ~/.config/tmux/plugins/sensible
git clone https://github.com/catppuccin/tmux ~/.config/tmux/plugins/catppuccin

##############
# Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh syntax
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# syntax theme
git clone https://github.com/catppuccin/zsh-syntax-highlighting.git \
    ~/.zsh/catppuccin

##############
# UI Themes
CTP_VERSION="v0.7.3"
if [ ! -e ~/.themes/Catppuccin-Mocha-Standard-Blue-Dark ]; then \
  mkdir -p ~/.themes \
  && curl -L https://github.com/catppuccin/gtk/releases/download/$CTP_VERSION/Catppuccin-Mocha-Standard-Blue-Dark.zip -o ~/.themes/catppuccin.zip \
  && unzip ~/.themes/catppuccin.zip -d ~/.themes/ \
  && rm -rf ~/.themes/catppuccin.zip;
fi

CTP_CURSOR_VERSION="v0.2.0"
if [ ! -e ~/.icons/Catppuccin-Mocha-Dark-Cursors ]; then \
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

##############
# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -- -y
rustup target add x86_64-pc-windows-gnu
rustup component add clippy
rustup component add llvm-tools
rustup component add rust-analyzer
rustup component add rust-src
cargo install -f cargo-make
cargo install -f cargo-tree

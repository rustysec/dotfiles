#!/usr/bin/env bash

DISTRO=`lsb_release -a | grep Description | awk '{print $2}' | tr A-Z a-z`

if [ -e ./distro/$DISTRO/setup.sh ];
then
    echo "- Running $DISTRO setup"
    ./distro/$DISTRO/setup.sh
else
    echo "! Unknown setup distro $DISTRO"
fi

(mkdir -p ~/.config 2>/dev/null && echo "- Created ~/.config") || echo "- ~/.config already created..."

echo "- Linking all config folders"

for dir in config/*;
do
    echo "-- Setting up $dir"
    if test -h ~/.$dir;
    then
        rm -f ~/.$dir
    fi

    mkdir ~/.$dir 2>/dev/null

    for file in $dir/*;
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
git clone https://github.com/tmux-plugins/tmux-battery ~/.config/tmux/plugins/tmux-battery

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
    -L https://w.wallhaven.cc/full/5w/wallhaven-5wwqg3.jpg \
    -o ~/.config/sway/lockscreen.jpg

curl \
    -L https://w.wallhaven.cc/full/5w/wallhaven-5wwqg3.jpg \
    -o ~/.config/sway/background.jpg

##############
# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"
rustup target add x86_64-pc-windows-gnu
rustup component add clippy
rustup component add llvm-tools
rustup component add rust-analyzer
rustup component add rust-src
cargo install -f cargo-make
cargo install -f cargo-tree
cargo install cross --git https://github.com/cross-rs/cross

current=`pwd`
git clone https://github.com/cross-rs/cross ~/pkgs/cross
cd ~/pkgs/cross
git submodule update --init --remote
cd $current

##############
# Oh-My-Zsh
rm -rf ~/.oh-my-zsh || true
rm -f ~/.zshrc|| true
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i 's/robbyrussell/flazz/' ~/.zshrc

# zsh syntax
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# syntax theme
git clone https://github.com/catppuccin/zsh-syntax-highlighting.git \
    ~/.zsh/catppuccin

# auto suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


echo "ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'" >> ~/.zshrc

echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
echo "source ~/.zsh/catppuccin/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh" >> ~/.zshrc
echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

##############
# npm stuff
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:~/.local/bin:$PATH' >> ~/.zshrc
PATH=~/.npm-global/bin:$PATH
npm install -g typescript typescript-language-server

##############
# git
git config --global user.email  "russ@infocyte.com"
git config --global user.name   "rustysec"
mkdir -p ~/.ssh
echo 'AddKeysToAgent yes' > ~/.ssh/config

##############
# sway auto tiling
git clone https://github.com/nwg-piotr/autotiling ~/pkgs/autotiling

##############
# greetd/wlgreet
sudo curl \
    -L https://w.wallhaven.cc/full/5w/wallhaven-5wwqg3.jpg \
    -o /etc/greetd/background.jpg

echo '#!/bin/sh
eval $(ssh-agent -s) 2>/dev/null >/dev/null
dbus-run-session sway 2>/dev/null >/dev/null' | sudo tee /etc/greetd/sway.sh
sudo chmod +x /etc/greetd/sway.sh

echo "exec swaybg -m fill --image /etc/greetd/background.jpg
exec \"wlgreet --command /etc/greetd/sway.sh; swaymsg exit\"
bindsym Mod4+shift+e exec swaynag \
	-t warning \
	-m 'What do you want to do?' \
	-b 'Poweroff' 'loginctl poweroff' \
	-b 'Reboot' 'loginctl reboot'" | sudo tee /etc/greetd/sway-config

echo '[border]
red = 0.45
green = 0.78
blue = 0.925
opacity = 1.0' | sudo tee /etc/greetd/wlgreet.toml

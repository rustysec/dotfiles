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
    rm -f ~/.$dir
    ln -s `pwd`/$dir ~/.$dir
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
if [ ! -e ~/.themes/Catppuccin-Frappe-Standard-Lavender-dark ]; then \
  mkdir -p ~/.themes \
  && curl -L https://github.com/catppuccin/gtk/releases/download/$CTP_VERSION-version/Catppuccin-Mocha-Standard-Blue-dark.zip -o ~/.themes/catppuccin.zip \
  && unzip ~/.themes/catppuccin.zip -d ~/.themes/ \
  && rm -rf ~/.themes/catppuccin.zip;
fi

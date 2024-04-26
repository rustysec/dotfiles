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

# Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh syntax
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# syntax theme
git clone https://github.com/catppuccin/zsh-syntax-highlighting.git \
    ~/.zsh/catppuccin

#!/usr/bin/env bash

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

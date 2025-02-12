#!/usr/bin/env bash

##############
# npm stuff
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:~/.local/bin:$PATH' >> ~/.zshrc
PATH=~/.npm-global/bin:$PATH
npm install -g typescript typescript-language-server

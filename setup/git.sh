#!/usr/bin/env bash

##############
# git
git config --global user.email  "russ@infocyte.com"
git config --global user.name   "rustysec"
mkdir -p ~/.ssh
echo 'AddKeysToAgent yes' > ~/.ssh/config

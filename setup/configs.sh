#!/usr/bin/env bash

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

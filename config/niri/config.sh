#!/usr/bin/env bash

dir=`dirname $0`
hostname=`hostname`

cat $dir/config.kdl.base > ~/.config/niri/config.kdl
cat $dir/config.kdl.$hostname >> ~/.config/niri/config.kdl 2>/dev/null

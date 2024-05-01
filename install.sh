#!/usr/bin/env bash

DISTRO=`lsb_release -a | grep Description | awk '{print $2}' | tr A-Z a-z`

if [ -e ./distro/$DISTRO/install.sh ];
then
    echo "- Running $DISTRO automated install"
    ./distro/$DISTRO/install.sh
else
    echo "! Unknown install distro $DISTRO"
fi

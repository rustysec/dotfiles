#!/usr/bin/env bash

if [[ "$1" == "" ]];
then
    echo "Please provide a host to lookup"
    echo "Usage: $0 <host>"
    exit 1
fi

echo "* Looking up IPs for $1"
for ip in $(sudo getent hosts $1 | awk '{print $1}');
do
    echo "** Adding route for $ip"
    sudo ip route add $ip/32 dev tun0;
done

#!/bin/sh
niri msg --json event-stream | while read -r event; do
event_type=$(echo "$event" | jq -r 'keys[0]')
if [[ "$event_type" == "OverviewOpenedOrClosed" ]]; then
    is_open=$(echo "$event" | jq -r '.OverviewOpenedOrClosed.is_open')
    
    case "$is_open" in
        "true")
            pkill -SIGUSR1 waybar
            ;;
        "false")
            pkill -SIGUSR2 waybar
            ;;
    esac
fi
done

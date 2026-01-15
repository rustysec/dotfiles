#!/usr/bin/env bash

echo "Fixing wireplumber..."
mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
echo "monitor.alsa.rules = [
  {
    matches = [
      {
        device.name = \"alsa_card.pci-0000_65_00.6.*\"
      }
    ]
    actions = {
      update-props = {
        # Do not use the hardware mixer for volume control. It
        # will only use software volume. The mixer is still used
        # to mute unused paths based on the selected port.
        api.alsa.soft-mixer = true
      }
    }
  }
]" | tee ~/.config/wireplumber/wireplumber.conf.d/10-fix-audio.conf

systemctl --user restart wireplumber

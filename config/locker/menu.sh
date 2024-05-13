OPT=$(cat ~/.config/locker/options | fuzzel -d -l 5)

case $OPT in
  "⏻ Shutdown")
    systemctl poweroff || loginctl poweroff
    ;;
  " Restart")
    systemctl reboot || loginctl reboot
    ;;
  "󰩈 Logout")
    hyprctl dispatch exit 0 || swaymsg exit || niri msg action quit -s
    ;;
  " Lock")
    swaylock
    ;;
  *)
    echo "Doing Nothing!"
    ;;
esac

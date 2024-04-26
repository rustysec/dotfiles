OPT=$(cat ~/.config/locker/options | fuzzel -d -l 5)

case $OPT in
  "⏻ Shutdown")
    systemctl poweroff
    ;;
  " Restart")
    systemctl reboot
    ;;
  "󰩈 Logout")
    hyprctl dispatch exit 0 || swaymsg exit
    ;;
  " Lock")
    swaylock
    ;;
  *)
    echo "Doing Nothing!"
    ;;
esac

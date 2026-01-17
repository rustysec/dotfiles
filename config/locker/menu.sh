OPT=$(cat ~/.config/locker/options | fuzzel -d -l 5)

case $OPT in
  "⏻ Shutdown")
    systemctl poweroff || loginctl poweroff
    ;;
  " Restart")
    systemctl reboot || loginctl reboot
    ;;
  "󰩈 Logout")
    pinnacle-ctl quit || swaymsg exit || niri msg action quit -s
    ;;
  " Lock")
    gtklock || swaylock
    ;;
  *)
    echo "Doing Nothing!"
    ;;
esac

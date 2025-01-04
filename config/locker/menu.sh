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
    niri msg action do-screen-transition 2>&1 ; gtklock || swaylock
    ;;
  *)
    echo "Doing Nothing!"
    ;;
esac

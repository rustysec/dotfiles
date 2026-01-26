OPT=$(cat ~/.config/layout-switcher/options | fuzzel -d -l 8)

case $OPT in
  "Main Left")
    pinnacle-ctl set-layout 0
    ;;
  "Main Right")
    pinnacle-ctl set-layout 1
    ;;
  "Main Top")
    pinnacle-ctl set-layout 2
    ;;
  "Main Bottom")
    pinnacle-ctl set-layout 3
    ;;
  "Dwindle")
    pinnacle-ctl set-layout 4
    ;;
  "Spiral")
    pinnacle-ctl set-layout 5
    ;;
  "Fair Vertical")
    pinnacle-ctl set-layout 6
    ;;
  "Fair Horizontal")
    pinnacle-ctl set-layout 7
    ;;
  *)
    echo "Doing Nothing!"
    ;;
esac

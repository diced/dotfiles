function notif {
   brightness=`brightnessctl -m | cut -d, -f4 | tr -d %`
   echo $brightness
   if [ "$brightness" -lt "51" ]; then
      notify-call -i display-brightness-low-symbolic "Brightness: " -h int:value:"$brightness" -R 68;
   else
      if [ "$brightness" -lt "101" ]; then
         notify-call -i display-brightness-high-symbolic "Brightness: " -h int:value:"$brightness" -R 68;
      fi
   fi
}

function up {
   brightnessctl set 10+% -e
}

function down {
   brightnessctl set 10-% -e
}

case $1 in
   up)
      up
      notif
      ;;
   down)
      down
      notif
      ;;
   *)
     exit 1
     ;;
esac

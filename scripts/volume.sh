function notif {
   vol=`pamixer --get-volume`
   if [ "$vol" -lt "30" ]; then
      notify-call -i audio-volume-low "Volume: " -h int:value:"$vol" "`player`" -R 69;
   else
      if [ "$vol" -lt "50" ]; then
         notify-call -i audio-volume-medium "Volume: " -h int:value:"$vol" "`player`" -R 69;
      else
         if [ "$vol" -lt "101" ]; then
            notify-call -i audio-volume-high "Volume: " -h int:value:"$vol" "`player`" -R 69;
         fi
      fi
   fi
}

function up {
   pactl set-sink-volume @DEFAULT_SINK@ +1%
   sleep 0.01
   pactl set-sink-volume @DEFAULT_SINK@ +1%
}

function down {
   pactl set-sink-volume @DEFAULT_SINK@ -1%
   sleep 0.01
   pactl set-sink-volume @DEFAULT_SINK@ -1%
}

case $1 in
   mute)
      pactl set-sink-mute   @DEFAULT_SINK@ toggle
      if `pamixer --get-mute` ; then
         notify-call -i audio-volume-muted "Volume: " -h int:value:"0" -R 69;
      else
         notif
      fi
      ;;
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

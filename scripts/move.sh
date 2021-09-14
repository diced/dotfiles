if [ -L $1 ]; then
  echo "Moving data back from /media";
  rm -f $1
  mv "/media/$(basename "$1")" "$1";
else
  echo "Moving data to /media"
  mv "$1" "/media";
  ln -sf "/media/$(basename "$1")" "$1"
fi

echo "Done."

URL="";
FILE=$2;

request() {
  curl -H "Content-Type: multipart/form-data" -H "authorization: $2" -F file=@"$FILE" $1;
}

if [ $1 == "zipline" ]
then
  # zipline
  URL=$(request "https://diced.wtf/api/upload" $ZIP_AUTH);
  echo -n $URL | xsel -ib
elif [ $1 == "rimg" ]
then
  # rimg testing
  URL=$(request "https://pog.diced.wtf/upload" $RIMG_AUTH)
  echo -n "https://pog.diced.wtf/$URL" | xsel -ib
elif [ $1 == "vch" ]
then
  # vch
  URL=$(request  "https://cdn.voidchan.gg/api/providers/sharex" $VCH_AUTH);
  echo -n $URL | jq -r '.files[].url' | xsel -ib
else
  dunstify -i flameshot  "No provider!"
fi
# send notif
dunstify -i flameshot  "Uploaded Image" "$URL"

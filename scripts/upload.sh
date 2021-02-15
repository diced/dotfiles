URL=$(curl -H "Content-Type: multipart/form-data" -H "authorization: $ZIP_AUTH" -F file=@"$1" "https://diced.wtf/api/upload"); echo -n $URL | xsel -ib
# curl -H "Content-Type: multipart/form-data" -H "Authorization: $VCH_AUTH" -F file=@$1 https://cdn.voidchan.gg/api/providers/sharex | jq -r '.files[].url' | xsel -ib

ACTION=$(dunstify -i flameshot -a "close,open" "Uploaded Image" "$URL")

case "$ACTION" in
"default")
    exit 0;
"2")
    xdg-open $URL
    ;;
esac

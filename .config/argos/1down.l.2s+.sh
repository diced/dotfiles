#!/usr/bin/env sh
# heavily modified https://gist.github.com/dagelf/ab2bad26ce96fa8d79b0834cd8cab549

function readable {
  let kb=$1/1000
  let mb=$1/1000000
  let gb=$1/1000000000

  if [ $gb -gt 0 ]; then
    echo "$gb GB/s"
  elif [ $mb -gt 0 ]; then
    echo "$mb MB/s"
  else
    echo "$kb KB/s"
  fi
}

stat=`grep eno1 /proc/net/dev | sed s/.*://`;
rx=`echo $stat | awk '{print $1}'`
sleep 1

stat=`grep eno1 /proc/net/dev | sed s/.*://`;
newrx=`echo $stat | awk '{print $1}'`
download=$((($newrx-$rx)/1))

echo "$(readable $download) | iconName=go-down-symbolic"
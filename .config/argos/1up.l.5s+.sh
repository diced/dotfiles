#!/usr/bin/env sh

function readable {
  let velKB=$1/1000
  let velMB=$1/1000000
  let velGB=$1/1000000000

  if [ $velGB -gt 0 ]; then
    echo "$velGB GB/s"
  elif [ $velMB -gt 0 ]; then
    echo "$velMB MB/s"
  else
    echo "$velKB KB/s"
  fi
}

stat=`grep eno1 /proc/net/dev | sed s/.*://`;
tx=`echo $stat | awk '{print $9}'`
sleep 1

stat=`grep eno1 /proc/net/dev | sed s/.*://`;
newtx=`echo $stat | awk '{print $9}'`
upload=$((($newtx-$tx)/1))

echo "$(readable $upload) | iconName=go-up-symbolic"
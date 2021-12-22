#!/usr/bin/env sh

m=`free -b | awk 'FNR == 2 {print $3}'`
mb=`echo $m/1024/1024 | bc`
percent=`free -t | awk 'FNR == 2 {printf("%.0f%"), $3/$2*100}'`

echo "$mb MiB ($percent) | iconName=memory-free-symbolic"

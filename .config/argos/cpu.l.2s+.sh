#!/usr/bin/env sh

usage=`top -b -n 1| fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.0f%%\n", prefix, 100 - v }'`;

echo "$usage | iconName=cpu-symbolic"

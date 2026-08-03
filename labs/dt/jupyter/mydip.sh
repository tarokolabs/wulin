#!/usr/bin/env bash

[ ! -d ./opendata/dip ] && mkdir -p ./opendata/dip/

while read line
do
   [ "$line" == "" ] && break
   u=${line%% *}; f=${line##* }
   # echo $u,$f
   wget "$u" -O opendata/dip/$f &>/dev/null
   [ "$?" == "0" ] && echo "$f ok"

   sleep 2
done < mydip.url

[ -f /tmp/diphead.txt ] && rm /tmp/diphead.txt
n=$(ls opendata/dip/*.csv)
for x in $n
do
  [ ! -f /tmp/diphead.txt ] && head -n 1 $x > /tmp/diphead.txt
  cat $x | tail -n +2 >> /tmp/dip.tmp
  mv /tmp/dip.tmp $x
done 

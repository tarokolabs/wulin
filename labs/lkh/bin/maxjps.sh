#!/usr/bin/env bash

[ -f /tmp/maxjlog.stop ] && rm /tmp/maxjlog.stop
echo "[`hostname`]" > /tmp/jps-`hostname`.log

jcb="0"
while true; do

  [ -f /tmp/maxjlog.stop ] && break

  jps -v | grep -v Jps > /tmp/jps.txt
  jyc=$(cat /tmp/jps.txt | grep "YarnChild" | wc -l)
  jmc=$(cat /tmp/jps.txt | grep "MRAppMaster" | wc -l)
  jc=$(( $jyc+$jmc ))
  [ "$jc" != "$jcb" ] && jcb=$jc && [ "$jc" != "0" ] && echo "`date +%H:%M:%S` -> Y:$jyc M:$jmc" >> /tmp/jps-`hostname`.log

done


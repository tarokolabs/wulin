#!/bin/bash

trap 'kill $(jobs -p)' EXIT

while true; do
  curl 120.96.143.243:8080/info > /dev/null 2>&1
done &

while true; do
  curl 120.96.143.243:8080/info > /dev/null 2>&1
done &

while true; do
  sleep 2
  clear
  kubectl get hpa hpa-sp
  echo "關閉請按 ctrl-c"
done


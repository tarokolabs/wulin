#!/usr/bin/env bash
imgname="quay.io/cloudwalker/mysql:8.0.41"

if (podman rmi $imgname &>/dev/null); then
   echo "$imgname remove ok"
fi

if (podman build --format=docker --no-cache --force-rm  --squash -t $imgname . &>/dev/null); then
   echo "$imgname build ok"
fi

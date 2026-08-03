#!/bin/bash
# 建置並推送 wulin 教材 image 至 GHCR（ghcr.io/tarokolabs/wulin/*）
#
# 用法：
#   build-images.sh tools [CalVer]        # toolbox、admin、sshd、podman、bind（預設 v2026.8.0）
#
# 推送前需先登入：podman login ghcr.io
# 命名規則見 https://github.com/tarokolabs/tk8s/issues/20

REG="ghcr.io/tarokolabs/wulin"
LABELS="--label=org.opencontainers.image.source=https://github.com/tarokolabs/wulin \
        --label=org.opencontainers.image.licenses=GPL-2.0"
WULIN=~/wulin
ALPINE_VER="3.22.1"

build_push() {  # <name:tag> <context 目錄> [額外 build 參數...]
   local ref="${REG}/${1}" dir="${WULIN}/${2}" log="/tmp/build-$(echo ${1} | tr '/:' '--').out"
   shift 2
   echo "building ${ref}"
   sudo podman build --format=docker --no-cache --force-rm ${LABELS} "$@" \
        -t "${ref}" "${dir}" &>"${log}"
   [ "$?" != "0" ] && echo "  build failed（見 ${log}）" && exit 1
   sudo podman push --digestfile "${log}.digest" "${ref}" &>/dev/null
   [ "$?" != "0" ] && echo "  push failed（先 podman login ghcr.io）" && exit 1
   echo "  pushed ${ref}  $(cat ${log}.digest)"
}

case "$1" in
tools)
   CALVER="${2:-v2026.8.0}"
   build_push "toolbox:${CALVER}" images/toolbox --build-arg=VER=${ALPINE_VER}
   build_push "admin:${CALVER}"   images/admin   --build-arg=BASE_TAG=${CALVER}
   build_push "sshd:${CALVER}"    images/sshd   --build-arg=BASE_TAG=${CALVER}
   build_push "podman:${CALVER}"  images/podman --build-arg=BASE_TAG=${CALVER}
   build_push "bind:${CALVER}"    images/bind   --build-arg=BASE_TAG=${CALVER}
   ;;
*)
   echo "build-images.sh tools [CalVer]"
   exit 1
   ;;
esac

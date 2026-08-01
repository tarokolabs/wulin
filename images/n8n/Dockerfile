ARG VER=00.00
FROM docker.io/n8nio/n8n
USER root
RUN apk update && apk upgrade && apk add --no-cache nano sudo wget curl python3 py3-pip mysql-client git \ 
    openssh-client-default nfs-utils go sshpass tree bash shadow procps bind-tools util-linux coreutils \
    binutils findutils grep tzdata libcap jq yq zip unzip fuse iptables iperf3 stress-ng && \

    # 設定時區
    cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    rm /sbin/reboot && rm /usr/bin/killall

USER node

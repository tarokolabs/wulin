ARG VER=00.00
FROM alpine:${VER}

COPY mc rclone kube-linter /usr/bin/
COPY "containers.conf" "/etc/containers/"

RUN apk update && apk upgrade && apk add --no-cache nano sudo wget curl \
    openssh-client-default tree bash util-linux coreutils grep jq zip unzip git \
    tzdata openssl fuse fuse-overlayfs go podman shellcheck

RUN apk add kubectl --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ \
    --allow-untrusted

RUN wget https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 -O /usr/bin/hadolint && \
    chmod +x /usr/bin/hadolint

    # 安裝 task 命令
RUN sh -c "$(curl -s --location https://taskfile.dev/install.sh)" -- -d -b /tmp &>/dev/null && \
    install -m 555 "/tmp/task" "/usr/local/bin/task" && rm /tmp/task && \
    # 設定時區
    cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime

CMD ["/bin/sleep","infinity"]

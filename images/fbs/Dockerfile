ARG VER=0.0
FROM quay.io/cloudwalker/alp.base
RUN apk update && apk upgrade && \
    curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash && \
    # 設定 filebrowser
    filebrowser config init --port 8080 --address "" --log "/tmp/fbs" --root="/srv" && \
    # 建立管理者帳號
    filebrowser users add admin "admin1234567" --perm.admin=true

CMD ["filebrowser"]

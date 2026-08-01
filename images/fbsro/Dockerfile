ARG VER=0.0
FROM 172.22.1.11:5000/alp.base:${VER}

RUN apk update && apk upgrade \
    && adduser -h /opt/app -D app \
    && curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

COPY entrypoint /opt/app/entrypoint
RUN chmod a+x /opt/app/entrypoint && mkdir -p /srv

EXPOSE 4000
USER app
WORKDIR /opt/app

ENTRYPOINT [ "/opt/app/entrypoint" ]


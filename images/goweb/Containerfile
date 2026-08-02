ARG VER=0.0
FROM quay.io/cloudwalker/alp.base
RUN apk update && apk upgrade && mkdir -p /opt/www && mkdir /opt/web
COPY goweb web /opt/web
CMD ["/opt/web/goweb"] 

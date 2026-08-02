FROM quay.io/cloudwalker/alp.base
RUN apk update && apk upgrade && mkdir -p /opt/www
COPY main /bin/main
CMD ["/bin/main"] 

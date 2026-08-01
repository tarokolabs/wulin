ARG VER=0.0
FROM wordpress:php8.3-apache

RUN apt-get update && apt-get upgrade && apt-get install -y iputils-ping nano sudo wget curl default-mysql-client git \ 
    sshpass tree bash procps util-linux coreutils binutils findutils jq zip unzip s3fs fuse && \
    echo 'user_allow_other' >> /etc/fuse.conf

CMD ["/bin/sleep","infinity"]

ARG VER=0.0
FROM docker.io/library/mysql:${VER}
ENV MYSQL_ROOT_PASSWORD bigred
RUN microdnf update && microdnf upgrade && \
    microdnf -y install --nodocs sudo curl wget zip tree iputils findutils procps nano bash net-tools && \
    microdnf clean all

ADD my.sql /docker-entrypoint-initdb.d

EXPOSE 3306

FROM docker.io/library/mysql:8.0.41
ENV MYSQL_ROOT_PASSWORD bigred
RUN microdnf update && microdnf upgrade && \
    microdnf -y install --nodocs sudo curl wget zip tree iputils findutils procps nano bash net-tools && \
    microdnf clean all

COPY my.sql /docker-entrypoint-initdb.d

EXPOSE 3306

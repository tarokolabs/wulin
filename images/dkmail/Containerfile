FROM docker.io/mailserver/docker-mailserver
ARG DN=""
ENV OVERRIDE_HOSTNAME="mx1.${DN}" \
    DMS_DEBUG="1" \
    POSTMASTER_ADDRESS="bigred@${DN}" \
    ENABLE_AMAVIS="0" \
    ENABLE_OPENDKIM="0" \
    ENABLE_OPENDMARC="0" \
    ENABLE_IMAP="0" \
    ENABLE_POP3="1"

RUN apt-get update && apt-get install -y net-tools curl wget nano && \
    setup email add bigred@${DN} bigred && \
    setup email add rbean@${DN} rbean && \
    setup email add gbean@${DN} gbean && \
    touch /tmp/docker-mailserver/postfix-main.cf
#    echo "mydomain = ${DN}" >> /tmp/docker-mailserver/postfix-main.cf  && \
#    echo "myhostname = mx1.${DN}" >> /tmp/docker-mailserver/postfix-main.cf  && \
#    echo "mynetworks = 127.0.0.0/8 192.168.188.0/24 172.22.0.0/16" >> /tmp/docker-mailserver/postfix-main.cf

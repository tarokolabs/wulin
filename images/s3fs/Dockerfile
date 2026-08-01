ARG VER
FROM quay.io/cloudwalker/alp.base

USER root

CMD [ \
    "/bin/bash", \
    "-c", \
    " \
    echo ${USER}:${PASSWORD} > /tmp/.passwd-s3fs ;\
    chmod 600 /tmp/.passwd-s3fs ;\
    s3fs ${BUCKET} /s3 \
    -o passwd_file=/tmp/.passwd-s3fs \
    -o url=${URL} \
    -o allow_other \
    -o use_path_request_style \
    ${EXTARG} ${DEBUG} \
    "]

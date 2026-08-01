FROM ubuntu:22.04

COPY bash.append mariadb-java-client-2.7.12.jar /tmp/
COPY libssl-dev_1.1.1f-1ubuntu2_amd64.deb libssl1.1_1.1.1f-1ubuntu2_amd64.deb openssl_1.1.1f-1ubuntu2_amd64.deb /tmp
RUN  mkdir -p /etc/skel/.ssh /opt/zfs/www /opt/zfs/dataset /opt/zfs/sys
COPY ssh/* /etc/skel/.ssh/
COPY environment /etc/

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y nano locales apt-utils tree unzip curl wget jq libsnappy-dev \
    netcat net-tools ssh zip sudo iputils-ping dnsutils openjdk-17-jdk libisal-dev gettext-base \
    python3-pip bzip2 psmisc iproute2 mysql-client-core-8.0 bsdmainutils nfs-kernel-server nfs-common podman \
    s3fs openjdk-11-jdk elinks vim && \
    update-java-alternatives --set /usr/lib/jvm/java-1.11.0-openjdk-amd64 && \
    apt-get -y upgrade && apt-get autoremove -y && apt-get clean && rm -rf /var/cache/apt/archives && \

    locale-gen en_US && locale-gen zh_TW.UTF-8 && locale-gen en_US.UTF-8 && passwd -dl root && \
    ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \

    pip install numpy pandas pyarrow fastparquet mysql-connector-python && \

    # install openssl 1.1.1
    # http://security.ubuntu.com/ubuntu/pool/main/o/openssl
    dpkg -i /tmp/libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    dpkg -i /tmp/libssl-dev_1.1.1f-1ubuntu2_amd64.deb && \
    dpkg -i /tmp/openssl_1.1.1f-1ubuntu2_amd64.deb && \
    rm /tmp/*.deb && \

    # install kubectl
    curl -LO https://dl.k8s.io/release/v1.34.3/bin/linux/amd64/kubectl && \
    chmod +x kubectl && mv kubectl /usr/local/bin && \

    # install minio client
    # curl -s https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/bin/mc && \
    # chmod +x /usr/bin/mc && \

    # 建立管理者帳號 bigred
    groupadd bigboss && echo '%bigboss ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    cat /tmp/bash.append >> /etc/bash.bashrc && rm /tmp/bash.append && chmod 755 /etc/bash.bashrc && \
    useradd -m -s /bin/bash bigred && echo 'bigred:bigred' | chpasswd && \
    usermod -a -G bigboss bigred && chmod -R 700 /home/bigred/.ssh && \

    echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'PermitUserEnvironment yes' >> /etc/ssh/sshd_config && \
    echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config && \ 

    echo 'DefaultTasksMax=1024' >> /etc/systemd/system.conf && \
    rm /etc/update-motd.d/* && echo "Data Intelligence Platform (Ubuntu 22.04 LTS)" >/etc/update-motd.d/00 && \
    chmod +x /etc/update-motd.d/00 && cat /etc/update-motd.d/00 > /etc/motd 

CMD ["/bin/bash"]

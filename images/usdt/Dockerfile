FROM ubuntu:22.04

COPY bash.append /tmp/
RUN  mkdir -p /etc/skel/.ssh
COPY ssh/* /etc/skel/.ssh/
COPY environment /etc/

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y nano locales apt-utils tree unzip curl wget jq nfs-common libsnappy-dev \
    python3-pip openssl netcat net-tools ssh zip sudo iputils-ping dnsutils openjdk-8-jdk libisal-dev gettext-base \
    bzip2 psmisc python3-numpy mysql-client-core-8.0 && \
    pip install pandas pyarrow fastparquet && \
    mkdir /opt/dtp /opt/www /opt/dataset /mnt/sysbak && \
    locale-gen en_US && locale-gen zh_TW.UTF-8 && locale-gen en_US.UTF-8 && passwd -dl root && \
    sudo ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    apt-get -y upgrade && apt-get autoremove -y && apt-get clean && rm -rf /var/cache/apt/archives && \

    # install kubetl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && sudo mv kubectl /usr/local/bin && \

    # 建立管理者帳號 bigred
    groupadd bigboss && echo '%bigboss ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    cat /tmp/bash.append >> /etc/bash.bashrc && rm /tmp/bash.append && chmod 755 /etc/bash.bashrc && \
    useradd -m -s /bin/bash bigred && echo 'bigred:bigred' | chpasswd && \
    usermod -a -G bigboss bigred && chmod -R 700 /home/bigred/.ssh && \

    echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'PermitUserEnvironment yes' >> /etc/ssh/sshd_config && \
    echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config && \

    echo '[ -f /home/bigred/wulin/wk/dt/bin/system.sh ] && source /home/bigred/wulin/wk/dt/bin/system.sh' >> /etc/profile && \
    rm /etc/update-motd.d/* && echo "Ubuntu 22.04 LTS : IP `hostname -I`" >/etc/update-motd.d/00 && \
    sudo chmod +x /etc/update-motd.d/00 && cat /etc/update-motd.d/00 > /etc/motd

CMD ["/bin/bash"]

FROM centos:latest
MAINTAINER Marios Andreopoulos opensource@andmarios.com

RUN yum install -y epel-release && \
    yum -y update && \
    yum install -y git golang java-1.7.0-openjdk-headless \
        java-1.7.0-openjdk-devel nano emacs-nox wget net-tools gcc jq ncftp \
        tar moreutils docker bash-completion ansible sudo bind-utils mlocate \
        python-libcloud pyOpenSSL && \
    /etc/cron.daily/mlocate && \
    echo "progress = dot:mega" | tee /etc/wgetrc


# Interestingly on CentOS 7 you can't bind mount a socket inside /run
RUN ln -s /docker.sock /run/docker.sock

RUN useradd dev -u 1000 -m && \
    echo "dev ALL=NOPASSWD: ALL" >> /etc/sudoers && \
    usermod -a -G root dev && \
    mkdir /home/dev/ansible

ADD home/ /home/dev
ADD https://raw.githubusercontent.com/ansible/ansible/stable-1.9/plugins/inventory/gce.py \
    /home/dev/ansible/

RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz && \
    tar xf google-cloud-sdk.tar.gz -C /usr/local/share/ && rm google-cloud-sdk.tar.gz && \
    /usr/local/share/google-cloud-sdk/install.sh --disable-installation-options \
        --usage-reporting false --bash-completion true --rc-path /home/dev/.bashrc \
        --path-update true && \
    chown -R dev:dev /home/dev && rm /home/dev/.emacs

USER dev
WORKDIR /home/dev

ENV HOME="/home/dev" GOPATH="/home/dev/go"
RUN mkdir /home/dev/go && go get -u -v github.com/nsf/gocode

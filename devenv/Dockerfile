FROM centos:latest
MAINTAINER Marios Andreopoulos <opensource@andmarios.com>

RUN sed '/tsflags=nodocs/d' -i /etc/yum.conf && \
    rm /etc/rpm/macros.imgcreate && \
    yum install -y epel-release deltarpm && \
    yum -y update && \
    yum -y group install "Development Tools" && \
    curl https://bintray.com/sbt/rpm/rpm | \
        tee /etc/yum.repos.d/bintray-sbt-rpm.repo && \
    curl https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo | \
        tee /etc/yum.repos.d/epel-apache-maven.repo && \
    yum install -y git golang java-1.7.0-openjdk-headless openssl tmux nmap \
        java-1.7.0-openjdk-devel nano emacs-nox wget net-tools gcc jq ncftp \
        tar moreutils docker bash-completion ansible sudo bind-utils mlocate \
        python-libcloud pyOpenSSL htop nload iftop vim-enhanced ruby rubygems \
        ruby-devel python-devel sbt apache-maven nodejs nodejs-devel npm \
        sloccount man man-pages && \
    gem install jekyll && \
    echo "progress = dot:mega" | tee /etc/wgetrc


# Interestingly on CentOS 7 you can't bind mount a socket inside /run
RUN ln -s /docker.sock /run/docker.sock

RUN useradd dev -u 1000 -m && \
    echo "dev ALL=NOPASSWD: ALL" >> /etc/sudoers && \
    usermod -a -G root dev && \
    mkdir /home/dev/{sources,.gcecreds,.go,.setup,.setup-ssh,.ssh}

ADD home/ /home/dev

RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz && \
    tar xf google-cloud-sdk.tar.gz -C /usr/local/share/ && \
    rm google-cloud-sdk.tar.gz && \
    /usr/local/share/google-cloud-sdk/install.sh \
        --disable-installation-options \
        --usage-reporting false \
        --bash-completion true \
        --rc-path /home/dev/.bashrc \
        --path-update true && \
    chown -R dev:dev /home/dev && \
    rm /home/dev/.emacs && \
    chmod 700 /home/dev/{.gcecreds,.setup,.setup-ssh,.ssh}

USER dev
WORKDIR /home/dev

ENV HOME="/home/dev" GOPATH="/home/dev/.go"
# This is too slow to have to rebuild.
RUN sbt exit
# Emacs will probably exit with an error code ≠ 0 but we do not care.
RUN go get -u -v github.com/nsf/gocode && \
    emacs --kill --daemon || echo "Unimportant Error" && \
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
    git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go && \
    ~/.go/src/github.com/nsf/gocode/vim/pathogen_update.sh && \
    git clone https://github.com/derekwyatt/vim-scala.git \
        ~/.vim/bundle/vim-scala && \
    mkdir -p ~/.sbt/0.13/plugins/ && \
    echo 'addSbtPlugin("org.ensime" % "ensime-sbt" % "0.1.6")' >> \
        ~/.sbt/0.13/plugins/plugins.sbt && \
    sbt exit

USER root
RUN /etc/cron.daily/mlocate

USER dev
CMD ["bash"]

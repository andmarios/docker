FROM centos:latest
MAINTAINER Marios Andreopoulos <opensource@andmarios.com>

RUN yum install -y epel-release
RUN yum groupinstall -y 'Development Tools' && \
    yum install -y \
        git \
        java-1.7.0-openjdk-headless \
        java-1.7.0-openjdk-devel \
        nano \
        wget \
        net-tools \
        jq \
        ncftp \
        tar \
        bzip2 \
        sudo \
        python-sphinx \
        python-sphinx_rtd_theme

RUN echo "progress = dot:mega" | tee /etc/wgetrc

RUN curl -sL https://rpm.nodesource.com/setup | bash - && \
    yum install -y nodejs

RUN curl http://pkg.jenkins-ci.org/redhat/jenkins.repo | tee /etc/yum.repos.d/jenkins.repo && \
    rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key && \
    yum install -y jenkins

# Prepare for Jenkins. Jenkins user is already set by `yum install jenkins`
VOLUME ["/mnt/jenkins"]
ENV JENKINS_HOME /mnt/jenkins
ENV HOME /mnt/jenkins
RUN chown -R jenkins:jenkins /mnt/jenkins
RUN usermod -a -G root jenkins

# Since we use shared volumes and bind mounts, we want a standardized UID/GID. We use a number above `login.defs` max
# Jenkins UID/GID: 61001
RUN find / -path /proc -prune -o -user  jenkins -exec chown -h 61001 {} \; && \
    find / -path /proc -prune -o -group jenkins -exec chgrp -h 61001 {} \; && \
    usermod  --uid 61001 jenkins && \
    groupmod --gid 61001 jenkins && \
    usermod  --gid 61001 jenkins

# Interestingly on CentOS 7 you can't bind mount a socket inside /run, this way it will be mounted a /
RUN ln -s /docker.sock /run/docker.sock

USER jenkins
WORKDIR /mnt/jenkins

EXPOSE 8080
CMD ["java", "-jar", "/usr/lib/jenkins/jenkins.war", "-Dhudson.diyChunking=true"]

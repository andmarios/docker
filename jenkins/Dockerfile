FROM centos:latest
MAINTAINER Marios Andreopoulos opensource@andmarios.com

RUN yum install -y epel-release
RUN yum install -y git java-1.7.0-openjdk-devel golang nano emacs emacs-golang wget net-tools gcc jq ncftp
RUN echo "progress = dot:mega" | tee /etc/wgetrc

RUN curl http://pkg.jenkins-ci.org/redhat/jenkins.repo | tee /etc/yum.repos.d/jenkins.repo && \
    rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
RUN yum install -y jenkins

RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
RUN yum install -y sbt

# Prepare for Jenkins
VOLUME ["/mnt/jenkins"]
ENV JENKINS_HOME /mnt/jenkins
ENV HOME /mnt/jenkins
RUN chown -R jenkins:jenkins /mnt/jenkins

ADD jenkins_start /usr/bin/
RUN chmod +x /usr/bin/jenkins_start

USER jenkins
WORKDIR /mnt/jenkins

EXPOSE 8080

CMD /usr/bin/jenkins_start

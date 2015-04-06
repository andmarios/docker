FROM centos:latest
MAINTAINER Marios Andreopoulos opensource@andmarios.com

RUN yum install -y epel-release
RUN yum install -y git java-1.7.0-openjdk-devel golang nano emacs wget net-tools gcc jq ncftp tar
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

USER jenkins
WORKDIR /mnt/jenkins
EXPOSE 8080
CMD ["java", "-jar", "/usr/lib/jenkins/jenkins.war", "-Dhudson.diyChunking=true"]
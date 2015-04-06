FROM centos:latest
MAINTAINER Marios Andreopoulos opensource@andmarios.com

RUN yum install -y epel-release
RUN yum install -y git java-1.7.0-openjdk-headless nano emacs-nox wget net-tools tar
RUN echo "progress = dot:mega" | tee /etc/wgetrc

# Configure Nexus
RUN mkdir -p /opt/sonatype-nexus
RUN wget -O /tmp/nexus-bundle.tar.gz http://www.sonatype.org/downloads/nexus-latest-bundle.tar.gz
RUN tar xzvf /tmp/nexus-bundle.tar.gz -C /opt/sonatype-nexus --strip-components=1 && rm /tmp/nexus-bundle.tar.gz

# Add nexus user and work directory
VOLUME ["/mnt/nexus"]
RUN useradd --user-group --system --home-dir /mnt/nexus nexus
RUN chown -R nexus:nexus /mnt/nexus /opt/sonatype-nexus

# Set paths
RUN sed -e 's|nexus-work=.*|nexus-work=/mnt/nexus|' \
        -e 's|nexus-webapp-context-path=.*|nexus-webapp-context-path=/|' \
        -i /opt/sonatype-nexus/conf/nexus.properties

EXPOSE 8081
USER nexus
CMD ["/opt/sonatype-nexus/bin/nexus", "console"]

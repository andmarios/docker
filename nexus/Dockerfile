FROM centos:latest
MAINTAINER Marios Andreopoulos <opensource@andmarios.com>

RUN yum install -y epel-release
RUN yum install -y git java-1.8.0-openjdk-headless nano emacs-nox wget net-tools tar
RUN echo "progress = dot:mega" | tee /etc/wgetrc

# Configure Nexus
RUN mkdir -p /opt/sonatype-nexus
RUN wget -O /tmp/nexus-bundle.tar.gz http://www.sonatype.org/downloads/nexus-latest-bundle.tar.gz
RUN tar xzvf /tmp/nexus-bundle.tar.gz -C /opt/sonatype-nexus --strip-components=1 && rm /tmp/nexus-bundle.tar.gz

# Add nexus user and work directory
# Since we use shared volumes and bind mounts, we want a standardized UID/GID. We use a number above `login.defs` max
# Nexus UID/GID: 61002
RUN useradd --user-group --uid 61002 --home-dir /mnt/nexus nexus && \
    groupmod --gid 61002 nexus && \
    usermod  --gid 61002 nexus
RUN chown -R nexus:nexus /mnt/nexus /opt/sonatype-nexus

# Set paths
RUN sed -e 's|nexus-work=.*|nexus-work=/mnt/nexus|' \
        -e 's|nexus-webapp-context-path=.*|nexus-webapp-context-path=/|' \
        -i /opt/sonatype-nexus/conf/nexus.properties

VOLUME ["/mnt/nexus"]
EXPOSE 8081
USER nexus
CMD ["/opt/sonatype-nexus/bin/nexus", "console"]

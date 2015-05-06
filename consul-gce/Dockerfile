FROM golang
MAINTAINER Marios Andreopoulos opensource@andmarios.com

RUN apt-get update && \
    apt-get install -y unzip

RUN go get github.com/hashicorp/consul

ADD config /config

VOLUME ["/data"]

ADD https://dl.bintray.com/mitchellh/consul/0.5.0_web_ui.zip /webui.zip
RUN unzip /webui.zip -d /ui && \
    rm /webui.zip

ENTRYPOINT ["/go/bin/consul", "agent", "-config-dir=/config"]


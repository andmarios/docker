# A consul container to act as a DNS Server inside GCE

**Work in progress for both Dockerfile and README**

This is a minimal consul container that can be used as a nameserver inside GCE without breaking things.

It exposes the DNS port to all interfaces (thus accessible by docker), but keeps the RPC and HTTP interfaces on the localhost.

It is meant to run for the main server as:

    $ docker run --net=host andmarios/consul-gce -server -bootstrap 1

Obviously you need to know some things about consul if you want to run more than one instances.
I will update the readme at a later point with more info.

**NOTE:** Please don't leave your DNS (53) port exposed to the internet.

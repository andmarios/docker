### Nexus image with some extra sauce.

You should use a custom folder for nexus workdir.

Usually it is enough to:

    $ mkdir /path/to/nexus/home
    $ chown -R 998:997 /path/to/nexus/home

If the numeric uid/gid seems to have change, you may find it by running (build image fist):

    $ docker run --rm andmarios/nexus grep nexus /etc/passwd


To build the image:

    $ docker build -t andmarios/nexus containers/nexus

To run:

    $ docker run --name nexus -p 8081:8081 -v /path/to/nexus/home:/mnt/nexus andmarios/nexus

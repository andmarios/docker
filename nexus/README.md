## Nexus image with some extra sauce.

You should use a custom folder for nexus workdir.

Usually it is enough to:

    $ mkdir /path/to/nexus/home
    $ chown -R 61002:61002 /path/to/nexus/home

To run:

    $ docker run --name nexus -p 8081:8081 -v /path/to/nexus/home:/mnt/nexus andmarios/nexus

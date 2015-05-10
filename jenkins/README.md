# Jenkins image with some extra sauce.

You should use a custom folder for jenkins home.

Usually* it is enough to:

    $ mkdir /path/to/jenkins/home
    $ chown -R 61001:61001 /path/to/jenkins-home

To run:

    $ docker run --name jenkins -p 8080:8080 -v /path/to/jenkins-home:/mnt/jenkins andmarios/jenkins

*If you are on a SELinux enabled host, you also need:

    # chcon -Rt svirt_sandbox_file_t /path/to/jenkins-home

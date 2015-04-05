### Jenkins image with some extra sauce.

You should use a custom folder for jenkins home.

Usually it is enough to:

    $ mkdir /path/to/jenkins/home
    $ chown -R 998:997 /path/to/jenkins/home

If the numeric uid/gid seems to have change, you may find it by running (build image fist):

    $ docker run --rm andmarios/jenkins grep jenkins /etc/passwd


To build the image:

    $ docker build -t andmarios/jenkins containers/jenkins

To run:

    $ docker run --name jenkins -p 8080:8080 -v /path/to/jenkins/home:/mnt/jenkins andmarios/jenkins

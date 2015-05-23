# Dev Environment with some extra sauce

This is a basic devops environment. It includes in random order:

- gcc, golang, openjdk
- emacs pre-configured with syntax highlighting and some sugar
- vim pre-configured with syntax highlighting
- golang autocomplete support for both emacs and vim
- git with bash completion enabled
- docker support with bash completion enabled
- tmux pre-configured
- ssh-agent
- ansible
- various tools (bind-utils, mlocate, jq, htop, etc)
- various custom bash commands, try `dockip` or `gl` (inside a git repo)

Optional:

- GCE project auto-activation support (through service account)
- ability to use provided ssh keys and settings (i.e use your `~/.ssh`)
- automatic clone new / pull existing git repositories

Some future plans:

- autoconfigure ansible with GCE project
- scala autocomplete for emacs and vim
- better ansible configuration

Inside the container you start as a normal user (`dev`, uid 1000). This is only for your safety and to help with setup-use cases separation.
You have `sudo` access if you need to run commands as the superuser (e.g `yum install`).

## GCE project auto-activation

Create a file named `gce.account` that contains your GCE service account.
Create a file named `gce.key` that contains your unencrypted PEM key (from your p12 file).

If your files are inside `/path/to/dsetup`, then:

    $ docker run -it -v /path/to/dsetup:/home/dev/.setup andmarios/devenv

## Provide SSH keys and settings

You may provide your `$HOME/.ssh` directory so that you will have your ssh keys and settings inside the container.
The ssh-agent will ask you to activate your `id_rsa` key and any other key mentioned inside `$HOME/.ssh/config`.

    $ docker run -it -v /home/USER/.ssh:/home/dev/.setup-ssh andmarios/devenv

## Auto clone/pull repositories

Create a file name `repos` and your git repositories inside, one per line.
Then if your file is inside `/path/to/dsetup`:

    $ docker run -it -v /path/to/dsetup:/home/dev/.setup andmarios/devenv

_Obviously if your repositories need SSH keys for access, you have to provide them as mentioned above._

## Docker support

The container can use an external docker daemon through bind mounting its socket:

    $ docker run -it -v /run/docker.sock:/run/docker.sock andmarios/devenv

If your docker socket is owned by root you can use it directly. If it is owned by someone else, you need to use sudo for the docker commands.

---

__work in progress__

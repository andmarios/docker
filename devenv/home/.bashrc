source /etc/bashrc

export PS1="\[\033[1;31m\]\u\[\033[1;33m\]@\[\033[1;34m\]\h \[\033[1;36m\]\W\[\033[1;0m\] $ "

# commands starting with space should be recorded to history! Nice for passwords.
# Also ignore duplicate entries
export HISTCONTROL=ignorespace:ignoredups
export HISTSIZE=10000
export HISTTIMEFORMAT="%FT%T%z "

# Go path
export PATH="${PATH}:${HOME}/.go/bin"
export GOPATH=${HOME}/.go

export USER="$(whoami)"

# Useful and nice git logs
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glnc="git log --pretty=format:'%h -%d %s (%cr) <%an>' --abbrev-commit"

# Python http server working with both 2.7 and 3.x
pythonserver()
{
    python -m SimpleHTTPServer $1 || python -m http.server $1
}

# Set git variables if not setup. Later we override this with supplied gitconfig
if [ ! -f ~/.gitconfig ]; then
    git config --global user.name "Marios Andreopoulos"
    git config --global user.email opensource@andmarios.com
    git config --global core.editor nano
    git config --global push.default simple
fi

# Replace container IDs with container IPs for docker ps.
dockip()
{
    docker ps | while read DLINE
                do
                    CONTAINER="$(echo $DLINE | grep -Eo "^[a-f0-9]{12,12}")"
                    [[ ! -z "$CONTAINER" ]]  && CIP="$(docker inspect $CONTAINER | grep IPAd | cut -d \" -f 4)"
                    echo "$DLINE" | sed -e "s/[a-f0-9]\{12,12\}/$CIP/"
                done
}

# Some generic aliases tailored to our needs
alias memusage='ps axo rss,pmem,pid,user,command | awk '"'"'{ hr=$1/1024 ; printf("%13.6f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }'"'"' | sort -n'

# Some personal aliases
## Find easily process
alias mps="ps aux | grep -i"
## Find easily ports
alias mnstat="netstat -p -l -n | grep -i"

# Skip these if we are inside tmux since they already ran:
if [ ! -n "$TMUX" ]; then

    # Make sure /etc/resolv.conf is readable:
    sudo chmod 644 /etc/resolv.conf

    # Create a google cloud ssh key if not exists:
    [ ! -f ~/.ssh/google_compute_engine ] && mkdir -p ~/.ssh && ssh-keygen -f ~/.ssh/google_compute_engine -N ''
    # If not credentialed and there are some credentials, use them:
    export CLOUDSDK_PYTHON_SITEPACKAGES=1
    if [ -f ~/.setup/gce.account ] && [ -f ~/.setup/gce.key ]; then
        mkdir -p ~/.gcecreds
        echo "Installing GCE credentials"
        sudo su -c 'install -o dev -g dev -m 600 /home/dev/.setup/gce.* /home/dev/.gcecreds/'
        if /usr/local/share/google-cloud-sdk/bin/gcloud auth list 2>&1 | grep -sq 'No credentialed accounts.' ; then
            echo "Activating GCE account"
            /usr/local/share/google-cloud-sdk/bin/gcloud auth activate-service-account $(cat ~/.gcecreds/gce.account) --key-file ~/.gcecreds/gce.key
            sleep 1
            /usr/local/share/google-cloud-sdk/bin/gcloud config set account $(cat ~/.gcecreds/gce.account)
        fi
        # Create and set ansible's secrets.py and gce.ini for accessing GCE project
        if [ -f ~/.gcecreds/gce.project ]; then
            echo "GCE_PARAMS = ('$(cat ~/.gcecreds/gce.account)', '/home/dev/.gcecreds/gce.key')" > ~/.gcecreds/secrets.py
            echo "GCE_KEYWORD_PARAMS = {'project': '$(cat /home/dev/.gcecreds/gce.project)'}" >> ~/.gcecreds/secrets.py
            export PYTHONPATH=/home/dev/.gcecreds/
            export GCE_INI_PATH=/home/dev/.gcecreds/gce.ini
        fi
    fi

    # Install ssh keys and settings if needed
    if [ "$(sudo ls ~/.setup-ssh | wc -l)" -gt 0 ]; then
        echo "Installing SSH keys and settings"
        mkdir -p ~/.ssh
        sudo su -c 'install -o dev -g dev -m 600 /home/dev/.setup-ssh/* /home/dev/.ssh/'
    fi

    # Install custom git config if provided
    if [ -f ~/.setup/gitconfig ]; then
        echo "Installing gitconfig"
        rm -f ~/.gitconfig
        sudo su -c 'install -o dev -g dev -m 660 /home/dev/.setup/gitconfig /home/dev/.gitconfig'
    fi

    # Optional start SSH agent
    eval $(ssh-agent -t 604800)
    # add id_rsa and google_compute_engine
    ssh-add
    ssh-add ~/.ssh/google_compute_engine
    # add other keys set in ssh config
    if [ -f /home/dev/.ssh/config ]; then
        for i in $(grep IdentityFile ~/.ssh/config | sed -e 's/.*IdentityFile //' | sort -u); do
            eval i=$i
            ssh-add $i
        done
    fi

    # Clone / pull repos
    REPLY=""
    read -p "Do you want me to clone new / pull existing repositories? [y/N] " -n 2 -r
    if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
        # Pull existing repos
        for i in $(ls /home/dev/sources/) ; do
            pushd /home/dev/sources/$i
            git pull
            popd
        done
        # Clone new repos
        if [ -f /home/dev/.setup/repos ]; then
            sudo su -c 'install -o dev -g dev -m 600 /home/dev/.setup/repos /home/dev/.repos'
            while read LINE; do
                if [ ! -d /home/dev/sources/$(basename -s .git $LINE) ]; then
                    pushd /home/dev/sources
                    git clone $LINE
                    popd
                fi
            done </home/dev/.repos
        fi
    fi

    echo -e "\033[0;36mWelcome and remember; \033[1;36mdo not panic\033[0;36m.\033[0m"

    print_exitnotice(){
        echo -e "\033[0;36m
You exited devenv container. You probably can access it again (and not a new
container) if you didn't use the docker '--rm' option by running:
\033[1;0m $ docker start -ai $HOSTNAME
\033[1;36mSo long, and thanks for all the fish.\033[0m"
    }

    trap print_exitnotice EXIT

else
    echo "Inside tmux, skipping setup."
fi

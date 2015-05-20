source /etc/bashrc

export PS1="\[\033[1;31m\]\u\[\033[1;33m\]@\[\033[1;34m\]\h \[\033[1;36m\]\W\[\033[1;0m\] $ "

# commands starting with space should be recorded to history! Nice for passwords.
# Also ignore duplicate entries
export HISTCONTROL=ignorespace:ignoredups
export HISTSIZE=10000

# Go path
export PATH="${PATH}:${HOME}/go/bin"
export GOPATH=${HOME}/go

# Useful and nice git logs
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glnc="git log --pretty=format:'%h -%d %s (%cr) <%an>' --abbrev-commit"

# Python http server working with both 2.7 and 3.x
pythonserver()
{
    python -m SimpleHTTPServer $1 || python -m http.server $1
}

# Set git variables
git config --global user.name "Marios Andreopoulos"
git config --global user.email opensource@andmarios.com
git config --global core.editor nano

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

# Create a google cloud ssh key if not exists:
[ ! -f ~/.ssh/google_compute_engine ] && mkdir -p ~/.ssh && ssh-keygen -f ~/.ssh/google_compute_engine -N ''
# If not credentialed and there are some credentials, use them:
export CLOUDSDK_PYTHON_SITEPACKAGES=1
if [ -d ~/.gcecreds ]; then
    mkdir -p ~/.gcecredsreal
    sudo install -o dev -g dev -m 600 ~/.gcecreds/* ~/.gcecredsreal/
    if /usr/local/share/google-cloud-sdk/bin/gcloud auth list 2>&1 | grep -sq 'No credentialed accounts.' ; then
        echo "Activating GCE"
        /usr/local/share/google-cloud-sdk/bin/gcloud auth activate-service-account $(cat ~/.gcecredsreal/account) --key-file ~/.gcecredsreal/key.pem
        sleep 2
        /usr/local/share/google-cloud-sdk/bin/gcloud config set account $(cat ~/.gcecredsreal/account)
    fi
fi

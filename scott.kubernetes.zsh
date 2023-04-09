autoload -U colors; colors

function get_krew_command() {
    NAME=$1
    echo $(kubectl krew info $NAME | grep NAME: | awk '{ print $NF }')
}

function build_krew_aliases() {
    # Builds aliases for kubectl krew commands
    for line in $(kubectl krew list 2>/dev/null | grep -v 'NAME');
    do
        N=$(echo $line | awk '{ print $1 }')
        CMND=$(get_krew_command $N)
        ALIAS=$(get_alias_name $CMND)
        alias $ALIAS="kubectl $CMND"
    done
}

function lc() {
    echo "Available Contexts Are:"
    for n in $(kubectl config get-contexts -o name); do
        echo "   - $n"
    done
}

function ckc() {
    # Returns the current Kubernetes config context
    CCTX=$(kubectl config get-contexts | egrep '^\*' | awk '{ print $3 }')
    echo "Your Current Context Is: $CCTX"
}

function uc() {
    # Uses a kubernetes config context
    if [[ -z $1 ]]; then
        echo "ERROR: Missing Cluster Label"
        echo "USAGE: $0 CONTEXT"
        echo
        exit
    fi

    DESIRED_CONTEXT=$1
    CONTEXT_NAME=$(kubectl config get-contexts --no-headers  | sed 's/^*/ /' | sed 's/^ *//g' | egrep "\s*$DESIRED_CONTEXT " | awk '{ print $1 }')
    if [[ -z $CONTEXT_NAME ]]; then
        echo "ERROR: Invalid Cluster Name: $DESIRED_CONTEXT"
        echo "Available Clusters: $(kubectl config get-contexts | grep -v CLUSTER | sed 's/^\*/ /' | awk '{ print $2 }' | xargs )"
        echo
    else
        kubectl config use-context $CONTEXT_NAME
    fi
}


function refresh_kubectl_completion() {
    if [[ -f ${EXT_CONFIG}/completion__kubectl.zsh ]]; then 
        rm -f ${EXT_CONFIG}/completion__kubectl.zsh
    fi
    setup_kubectl_completion
}

function setup_kubectl_completion() {
    # Sets up Kubernetes Shell Completion if it doesn't exist
    # and then it sources the file
    if [[ ! -f ${EXT_CONFIG}/completion__kubectl.zsh ]]; then
        ensure_ext_config
        /usr/bin/env kubectl completion zsh > ${EXT_CONFIG}/completion__kubectl.zsh
    fi
    source ${EXT_CONFIG}/completion__kubectl.zsh
}

function install_krew() {
    # Installs the krew plugin manager for kubectl
    OWD=$(pwd)

    set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew

    cd $OWD
}

function krew_installed() {
    if [[ $(kubectl krew help 2>&1 | wc -l) -gt 10 ]]; then
        echo true
    else
        echo false
    fi
}

function set_active_kubectl() {
    # Sets the active version of kubectl
    VERSION=$1
    if [[ -z ${VERSION} ]]; then
        echo "ERROR: Required version missing"
        echo "USAGE: $0 VERSION"
    else
        if [[ -f ${HOME}/bin/kubectl-${VERSION} ]]; then
            CV=$(get_current_kubectl_version)
            echo "Changing active kubectl"
            echo "FROM: ${CV}"
            echo "TO:   ${VERSION}"
            rm ${HOME}/bin/kubectl
            ln -s ${HOME}/bin/kubectl-${VERSION} ${HOME}/bin/kubectl
        else
            echo "ERROR: Invalid Version: ${VERSION}"
            echo "Available Versions Are:"
            for v in $(list_available_kubectl_versions);
            do
                echo "    - ${v}"
            done
        fi
    fi
}


function list_available_kubectl_versions() {
    # Lists all of the locally installed kubectl versions
    AV=()
    for v in $(ls --color=never ${HOME}/bin/kubectl-* | egrep 'kubectl-\d+.\d+.\d+' | awk -F- '{ print $NF }');
    do
        AV+=($v)
    done
    echo ${AV}
}

alias lskubevers="list_available_kubectl_versions"

function set_krew_path() {
    # Sets the krew path
    if [[ -d $HOME/.krew ]];  then
        KPATH="${KREW_ROOT:-$HOME/.krew}/bin"
        export PATH="${KPATH}:$PATH"
    fi
}

function enable_krew_aliases() {
    touch ${SETTINGS_DIR}/.load_krew_aliases
}

function disable_krew_aliases() {
    rm -f ${SETTINGS_DIR}/.load_krew_aliases 2>/dev/null
}



function build_kubectl_aliases() {

    if [[ ! -f ${EXT_CONFIG}/aliases__kubectl.zsh ]]; then 
        cp /dev/null ${EXT_CONFIG}/aliases__kubectl.zsh

        echo "Building Kubectl Aliases..."
        for cmd in $(kubectl help 2>/dev/null | egrep '^  '  | awk '{ print $1 }'); 
        do
            if [[ $(command_exists ${cmd}) == true ]]; then 
                echo alias k${cmd}="kubectl ${cmd}" >> ${EXT_CONFIG}/aliases__kubectl.zsh
            else
                echo alias ${cmd}="kubectl ${cmd}" >> ${EXT_CONFIG}/aliases__kubectl.zsh
            fi
        done
    fi
}

function build_krew_aliases() {
    FAGE=$(get_file_age_in_days ${EXT_CONFIG}/aliases__krew.zsh)
    if [[ ${FAGE} -gt 3 ]]; then 
        rm -f ${EXT_CONFIG}/aliases__krew.zsh
    fi

    if [[ -f ${SETTINGS_DIR}/.load_krew_aliases ]]; then
        if [[ ! -f ${EXT_CONFIG}/aliases__krew.zsh ]]; then 
            cp /dev/null ${EXT_CONFIG}/aliases__krew.zsh
            echo -n 'Building Krew Aliases: '
            for plugin in ${KREW_PLUGINS};
            do
                if [[ $(which kubectl-${plugin} | egrep -v 'not found' | wc -l) -eq 1 ]]; then
                    echo alias ${plugin}="kubectl ${plugin}" >> ${EXT_CONFIG}/aliases__krew.zsh
                    echo -n "${plugin} "
                fi
            done
        fi
    fi
}

function() {
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
    build_kubectl_aliases
    build_krew_aliases
    if [[ -f $HOME/.gpc/.load_krew_aliases ]]; then
        for plugin in ${KREW_PLUGINS};
        do
            if [[ $(which kubectl-${plugin} | egrep -v 'not found' | wc -l) -eq 1 ]]; then
                alias ${plugin}="kubectl ${plugin}"
            fi
        done
    fi
}

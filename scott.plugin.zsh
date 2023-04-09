## Handle $0 according to the standard:
## https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

local _my_plugin_dir="${0:h}"

export SHELL_TOOLKIT_NAME="scott"
export SETTINGS_DIR="${HOME}/.config/zsh_plugin/${SHELL_TOOLKIT_NAME}"
export EXT_CONFIG="${HOME}/.${SHELL_TOOLKIT_NAME}"
export STATUS_BIN="echo"

export THIS_OS=$(uname -s)
export THIS_ARCH=$(uname -m)

function reload() {
    if [[ $1 ]]; then
        plugin="scott.$1.zsh"
        if [[ -f $_my_plugin_dir/${plugin} ]]; then
            source $_my_plugin_dir/${plugin}
        else
            echo "Cannot reload ${plugin} ($_my_plugin_dir/${plugin})"
            echo "because it doesn't exist"
        fi
    else
        source ~/.zshrc
    fi
}

function update_scott_plugin() {
    git -C ~/.oh-my-zsh/custom/plugins/scott pull
}

function update() {
    update_scott_plugin
    reload
}

function() {
    echo -n "Sourcing Libs: ..."
    for f in $(/bin/ls -d $_my_plugin_dir/lib/*.zsh); do
        source $f
        echo -n "."
    done

    echo -n " - "

    for f in $(/bin/ls -d $_my_plugin_dir/lib/vendored/*.zsh); do
        source $f
        echo -n "."
    done

    echo " DONE"

    ensure_config_dir
    ensure_ext_config
    ensure_home_permissions

    export PATH="$_my_plugin_dir/bin:${PATH}"

    for script in $(/bin/ls -d $_my_plugin_dir/*.zsh | grep -v ${SHELL_TOOLKIT_NAME}.plugin.zsh); do
        status "INFO" "Sourcing ${script}"
        source $script
    done


    if [[ -f "${HOME}/.profile" ]]; then 
        source ${HOME}/.profile
    fi

    PROMPT="%B%F{9}[%f%b%B%F{11}%n%f%b@%B%F{13}%M%f%b%B%F{9}]%f%b:%F{117}%d%f %B%F{51}$ %f%b"

}

function reload() {
    if [[ $1 ]]; then
        plugin="gpc.$1.zsh"
        if [[ -f $_my_plugin_dir/${plugin} ]]; then
            source $_my_plugin_dir/${plugin}
        else
            echo "Cannot reload ${plugin} ($_my_plugin_dir/${plugin})"
            echo "because it doesn't exist"
        fi
    else
        status "INFO" "Reloading ZSH Configuration"
        source ~/.zshrc
    fi
}

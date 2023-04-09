function ensure_ext_config() {
    mkdir -p ${EXT_CONFIG}
    chmod 700 ${EXT_CONFIG}
}

function ensure_home_permissions() {
    chmod 700 ${HOME}
    for f in $(ls ${HOME}); do
        if [[ -d ${HOME}/${f} ]]; then
            chmod 700 ${HOME}/${f}
        fi
    done
}

function ensure_config_dir() {
    mkdir -p ${SETTINGS_DIR}/${SHELL_TOOLKIT_NAME}
    chmod 700 ${SETTINGS_DIR}/${SHELL_TOOLKIT_NAME}
}

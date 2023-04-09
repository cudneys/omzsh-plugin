function status() {
    ${STATUS_BIN} $@
}

function disable_status() {
    if [[ ! -f ${SETTINGS_DIR}/${SHELL_TOOLKIT_NAME}/.disable_status ]]; then
        echo "$(date)" > ${SETTINGS_DIR}/.disable_status
    fi
}

function enable_status() {
    if [[ -f ${SETTINGS_DIR}/${SHELL_TOOLKIT_NAME}/.disable_status ]]; then
        rm -f ${SETTINGS_DIR}/.disable_status
    fi
}

function colorize_level() {
    LLEVEL=$1
    case "$LEVEL" in
        INFO) COLOR="green" ;;
        ERROR) COLOR="red" ;;
        WARNING) COLOR="white" ;;
        DEBUG) COLOR="cyan" ;;
        *) COLOR="yellow";;
    esac
    echo "$fg_bold[${COLOR}]${LEVEL}${reset_color}"
}

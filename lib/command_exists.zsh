function command_exists() {
    NAME=$1
    EXISTS=$(type ${NAME} | grep -v 'not found' | wc -l)
    if [[ ${EXISTS} == 0 ]]; then
        echo false
    else
        echo true
    fi
}

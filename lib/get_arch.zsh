function get_arch() {
    ARCH=$(uname -m)
    if [[ ${ARCH} == "x86_64" ]]; then
        echo "amd64"
    else
        echo ${ARCH}
    fi
}

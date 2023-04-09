function get_os() {
    OS=$(uname)
    echo ${(L)OS}
}

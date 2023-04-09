function get_cert_file_expiration() {
    FILE=$1

    if [[ -z ${FILE} ]]; then
        echo "ERROR: Missing Filename"
        echo "USAGE: $0 FILE_PATH"
    else
        cat ${FILE} | openssl x509 -noout -enddate
    fi
}

function check_remote_cert() {
    host=$1

    if [[ -z ${host} ]]; then
        echo "ERROR: Missing Host:port"
        echo "USAGE: $0 HOSTNAME:PORT"
    else
        echo | openssl s_client -showcerts -connect ${host}
    fi
}

function test_tls() {
    function test_tls_available_versions() {
        echo "Available versions are:"
        echo "  - 1.0"
        echo "  - 1.1"
        echo "  - 1.2"
        echo "  - 1.3"
        echo
    }
    VERSION=$1
    HOST=$2

    if [[ -z ${VERSION} || -z ${HOST} ]]; then
        echo "ERROR: Missing Parameter"
        echo "USAGE: $0 VERSION HOST:PORT"
        echo
        test_tls_available_versions
        echo
    else
        case ${VERSION} in
            1.1)
                TLS_VERSION="-tls1_1"
                ;;
            1.2)
                TLS_VERSION="-tls1_2"
                ;;
            1.3)
                TLS_VERSION="-tls1_3"
                ;;
            *)
                echo "ERROR: INCORRECT TLS VERSION: ${VERSION}"
                test_tls_available_versions
                return
                ;;
        esac
        echo | openssl s_client -connect ${HOST} ${TLS_VERSION}
    fi
}

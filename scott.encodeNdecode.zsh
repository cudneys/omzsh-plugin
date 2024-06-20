function decode() {
	STR=$1
	if [[ -z ${STR} ]]; then
		echo "ERROR: Missing input string"
		echo "USAGE: $0 STRING"
	else
		echo "${STR}" | base64 -d
	fi
}

function encode() {
    STR=$1
    if [[ -z ${STR} ]]; then
        echo "ERROR: Missing input string"
        echo "USAGE: $0 STRING"
    else
        echo "${STR}" | base64
    fi
}

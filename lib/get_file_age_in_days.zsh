
function get_file_age_in_days() {
    FILEPATH=$1
    echo $((($(date +%s) - $(date +%s -r "${FILEPATH}")) / 86400))
}

function get_file_age_in_seconds() {
    FILEPATH=$1
    echo $(($(date +%s) - $(date +%s -r "${FILEPATH}"))) seconds
}

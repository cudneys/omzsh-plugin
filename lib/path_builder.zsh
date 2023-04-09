function build_path() {
    BASE_PATH="${HOME}/bin:$_my_plugin_dir/bin"

    if [[ -d "${HOME}/go/bin" ]]; then 
        BASE_PATH="${BASE_PATH}:$HOME/go/bin"
    fi

    if [[ -d ${HOME}/.krew/bin ]]; then 
        BASE_PATH="${BASE_PATH}:${HOME}/.krew/bin"
    fi

	if [[ -f ${EXT_CONFIG}/.paths ]]; then
		for pathentry in $(cat ${EXT_CONFIG}/.paths);
		do
			status "DEBUG" "Adding To Path: ${pathentry}"
			BASE_PATH="${BASE_PATH}:${pathentru}"
		done
	fi

    
    BASE_PATH="${BASE_PATH}:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin"

	PATH=${BASE_PATH}
	export PATH
	typeset -U PATH
	typeset -U path
}

function() {
    build_path

}

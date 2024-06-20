
MY_NAME=${0:t}
MY_PLUGIN_DIR=${0:h}/
export MY_CONFIG_DIR=${HOME}/.config/${MY_NAME}

function make_proper_directory() {
	if [[ ! -d $1 ]]; then 
		mkdir -p $1
		chmod 700 $1
	fi
}

function make_home_bin() {
	make_proper_directory $HOME/bin
}

# Make sure that we have a config directory
if [[ ! -d ${MY_CONFIG_DIR} ]]; then 
	mkdir -p ${MY_CONFIG_DIR}
fi

# Always make sure the permissions are set appropriately...
chmod 700 ${MY_CONFIG_DIR}

# Source the rest of the zsh files in this directory...
for f in $(ls $MY_PLUGIN_DIR/*.zsh | grep -v $MY_NAME); do
	source $f
done

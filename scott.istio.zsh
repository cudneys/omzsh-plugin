
function get_latest_istio_version() {
	ISTIO_VERSION="$(curl -sL https://github.com/istio/istio/releases | \
                  grep -o 'releases/[0-9]*.[0-9]*.[0-9]*/' | sort -V | \
                  tail -1 | awk -F'/' '{ print $2}')"
  	echo "${ISTIO_VERSION##*/}"
}

function use_istioctl() {
	version=$1
	if [[ version == "" ]]; then 
		echo "USAGE: $0 ISTIOCTL_VERSION"
		return
	fi

	full_path=$HOME/bin/istioctl-$version

	if [[ ! -f $full_path ]]; then 
		echo "ERROR: istioctl version $version isn't installed"
		return
	fi 

	if [[ -f $HOME/bin/istioctl ]]; then 
		rm -f $HOME/bin/istioctl
	fi
	ln -s $full_path $HOME/bin/istioctl
	if [[ $? -eq 0 ]]; then 
		echo "istioctl is now version $version"
	else
		echo "Well, that didn't work!"
	fi
}

function current_istioctl_version() {
	version=""
	if [[ -f $HOME/bin/istioctl ]]; then
		version=$(ls -ld $HOME/bin/istioctl | awk -F- '{ print $NF }')
	fi
	echo $version
}

function ls_istioctl_versions() {
	current_version=$(current_istioctl_version)
	for i in $(ls $HOME/bin/istioctl-* | awk -F- '{ print $NF }'); do
		echo -n "$i"
		if [[ $i == $current_version ]]; then 
			echo " <-- Current Version"
		else
			echo
		fi
	done
}

function install_istioctl() {
	ppwd=$(pwd)
	version=$1
	if [[ -z $version ]]; then
		version=$(get_latest_istio_version)
	fi

	if [[ $(uname) == "Darwin" ]]; then
  		osext="osx"
	else
  		osext="linux"
	fi

	arch=$(uname -m)
	case "$arch" in
  		x86_64|amd64)
    			istio_arch=amd64
    		;;
  		armv8*|aarch64*|arm64)
    			istio_arch=arm64
    		;;
  		armv*)
    			istio_arch=armv7
    		;;
  		*)
    			echo "This system's architecture, $arch, isn't supported"
    			return
    		;;
	esac

	if [[ -f $HOME/bin/istioctl-$version ]]; then
		echo "Istioctl version $version is already installed"
		return
	fi
	
	url="https://github.com/istio/istio/releases/download/${version}/istio-${version}-${osext}-${istio_arch}.tar.gz"
	make_home_bin
	cd $HOME/bin
	if [[ ! -f istio-${version}-${osext}-${istio_arch}.tar.gz ]]; then 
		wget -O $HOME/bin/istio-${version}-${osext}-${istio_arch}.tar.gz $url
	else 
		echo "istio-${version}-${osext}-${istio_arch}.tar.gz exists"
	fi

	tar zxf istio-${version}-${osext}-${istio_arch}.tar.gz
	cp istio-$version/bin/istioctl ./istioctl-$version
	rm -rf istio-$version
	rm -f istio-${version}-${osext}-${istio_arch}.tar.gz

	if [[ -f $HOME/bin/istioctl-$version ]]; then 
		echo "Installed $HOME/bin/istioctl-$version"
	fi
}

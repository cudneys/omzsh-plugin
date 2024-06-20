
home_paths=( 'bin' 'sbin' 'go/bin' )

for dir in "$home_paths[@]"; do
	if [[ -d $HOME/$dir ]]; then
		export PATH=$PATH:$HOME/$dir
	fi
done


export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

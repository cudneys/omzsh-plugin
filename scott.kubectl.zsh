
if (( ! $+commands[kubectl] )); then
  return
fi


if [[ ! -f "$ZSH_CACHE_DIR/completions/_kubectl" ]]; then
  kubectl completion zsh 2> /dev/null >| "$ZSH_CACHE_DIR/completions/_kubectl" &|
  typeset -g -A _comps
  autoload -Uz _kubectl
  _comps[kubectl]=_kubectl
fi



IFS='
'

for line in $(kubectl --help | egrep '^  ' | awk '{ print $1 }'); do
	name=$line
	if type $name 1>/dev/null 2>&1; then
		name="k$line"
	fi
	alias $name="kubectl $line"
done

unset IFS

for thing in $(kubectl krew list | egrep -v 'PLUGIN|grep' ); do alias ${thing}="kubectl $thing"; done

alias get-contexts='kubectl config get-contexts'
alias use-context='kubectl config use-context'
alias current-context='kubectl config current-context'
alias context=current-context
alias contexts="kubectl config get-contexts | grep -v NAME | sed 's/\*//' | awk '{ print \$1 }'"

if [[ -f ${HOME}/.config/${MY_NAME}/override_edit ]]; then 
	alias edit='kubectl edit'
fi

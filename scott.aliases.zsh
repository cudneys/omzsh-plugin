alias d="dirs -v"
alias dl="d"

alias ll='ls -lah'
alias la='ls -alh'
alias ltr='ls -ltrh'
alias llr='ls -lRh'

alias drun="docker run -it"
alias dbnr="drun $(docker build . 2>&1 | grep 'writing image' | awk '{ print $4 }')"

alias yolo='git commit -m "$(curl -s http://whatthecommit.com/index.txt)"'

alias cls="clear"

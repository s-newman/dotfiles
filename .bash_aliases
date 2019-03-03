# Color support!
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egre --color=auto'

# More ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Docker aliases to keep me sane
alias docker-stop='sudo docker stop $(sudo docker ps -a -q)'
alias docker-rm='sudo docker rm $(sudo docker ps -a -q)'
alias docker-clean='docker-stop && docker-rm'
alias docker-rmimages='sudo docker rmi -f $(sudo docker images -a -q)'
alias docker-reset='docker-clean && docker-rmimages'

# Virtual environment nonsense
alias activate='source ~/bin/activator'
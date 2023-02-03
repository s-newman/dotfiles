# Color support!
if [ "$(uname)" = "Darwin" ]
then
  alias ls='ls -G'
else
  alias ls='ls --color=auto --hyperlink=auto'
fi
alias grep='grep --color=auto'

# VIM
[ -f /opt/homebrew/opt/vim/bin/vim ] && alias vim=/opt/homebrew/opt/vim/bin/vim

# Docker aliases to keep me sane
alias docker-stop='sudo docker stop $(sudo docker ps -a -q)'
alias docker-rm='sudo docker rm $(sudo docker ps -a -q)'
alias docker-clean='docker-stop && docker-rm'
alias docker-rmimages='sudo docker rmi -f $(sudo docker images -a -q)'
alias docker-reset='docker-clean && docker-rmimages'

# Alias kubectl to be easier to type
alias k='kubectl'

# gcloud stuff
alias gcon='gcloud config configurations'
alias gssh='gcloud compute ssh'
alias gscp='gcloud compute scp'
alias glist='gcloud compute instances list'

# Only use yay for AUR
alias yay='yay --aur'

# virtualenvwrapper
alias lsvenv='lsvirtualenv'
alias mkvenv='lsvirtualenv'
alias rmvenv='rmvirtualenv'

# Homebrew (real) OpenSSL
alias brew-openssl='/usr/local/opt/openssl/bin/openssl'

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

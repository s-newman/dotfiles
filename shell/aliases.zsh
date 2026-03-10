# Color support!
if [ "$(uname)" = "Darwin" ]; then
  alias ls='ls -G'
elif [ -n "${SSH_CONNECTION-}" ] && [ "${LC_TERMINAL-}" = "iTerm2" ]; then
  # Don't render hyperlinks on Linux with iTerm2 -- it adds underlines to every
  # file and looks kinda weird
  alias ls='ls --color=auto'
elif [ "$(uname)" = "Linux" ]; then
  # You know what? Also just don't render hyperlinks on Linux
  alias ls='ls --color=auto'
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

# Homebrew (real) OpenSSL
alias brew-openssl='/usr/local/opt/openssl/bin/openssl'

# Quick SSH connections
alias dangeroussh='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias dangerouscp='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# Just
alias j='just'
alias jb='just build'
alias jl='just --list'

# Mise
alias m='mise'
alias mm='mise run'

# Going up directories faster
# https://askubuntu.com/a/703701
function up() {
  num=$1
  while [ ${num} -ne 0 ]; do
    cd ..
    num=$((num-1))
  done
}

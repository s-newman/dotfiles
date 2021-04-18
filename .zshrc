# --- Prompt customization ----------------------------------------------------

# Load starship prompt
if [ -x "$(command -v starship)" ]
then
  eval "$(starship init zsh)"
else
  printf "Please install starship for an improved prompt.\n\nTo install:\n\t"
  printf "curl -fsSL https://starship.rs/install.sh | bash\n\n"
  printf "You can also install by compiling from source:\n\t"
  printf "cargo install --features notify-rust starship\n\n"
fi

# --- Shell extension scripts -------------------------------------------------

# Aliases (stolen from bash configuration)
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# --- Zsh option customization ------------------------------------------------

# Case-insensitive completion
setopt GLOB_COMPLETE

# Use a single history file for all sessions
setopt SHARE_HISTORY

# Make sure shells are aware of each other's history
setopt SHARE_HISTORY

# Do not store duplicates in history
setopt HIST_IGNORE_DUPS

# Remove blank likes from history
setopt HIST_REDUCE_BLANKS

# Show complete command before running when referencing history entries (such
# as with `!!`)
setopt HIST_VERIFY

# Turn off spelling correction
unsetopt CORRECT_ALL

# Reverse I search
bindkey -v
bindkey '^R' history-incremental-search-backward

# --- Completion customization ------------------------------------------------

# kubectl completion
[ -f /usr/bin/kubectl ] && source <(kubectl completion bash)

# Enable advanced completion
autoload -Uz compinit && compinit

# Case-insensitive path completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Partial path completion
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix

# --- GCP stuff goes here because it breaks otherwise -------------------------

# Linux installation
[ -f '/opt/google-cloud-sdk/path.zsh.inc' ] && . '/opt/google-cloud-sdk/path.zsh.inc'
[ -f /opt/google-cloud-sdk/completion.zsh.inc ] && . /opt/google-cloud-sdk/completion.zsh.inc

# Mac installation (via curl https://sdk.cloud.google.com | bash)
if [ -f '/Users/sean/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sean/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/Users/sean/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sean/google-cloud-sdk/completion.zsh.inc'; fi

# --- Custom functions --------------------------------------------------------

# Runs an ansible ad-hoc command. If passing one argument, the argument is the
# shell command to be executed. The command will be run against `all`. If
# passing two arguments, the first is the group to run the command against, and
# the second is the shell command.
ansible-cmd() {
  if [ "$#" -eq 1 ]
  then
    GROUP="all"
    CMD=$1
  elif [ "$#" -eq 2 ]
  then
    GROUP=$1
    CMD=$2
  else
    echo 'USAGE: ansible-cmd [GROUP] "CMD"'
    return 1
  fi

  ansible $GROUP -i inventory.ini -bm ansible.builtin.shell -a $CMD
}

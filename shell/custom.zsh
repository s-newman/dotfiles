# --- Stuff that goes first ---------------------------------------------------

# Helper function to include files only if they exist
# https://stackoverflow.com/a/10737906
_try_source () {
  [ -f "${1}" ] && source "${1}"
}

# Zinit setup
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
[ ! -d "${ZINIT_HOME}" ] && mkdir -p "$(dirname "${ZINIT_HOME}")"
[ ! -d "${ZINIT_HOME}/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"

# Zinit configuration
declare -A ZINIT
# Disable `zi` alias since it conflicts with zoxide
ZINIT[NO_ALIASES]=1

# Now enable zinit
source "${ZINIT_HOME}/zinit.zsh"

# Environment vars
_try_source "${HOME}/.config/shell/envs.zsh"

# Aliases
_try_source "${HOME}/.config/shell/aliases.zsh"

# System-specific customizations
_try_source "${HOME}/.config/shell/system.zsh"

# --- Zsh option customization ------------------------------------------------

# Activate completion system
autoload -Uz compinit && compinit

# Case-insensitive completion
setopt GLOB_COMPLETE

# Use a single history file for all sessions
setopt SHARE_HISTORY

# Do not store duplicates in history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Remove blank likes from history
setopt HIST_REDUCE_BLANKS

# Show complete command before running when referencing history entries
setopt HIST_VERIFY

# Turn off spelling correction
unsetopt CORRECT_ALL

# Reverse I search
bindkey '^R' history-incremental-search-backward

# Case-insensitive globs
setopt NO_CASE_GLOB

# Case-insensitive path completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Partial path completion
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix

# Use Emacs mode over Vim mode to reduce issues with editing config lines
bindkey -e

# --- Prompt customization ----------------------------------------------------

zinit ice depth=1
zinit load romkatv/powerlevel10k
_try_source "${HOME}/.p10k.zsh"

# --- Various plugins ---------------------------------------------------------

zinit load zsh-users/zsh-autosuggestions
zinit load MichaelAquilina/zsh-you-should-use
zinit load reegnz/jq-zsh-plugin

# Needs to stay near bottom
zinit load zsh-users/zsh-syntax-highlighting

# --- Plugin configuration ----------------------------------------------------

# MichaelAquilina/zsh-you-should-use -- show alias suggestion after command
# output
export YSU_MESSAGE_POSITION="after"

# --- Shell extension scripts -------------------------------------------------

# NVM
_try_source /usr/share/nvm/init-nvm.sh

# kubectl completion
[ -f /usr/bin/kubectl ] && source <(kubectl completion zsh)
[ -f /usr/local/bin/kubectl ] && source <(kubectl completion zsh)

# Virtualenvwrapper
export WORKON_HOME="${HOME}/envs"
mkdir -p "${WORKON_HOME}"
_try_source /opt/homebrew/bin/virtualenvwrapper.sh # MacOS (ARM)
_try_source /usr/local/bin/virtualenvwrapper.sh # MacOS (Intel)
_try_source /usr/bin/virtualenvwrapper.sh # Linux

# Broot
[ -x /usr/bin/broot ] && source <(broot --print-shell-function zsh)

# fluxcd completion
[ -x /opt/homebrew/bin/flux ] && source <(flux completion zsh)

# fzf
_try_source "${HOME}/.fzf.zsh"

# Docker desktop
_try_source "${HOME}/.docker/init-zsh.sh"

# Zoxide
{
  [ -x /opt/homebrew/bin/zoxide ] \
  || [ -x /usr/bin/zoxide ]
} && source <(zoxide init zsh)

# --- GCP stuff goes here because it breaks otherwise -------------------------

# Linux installation
_try_source /opt/google-cloud-sdk/path.zsh.inc
_try_source /opt/google-cloud-sdk/completion.zsh.inc

# Mac installation (via curl https://sdk.cloud.google.com | bash)
_try_source "${HOME}/google-cloud-sdk/path.zsh.inc"
_try_source "${HOME}/google-cloud-sdk/completion.zsh.inc"

# --- Et cetera ---------------------------------------------------------------

# Hacky fix to get colors working in Tmux
[ -n "${TMUX}" ] && export TERM=xterm-256color

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

# --- Stuff that goes first ---------------------------------------------------

# Helper function to include files only if they exist
# https://stackoverflow.com/a/10737906
_try_source () {
  [ -f "${1}" ] && source "${1}"
}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Aliases
_try_source "${HOME}/.config/shell/aliases.zsh"

# Environment vars
_try_source "${HOME}/.config/shell/envs.zsh"

# --- Zsh option customization ------------------------------------------------

# Activate completion system
autoload -Uz compinit && compinit

# Case-insensitive completion
setopt GLOB_COMPLETE

# Use a single history file for all sessions
setopt SHARE_HISTORY

# Do not store duplicates in history
setopt HIST_IGNORE_DUPS

# Remove blank likes from history
setopt HIST_REDUCE_BLANKS

# Show complete command before running when referencing history entries
setopt HIST_VERIFY

# Turn off spelling correction
unsetopt CORRECT_ALL

# Reverse I search
bindkey -v
bindkey '^R' history-incremental-pattern-search-backward

# Case-insensitive globs
setopt NO_CASE_GLOB

# Case-insensitive path completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Partial path completion
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix

# --- Prompt customization ----------------------------------------------------

_try_source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme # MacOS (ARM)
_try_source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme # MacOS (Intel)
_try_source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme # Linux
_try_source "${HOME}/.p10k.zsh"

# --- Shell extension scripts -------------------------------------------------

# NVM
_try_source "${NVM_DIR}/nvm.sh"

# kubectl completion
[ -f /usr/bin/kubectl ] && source <(kubectl completion zsh)
[ -f /usr/local/bin/kubectl ] && source <(kubectl completion zsh)

# Syntax highlighting
_try_source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # MacOS (ARM)
_try_source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # MacOS (Intel)
_try_source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Linux

# Autosuggestions
_try_source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh # MacOS (ARM)
_try_source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh # MacOS (Intel)
_try_source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh # Linux

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
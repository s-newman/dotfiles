# --- Stuff that goes first ---------------------------------------------------

# Log a message with time and color to STDERR.
#
# ARGS
#   $@: Message to print to STDERR.
_log() {
  print -P "[%F{green}%f* %F{cyan}$(date '+%Y-%m-%d %H:%M:%S')%f] $@" >&2
}

# Log an error message with time and color to STDERR.
#
# This will set the error message color to RED. If you want to set your own
# colorization, you will need to add %f to the beginning of your message.
#
# ARGS
#   $@: Error message to print to STDERR.
_error() {
  print -P "[%F{red}!!%f %F{cyan}$(date '+%Y-%m-%d %H:%M:%S')%f] %F{red}$@%f" >&2
}

# Helper function to include files only if they exist
# https://stackoverflow.com/a/10737906
_try_source () {
  [ -f "${1}" ] && source "${1}"
}

# All plugins get cloned under ~/.cache/shell/plugins
export PLUGINS_DIR="${HOME}/.cache/shell/plugins"

# Load a plugin, cloning it if necessary to PLUGINS_DIR.
#
# ARGS
#   $1: The GitHub organization and repo name to clone.
#   $2: (Optional) Path within repo to the ZSH script to source. Defaults to
#       the repo name with .zsh, .plugin.zsh, or .zsh-theme at the end (checked
#       in that order). If this argument is specified and the path is not
#       found, it will be retried with the above extensions in the same order.
function _load_plugin {
  local plugin_dir clone_url repo_name source_file source_path
  repo_name="${1#*/}"
  plugin_dir="${PLUGINS_DIR}/${repo_name}"
  clone_url="https://github.com/${1}"
  source_file="${2-${repo_name}}"
  source_path="${plugin_dir}/${source_file}"

  if [ ! -d "${plugin_dir}" ]; then
    _log "${1} not found, cloning..."
    git clone --depth 1 "${clone_url}" "${plugin_dir}"
  fi

  if [ -f "${source_path}" ]; then
    source "${source_path}"
  elif [ -f "${source_path}.zsh" ]; then
    source "${source_path}.zsh"
  elif [ -f "${source_path}.plugin.zsh" ]; then
    source "${source_path}.plugin.zsh"
  elif [ -f "${source_path}.zsh-theme" ]; then
    source "${source_path}.zsh-theme"
  else
    _error "could not find source-able script for plugin: ${1}"
  fi
}

# Environment variables
source "${HOME}/.config/shell/envs.zsh"

# Aliases
source "${HOME}/.config/shell/aliases.zsh"

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

# Remove blank lines from history
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

# ----- Plugins ---------------------------------------------------------------

if [ ! -d "${PLUGINS_DIR}" ]; then
  mkdir -p "${PLUGINS_DIR}"
fi

# Shell prompt
_load_plugin romkatv/powerlevel10k powerlevel10k.zsh-theme
_try_source "${HOME}/.p10k.zsh"

_load_plugin zsh-users/zsh-autosuggestions

_load_plugin MichaelAquilina/zsh-you-should-use
# Show alias suggestion after command output
export YSU_MESSAGE_POSITION="after"

# NOTE: additional plugins loaded at the bottom

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
[ -x /opt/homebrew/bin/fzf ] && source <(fzf --zsh)

# Docker desktop
_try_source "${HOME}/.docker/init-zsh.sh"

# Zoxide
{
  [ -x /opt/homebrew/bin/zoxide ] \
  || [ -x /usr/bin/zoxide ]
} && source <(zoxide init zsh)

# Just
[ -x /opt/homebrew/bin/just ] && source <(just --completions zsh)

# Mise
[ -x /opt/homebrew/bin/mise ] && source <(mise activate zsh)

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

# ---- Final Plugins ----------------------------------------------------------
# Separate section for plugins that need to be loaded after everything else

_load_plugin zsh-users/zsh-syntax-highlighting
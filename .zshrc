# --- Prompt customization ----------------------------------------------------

# Load starship prompt
if [ -x "$(command -v starship)" ]
then
  eval "$(starship init zsh)"
else
  printf "Please install starship for an improved prompt.\n\nTo install:\n\t"
  printf "curl -fsSL https://starship.rs/install.sh | bash\n\n"
  printf "You can also install by compiling from source:\n\t"
  printf "cargo install starship\n\n"
fi

# --- Shell extension scripts -------------------------------------------------

# Aliases (stolen from bash configuration)
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# kubectl completion
[ -f /usr/bin/kubectl ] && source <(kubectl completion bash)

# --- Zsh option customization ------------------------------------------------

# Case-insensitive completion
setopt GLOB_COMPLETE

# Use a single history file for all sessions
setopt SHARE_HISTORY

# Append to the history file instead of overwriting
setopt APPEND_HISTORY

# Add commands to history as they are executed instead of waiting for shell
# exit
setopt INC_APPEND_HISTORY

# Do not store duplicates in history
setopt HIST_IGNORE_DUPS

# Remove blank likes from history
setopt HIST_REDUCE_BLANKS

# Show complete command before running when referencing history entries (such
# as with `!!`)
setopt HIST_VERIFY

# Turn on spelling correction
setopt CORRECT
setopt CORRECT_ALL

# --- Completion customization ------------------------------------------------

# Enable advanced completion
autoload -Uz compinit && compinit

# Case-insensitive path completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Partial path completion
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix
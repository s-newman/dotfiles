# --- Default content ---------------------------------------------------------

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# --- Prompt customization ----------------------------------------------------

# Load starship prompt
if [ -x "$(command -v starship)" ]
then
  eval "$(starship init bash)"
else
  printf "Please install starship for an improved prompt.\n\nTo install:\n\t"
  printf "curl -fsSL https://starship.rs/install.sh | bash\n\n"
fi

# --- Shell extension scripts -------------------------------------------------

# Aliases
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# Generic tab completion support
[ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# Git tab completion
[ -f ~/.git-completion.sh ] && source ~/.git-completion.sh

# NVM
[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

# kubectl completion
[ -f /usr/bin/kubectl ] && source <(kubectl completion bash)

# --- Environment variables ---------------------------------------------------

# Set default editor
export EDITOR=vim

# Add user bin directory to PATH for shell scripts
export PATH=${PATH}:~/bin

# Configure GOPATH
export GOPATH=${HOME}/go
export PATH=${PATH}:${GOPATH}/bin

# Add cargo installation directory for running locally-built rust binaries
export PATH=${PATH}:${HOME}/.cargo/bin

# Set configuration file directory
export XDG_CONFIG_HOME=${HOME}/.config

# Required for third display on docking station to work
# https://github.com/swaywm/sway/issues/5008
export WLR_DRM_NO_MODIFIERS=1

# Required for Zoom screen sharing (only works in browser)
# https://github.com/emersion/xdg-desktop-portal-wlr/blob/master/README.md#running
# https://github.com/emersion/xdg-desktop-portal-wlr/wiki/FAQ#when-i-try-to-share-my-screen-in-the-browser-i-get-nothing--a-black-screen
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway

# Required for Jetbrains IDEs and other Java AWT programs to display properly
export _JAVA_AWT_WM_NONREPARENTING=1

# --- Other stuff -------------------------------------------------------------

# Make sure kubectl completion works with the alias
complete -F __start_kubectl k
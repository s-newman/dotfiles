# Set default editor
[ -f /opt/homebrew/opt/vim/bin/vim ] && export EDITOR=/opt/homebrew/opt/vim/bin/vim # MacOS (ARM)
[ -f /usr/local/opt/vim/bin/vim ] && export EDITOR=/usr/local/opt/vim/bin/vim # MacOS (Intel)
[ -z "${EDITOR}" ] && export EDITOR=vim # Linux

# Configure GOPATH
export GOPATH=${HOME}/go

# Configure NVM directory
export NVM_DIR=${HOME}/.config/nvm

# Enable history file
export HISTORY=${HOME}/.zhistory
export HISTFILE=${HOME}/.zhistory
export SAVEHIST=10000
export HISTSIZE=10000

# Always use BuildKit builds
export DOCKER_BUILDKIT=1

# Don't use LS_COLORS to configure colorized ls output -- delegate color
# configuration to the terminal emulator, ensuring color scheme consistency
# across platforms.
unset LS_COLORS

# --- PATH configuration ------------------------------------------------------

# User bin directory for shell scripts
export PATH=${PATH}:${HOME}/bin

# Golang bin directory for golang-installed binaries
export PATH=${PATH}:${GOPATH}/bin

# Cargo bin directory for cargo-installed binaries
export PATH=${PATH}:${HOME}/.cargo/bin

# System-wide golang install
if [ "$(uname)" = "Linux" ]
then
  export PATH=${PATH}:/usr/local/go/bin
fi

# Homebrew things for MacOS ARM
[ -d /opt/homebrew/bin ] && export PATH=${PATH}:/opt/homebrew/bin
[ -d /opt/homebrew/opt/go/libexec ] && export GOROOT=/opt/homebrew/opt/go/libexec && export PATH=${PATH}:${GOROOT}/bin

# Poetry installation on MacOS without Homebrew
if [ "$(uname)" = "Darwin" ] && [ -d "${HOME}/Library/Python/3.9/bin" ]; then
  export PATH="${PATH}:${HOME}/Library/Python/3.9/bin"
fi

# Python --user installations and pipx installations
export PATH="${PATH}:${HOME}/.local/bin"
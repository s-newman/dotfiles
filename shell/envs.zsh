# Set default editor
if which brew
then
  export EDITOR=$(brew --prefix vim)/bin/vim
else
  export EDITOR=vim
fi

# Configure GOPATH
export GOPATH=${HOME}/go

# Configure NVM directory
export NVM_DIR=${HOME}/.config/nvm

# Configure LLVM path for working with redbpf
if [ "$(uname)" = "Linux" ]
then
  export LLVM_SYS_110_PREFIX=/usr
fi

# Enable history file
export HISTORY=${HOME}/.zhistory
export HISTFILE=${HOME}/.zhistory
export SAVEHIST=10000

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

# Homebrew things
if [ "$(uname)" = "Darwin" ]
then
  # ARM installation of homebrew
  export PATH=${PATH}:$(brew --prefix vim)/vim

  # Golang stuff on MAC
  export GOROOT=$(brew --prefix golang)/libexec
  export PATH=${PATH}:${GOROOT}/bin
fi

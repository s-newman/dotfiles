# Set default editor
export EDITOR=vim

# Configure GOPATH
export GOPATH=${HOME}/go

# Configure NVM directory
export NVM_DIR=${HOME}/.config/nvm

# Required for third display on docking station to work
# https://github.com/swaywm/sway/issues/5008
export WLR_DRM_NO_MODIFIERS=1

# Set configuration file directory
export XDG_CONFIG_HOME=${HOME}/.config

# Required for Zoom screen sharing (only works in browser)
# https://github.com/emersion/xdg-desktop-portal-wlr/blob/master/README.md#running
# https://github.com/emersion/xdg-desktop-portal-wlr/wiki/FAQ#when-i-try-to-share-my-screen-in-the-browser-i-get-nothing--a-black-screen
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway

# Required for Jetbrains IDEs and other Java AWT programs to display properly
export _JAVA_AWT_WM_NONREPARENTING=1

# --- PATH configuration ------------------------------------------------------

# User bin directory for shell scripts
export PATH=${PATH}:~/bin

# Golang bin directory for golang-installed binaries
export PATH=${PATH}:${GOPATH}/bin

# Cargo bin directory for cargo-installed binaries
export PATH=${PATH}:${HOME}/.cargo/bin

# Homebrew things
if [ "$(uname)" = "Darwin" ]
then
  # ARM installation of homebrew
  export PATH=${PATH}:/opt/homebrew/bin

  # Homebrew-installed sphinx
  export PATH=${PATH}:/opt/homebrew/opt/sphinx-doc/bin
fi
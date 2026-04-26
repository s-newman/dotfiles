#!/usr/bin/env bash
# Deploys the configuration files by creating soft links
set -eou pipefail

# Used by _link_script function
shopt -s extglob

# Used by script install for-loop
shopt -s nullglob

# Figure out where our configs are located
# NOTE: this requires that this (install.sh) script is NOT a link!
CONFIGDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Link a config file into the specified homedir path.
# $1 - source path (relative to $CONFIGDIR)
# $2 - dest path (relative to $HOME)
function _link_file {
  local src="${1}"
  local dest="${2}"
  ln -fs "${CONFIGDIR}/${src}" "${HOME}/${dest}"

  echo "[config] ${src} --> ~/${dest}"
}

# Link a config directory into the specified homedir path.
# $1 - source path (relative to $CONFIGDIR)
# $2 - dest path (relative to $HOME)
function _link_dir {
  local src="${1}"
  local dest="${2}"
  ln -fsn "${CONFIGDIR}/${src}" "${HOME}/${dest}"

  echo "[folder] ${src} --> ~/${dest}"
}

# Link a script file into ~/bin, without the .sh extension
function _link_script {
  local script
  script=$(basename "${1}")
  target="bin/${script/%@(.sh|.zsh|.py)/}"
  ln -fs "${CONFIGDIR}/scripts/${script}" "${HOME}/${target}"

  echo "[script] ${1} --> ~/${target}"
}

# Ensure directories exist
mkdir -p "${HOME}/.config" # Store as many configs here as we can to keep the homedir clean
mkdir -p "${HOME}/bin" # Custom scripts go here
mkdir -p "${HOME}/.cargo" # Cargo wants a special folder for its config :(

scripts=$(find scripts -type f -maxdepth 1 -name "*.sh" -or -name "*.zsh" -or -name "*.py" | sed -e 's/^\.\///' -e '/^scripts\/_/d')
for script in ${scripts}; do
  _link_script "${script}"
done

# Package lists for package managers that don't have an equivalent to Brewfile
_link_dir packages .config/packages

# Alacritty
_link_dir alacritty .config/alacritty

# Cargo
_link_file cargo/config.toml .cargo/config.toml

# Direnv
_link_dir direnv .config/direnv

# Electron
if [ "$(uname)" = "Linux" ]; then
  _link_file electron-flags.conf .config/electron-flags.conf
fi

# Flake8
_link_file .flake8 .config/flake8

# Git
_link_file .gitconfig .gitconfig
_link_file .gitignore-global .gitignore-global

# GNU Readline
_link_file .inputrc .inputrc

# GTK 3.0/4.0
mkdir -p "${HOME}/.config/gtk-3.0"
_link_file gtk-settings.ini .config/gtk-3.0/settings.ini
mkdir -p "${HOME}/.config/gtk-4.0"
_link_file gtk-settings.ini .config/gtk-4.0/settings.ini

# Homebrew
_link_file Brewfile .Brewfile

# Kitty
_link_dir kitty .config/kitty

# Pacman
_link_dir pacman .config/pacman

# Radare2
_link_file .radare2rc .radare2rc

# Systemd User Env Vars
if [ "$(uname)" = "Linux" ]; then
  _link_dir environment.d .config/environment.d
fi

# Terminator
_link_dir terminator .config/terminator

# Tmux
_link_file .tmux.conf .tmux.conf

# Vim
_link_dir .vim .vim

# VS Code
if [ "$(uname)" = "Darwin" ]; then
  mkdir -p "${HOME}/Library/Application Support/Code/User"
  _link_file settings.json "Library/Application Support/Code/User/settings.json"
else
  mkdir -p "${HOME}/.config/Code/User"
  _link_file settings.json .config/Code/User/settings.json
fi

# Zsh
_link_file .zprofile .zprofile
_link_file .zshrc .zshrc
_link_dir shell .config/shell
_link_file .p10k.zsh .p10k.zsh

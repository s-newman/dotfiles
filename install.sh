#!/usr/bin/env bash
# Deploys the configuration files by creating soft links

# Figure out where our configs are located
# NOTE: this requires that this (install.sh) script is NOT a link!
CONFIGDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Ensure ~/.config exists
mkdir -p ${HOME}/.config

# Ensure ~/.cargo exists
mkdir -p ${HOME}/.cargo

# Alacritty
ln -fsn ${CONFIGDIR}/alacritty ${HOME}/.config/alacritty

# Cargo
ln -fs ${CONFIGDIR}/cargo/config.toml ${HOME}/.cargo/config.toml

# Electron
if [ "$(uname)" = "Linux" ]; then
  ln -fs ${CONFIGDIR}/electron-flags.conf ${HOME}/.config/electron-flags.conf
fi

# Flake8
ln -fs ${CONFIGDIR}/.flake8 ${HOME}/.config/flake8

# GNU Readline
ln -fs ${CONFIGDIR}/.inputrc ${HOME}/.inputrc

# GTK 3.0/4.0
mkdir -p "${HOME}/.config/gtk-3.0"
ln -sf "${CONFIGDIR}/gtk-settings.ini" "${HOME}/.config/gtk-3.0/settings.ini"
mkdir -p "${HOME}/.config/gtk-4.0"
ln -sf "${CONFIGDIR}/gtk-settings.ini" "${HOME}/.config/gtk-4.0/settings.ini"

# Kitty
ln -fsn "${CONFIGDIR}/kitty" "${HOME}/.config/kitty"

# Pacman
ln -fsn ${CONFIGDIR}/pacman ${HOME}/.config/pacman

# Radare2
ln -fsn ${CONFIGDIR}/.radare2rc ${HOME}/.radare2rc

# Systemd User Env Vars
if [ "$(uname)" = "Linux" ]; then
  ln -fsn ${CONFIGDIR}/environment.d ${HOME}/.config/environment.d
fi

# Tmux
ln -fs ${CONFIGDIR}/.tmux.conf ${HOME}/.tmux.conf

# Vim
ln -fsn ${CONFIGDIR}/.vim ${HOME}/.vim

# VS Code
if [ "$(uname)" = "Darwin" ]; then
  mkdir -p "${HOME}/Library/Application Support/Code/User"
  ln -fs "${CONFIGDIR}/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"
else
  mkdir -p "${HOME}/.config/Code/User"
  ln -fs "${CONFIGDIR}/settings.json" "${HOME}/.config/Code/User/settings.json"
fi

# Zsh
ln -fs ${CONFIGDIR}/.zprofile ${HOME}/.zprofile
ln -fs ${CONFIGDIR}/.zshrc ${HOME}/.zshrc
ln -fsn ${CONFIGDIR}/shell ${HOME}/.config/shell
ln -fs ${CONFIGDIR}/.p10k.zsh ${HOME}/.p10k.zsh

if [ "$1" = "all" ]
then
	# Thinkfan
	sudo ln -fs ${CONFIGDIR}/thinkfan.conf /etc/thinkfan.conf
fi

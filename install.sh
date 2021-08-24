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

# Flake8
ln -fs ${CONFIGDIR}/.flake8 ${HOME}/.config/flake8

# GNU Readline
ln -fs ${CONFIGDIR}/.inputrc ${HOME}/.inputrc

# Pacman
ln -fsn ${CONFIGDIR}/pacman ${HOME}/.config/pacman

# Radare2
ln -fsn ${CONFIGDIR}/.radare2rc ${HOME}/.radare2rc

# Tmux
ln -fs ${CONFIGDIR}/.tmux.conf ${HOME}/.tmux.conf

# Vim
ln -fsn ${CONFIGDIR}/.vim ${HOME}/.vim

# Zsh
ln -fs ${CONFIGDIR}/.zshenv ${HOME}/.zshenv
ln -fs ${CONFIGDIR}/.zprofile ${HOME}/.zprofile
ln -fs ${CONFIGDIR}/.zshrc ${HOME}/.zshrc
ln -fsn ${CONFIGDIR}/shell ${HOME}/.config/shell

if [ "$1" = "all" ]
then
	# Thinkfan
	sudo ln -fs ${CONFIGDIR}/thinkfan.conf /etc/thinkfan.conf
fi

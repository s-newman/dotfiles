#!/usr/bin/env bash
# Deploys the configuration files by creating soft links

# Figure out where our configs are located
# NOTE: this requires that this (install.sh) script is NOT a link!
CONFIGDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Ensure ~/.config exists
mkdir -p ${HOME}/.config

# Alacritty
ln -fsn ${CONFIGDIR}/alacritty ${HOME}/.config/alacritty

# Bash
ln -fs ${CONFIGDIR}/.bash_aliases ${HOME}/.bash_aliases
ln -fs ${CONFIGDIR}/.bash_profile ${HOME}/.bash_profile
ln -fs ${CONFIGDIR}/.bashrc ${HOME}/.bashrc

# Environment variables
ln -fs ${CONFIGDIR}/environment.d ${HOME}/.config/environment.d

# Flake8
ln -fs ${CONFIGDIR}/.flake8 ${HOME}/.config/flake8

# Git
ln -fs ${CONFIGDIR}/.gitconfig ${HOME}/.gitconfig

# GNU Readline
ln -fs ${CONFIGDIR}/.inputrc ${HOME}/.inputrc

# GTK 3
ln -fsn ${CONFIGDIR}/gtk-3.0 ${HOME}/.config/gtk-3.0

# Pacman
ln -fsn ${CONFIGDIR}/pacman ${HOME}/.config/pacman

# Radare2
ln -fsn ${CONFIGDIR}/.radare2rc ${HOME}/.radare2rc

# Rofi
ln -fsn ${CONFIGDIR}/rofi ${HOME}/.config/rofi

# Sway
ln -fsn ${CONFIGDIR}/sway ${HOME}/.config/sway

# Tmux
ln -fs ${CONFIGDIR}/.tmux-theme ${HOME}/.tmux-theme
ln -fs ${CONFIGDIR}/.tmux.conf ${HOME}/.tmux.conf

# Vim
ln -fs ${CONFIGDIR}/.vimrc ${HOME}/.vimrc
ln -fsn ${CONFIGDIR}/.vim ${HOME}/.vim

# VSCode
ln -fs ${CONFIGDIR}/settings.json ${HOME}/.config/Code/User/settings.json

# Waybar
ln -fsn ${CONFIGDIR}/waybar ${HOME}/.config/waybar

# XDG
ln -fs ${CONFIGDIR}/user-dirs.dirs ${HOME}/.config/user-dirs.dirs

if [ "$1" = "all" ]
then
	# Thinkfan
	sudo ln -fs ${CONFIGDIR}/thinkfan.conf /etc/thinkfan.conf
fi

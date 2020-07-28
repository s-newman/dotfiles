#!/usr/bin/env bash
# Deploys the configuration files by creating soft links

# Figure out where our configs are located
# NOTE: this requires that this (install.sh) script is NOT a link!
CONFIGDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Bash
ln -fs ${CONFIGDIR}/.bash_aliases ${HOME}/.bash_aliases
ln -fs ${CONFIGDIR}/.bash_profile ${HOME}/.bash_profile
ln -fs ${CONFIGDIR}/.bashrc ${HOME}/.bashrc

# GNU Readline
ln -fs ${CONFIGDIR}/.inputrc ${HOME}/.inputrc

# Tmux
ln -fs ${CONFIGDIR}/.tmux-theme ${HOME}/.tmux-theme
ln -fs ${CONFIGDIR}/.tmux.conf ${HOME}/.tmux.conf

# Vim
ln -fs ${CONFIGDIR}/.vimrc ${HOME}/.vimrc
ln -fsn ${CONFIGDIR}/.vim ${HOME}/.vim

if [ "$1" = "all" ]
then
	# Thinkfan
	sudo ln -fs ${CONFIGDIR}/thinkfan.conf /etc/thinkfan.conf
fi
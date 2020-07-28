#!/usr/bin/env bash
# Deploys the configuration files by creating soft links

# Figure out where our configs are located
# NOTE: this requires that this (deploy.sh) script is NOT a link!
CONFIGDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Files to deploy
configs=(
	".bash_aliases"
        ".bash_profile"
	".bashrc"
	".inputrc"
        ".ledgerrc"
	".tmux.conf"
	".tmux-theme"
	".vimrc"
	".vim"
)

# Backup and link the files
for config in ${configs[*]}; do
	ln -fs ${CONFIGDIR}/${config} ${HOME}/${config}
done

# Install vim plugins
echo -ne '\n' | vim +PlugInstall +qall

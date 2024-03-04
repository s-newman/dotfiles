#!/bin/zsh
# shellcheck disable=SC1071
# Shellcheck doesn't support ZSH :(

set -o errexit
set -o nounset
set -o pipefail
set -x

# General packages
brew upgrade

# Python tools
pipx upgrade-all

# Rust tools
rustup update
cargo install-update --all

# Shell integrations
set +o errexit
set +o nounset
set +o pipefail
set +x
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"
echo "Running \"zinit self-update\"..."
zinit self-update
echo "Running \"zinit update --all\"..."
zinit update --all
set -o errexit
set -o nounset
set -o pipefail
set -x

# LaTeX packages
sudo tlmgr update --self
sudo tlmgr update --all

# Maintenance
brew autoremove
brew cleanup
brew bundle dump --global --force
cargo install-update --list > "${HOME}/.config/packages/cargo.txt"
pipx list > "${HOME}/.config/packages/pipx.txt"
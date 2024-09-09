#!/bin/zsh
# shellcheck disable=SC1071
# Shellcheck doesn't support ZSH :(

set -o errexit
set -o nounset
set -o pipefail

# General packages
brew upgrade

# Python tools
pipx upgrade-all

# Rust tools
rustup update
cargo install-update --all

# Shell integrations
for plugin_dir in "${PLUGINS_DIR}"/*; do
  echo "Updating plugins/$(basename ${plugin_dir}) ..."
  pushd "${plugin_dir}"
  git pull
  popd
done

# Maintenance
brew autoremove
brew cleanup
brew bundle dump --global --force
cargo install-update --list > "${HOME}/.config/packages/cargo.txt"
pipx list > "${HOME}/.config/packages/pipx.txt"
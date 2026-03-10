#!/bin/zsh
# shellcheck disable=SC1071
# Shellcheck doesn't support ZSH :(

set -o errexit
set -o nounset
set -o pipefail

YELLOW="\033[33m"
NC="\033[0m"

# Quiet version of whence to look for commands in PATH
in-path() {
  whence $1 >/dev/null
}

# Create packages folder if it doesn't exist
#
# This used to go within the dotfiles folder, but I grew tired of constantly
# committing it. Since we won't have git history anymore, creating a separate
# folder for each day so we can track packages over time.
pkg_list_dir="${HOME}/packages/$(date '+%Y-%m-%d')"
if [ ! -d "${pkg_list_dir}" ]; then
  mkdir -p "${pkg_list_dir}"
fi

# General packages
in-path brew && brew upgrade
in-path apt && sudo apt update && sudo apt upgrade -y

# Shell integrations
for plugin_dir in "${PLUGINS_DIR}"/*; do
  echo "Updating plugins/$(basename ${plugin_dir}) ..."
  pushd "${plugin_dir}"
  git pull
  popd
done

# Rustup and Cargo-installed tools
in-path rustup && rustup update
if in-path cargo; then
  cargo install-update --all
  cargo install-update --list > "${pkg_list_dir}/cargo.txt"
fi

# Maintenance
if in-path brew; then
  brew autoremove
  brew cleanup
  brew bundle dump --force --file "${pkg_list_dir}/Brewfile"
fi

if in-path apt; then
  # Grab list of base-installed packages from file
  pkg_dir=$(dirname "${pkg_list_dir}")
  if [ ! -f "${pkg_dir}/base-apt-packages.txt" ]; then
    # Try to grab list from installer
    # Ref: https://askubuntu.com/a/492343
    if [ -f /var/log/installer/initial-status.gz ]; then
      gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u> "${pkg_dir}/base-apt-packages.txt"
    else
      # Fall back to just displaying the current list of installed packages
      # (will need manual adjustment to be accurate)
      apt-mark showmanual | sort -u > "${pkg_dir}/base-apt-packages.txt"
    fi
  fi

  comm -23 <(apt-mark showmanual | sort -u) "${pkg_dir}/base-apt-packages.txt" > "${pkg_list_dir}/apt.txt"
fi

# Check for dotfiles update
cd "${HOME}/src/dotfiles"
git fetch
if [ ! -z "$(git status -s -- '!settings.json')" ]; then
  echo -e "${YELLOW}You have dotfiles changes to commit${NC}"
fi
if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
  echo -e "${YELLOW}There are dotfiles updates to pull${NC}"
fi
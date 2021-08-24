# Load the actual config
if [ -f "${HOME}/.config/shell/custom.zsh" ]
then
  source "${HOME}/.config/shell/custom.zsh"
else
  echo "Could not find custom zsh config at ${HOME}/.config/shell/custom.zsh"
fi
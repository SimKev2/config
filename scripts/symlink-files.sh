#! /bin/bash
mkdir -p ~/.config

ln -sf ~/config/shell/base16-shell/scripts/base16-default-dark.sh ~/.base16_theme
ln -sf ~/config/bash_profiles/.bash_profile ~/.bash_profile
ln -sf ~/config/.tmux.conf ~/.tmux.conf

if [[ ! -d ~/.config/nvim ]]
then
    ln -sfF ~/config/nvim ~/.config/nvim
fi

mkdir -p ~/.config/alacritty
case "$OSTYPE" in
  darwin*) ALACRITTY_SUFFIX="" ;;
  linux*) ALACRITTY_SUFFIX="-linux" ;;
  *) echo "Unknown os : $OSTYPE" ;;
esac
cat >~/.config/alacritty/alacritty.yml <<EOL
import:
  - ~/config/alacritty-overrides$ALACRITTY_SUFFIX.yaml
EOL

#! /bin/bash
defaults write -g AppleFontSmoothing -int 0

UNAME_MACHINE=$(/usr/bin/uname -m)
if [[ "$UNAME_MACHINE" == "arm64" ]]
then
    HOMEBREW_PREFIX="/opt/homebrew"
else
    HOMEBREW_PREFIX="/usr/local"
fi

if [[ ! -f $HOMEBREW_PREFIX/bin/brew ]]
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

$HOMEBREW_PREFIX/bin/brew install gnupg
$HOMEBREW_PREFIX/bin/brew install neovim
$HOMEBREW_PREFIX/bin/brew install kubectl
$HOMEBREW_PREFIX/bin/brew install aws-iam-authenticator
$HOMEBREW_PREFIX/bin/brew install jq
$HOMEBREW_PREFIX/bin/brew install yq
$HOMEBREW_PREFIX/bin/brew install go
$HOMEBREW_PREFIX/bin/brew install helm
$HOMEBREW_PREFIX/bin/brew install pyenv
$HOMEBREW_PREFIX/bin/brew install --cask gitify
$HOMEBREW_PREFIX/bin/brew install ripgrep
$HOMEBREW_PREFIX/bin/brew install tfenv
$HOMEBREW_PREFIX/bin/brew install fzf
$HOMEBREW_PREFIX/bin/brew install tmux
# Python build dependencies for pyenv installations of python
$HOMEBREW_PREFIX/bin/brew install openssl readline sqlite3 xz zlib

$HOMEBREW_PREFIX/bin/brew tap hashicorp/tap
$HOMEBREW_PREFIX/bin/brew install hashicorp/tap/vault


# Install rustlang
if [[ ! -f "$HOME/.cargo/bin/rustup" ]]
then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Install latest python3 and make default
LATEST_PYTHON=$($HOMEBREW_PREFIX/bin/pyenv install --list | grep -E "^\s*[0-9]+\.[0-9]+\.[0-9]+$" | tail -n 1 | xargs) # xargs trims whitespace
echo "Latest python version install : $LATEST_PYTHON"
if [[ ! -d "$HOME/.pyenv/versions/$LATEST_PYTHON" ]]
then
    $HOMEBREW_PREFIX/bin/pyenv install $LATEST_PYTHON
    $HOMEBREW_PREFIX/bin/pyenv global $LATEST_PYTHON
fi
$HOME/.pyenv/shims/pip install -U pip

# Set up neovim virtualenv
$HOME/.pyenv/shims/pip install virtualenv
mkdir -p ~/envs
if [[ ! -d "$HOME/envs/py3neovim" ]]
then
    $HOME/.pyenv/shims/virtualenv --python=$HOME/.pyenv/shims/python3 ~/envs/py3neovim
    $HOME/envs/py3neovim/bin/pip install neovim
    $HOME/envs/py3neovim/bin/pip install python-language-server
    $HOME/envs/py3neovim/bin/pip install black
fi

# Set up python lsp server for neovim
if [[ ! -f $HOME/envs/py3neovim/bin/pylsp ]]
then
    $HOME/envs/py3neovim/bin/pip install "python-lsp-server[all]"
    $HOME/envs/py3neovim/bin/pip install "python-lsp-black"
    sudo ln -sf $HOME/envs/py3neovim/bin/pylsp /usr/local/bin/
fi

# Set up golang lsp server for neovim
if [[ ! -f $HOME/go/bin/gopls ]]
then
    $HOMEBREW_PREFIX/bin/go install golang.org/x/tools/gopls@latest
fi

# Install minikube
if [[ ! -f /usr/local/bin/minikube ]]
then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-arm64
    sudo install minikube-darwin-arm64 /usr/local/bin/minikube
    rm minikube-darwin-arm64
fi

# Set up base16 color scheme
if [[ ! -f ~/.vimrc_background ]]
then
    source "$HOME/config/shell/base16-shell/profile_helper.sh"
    source "$HOME/config/shell/base16-shell/scripts/base16-default-dark.sh"
fi

if [[ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim ]]
then
    git clone --depth=1 https://github.com/savq/paq-nvim.git \
        "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
fi

echo
echo "NOTES :"
echo "  Set up GPG key : https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key"
echo "  Run \"vim ~/.vim/plugged/LanguageClient-neovim/rust-toolchain\" and edit to 1.57.0 before starting nvim"
echo "  Install nerd font https://www.nerdfonts.com/font-downloads \"DejaVu Sans Mono Nerd Font Complete\" file from zip"

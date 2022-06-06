#! /bin/bash
which brew
BREW_STATUS=$?
if [[ $BREW_STATUS -eq 1 ]]
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

UNAME_MACHINE=$(/usr/bin/uname -m)
if [[ "$UNAME_MACHINE" == "arm64" ]]
then
    HOMEBREW_PREFIX="/opt/homebrew"
else
    HOMEBREW_PREFIX="/usr/local"
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
LATEST_PYTHON=$(pyenv install --list | grep -E "^\s*[0-9]+\.[0-9]+\.[0-9]+$" | tail -n 1 | xargs) # xargs trims whitespace
echo "Latest python version install : $LATEST_PYTHON"
if [[ ! -d "$HOME/.pyenv/versions/$LATEST_PYTHON" ]]
then
    pyenv install $LATEST_PYTHON
    pyenv global $LATEST_PYTHON
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
    eval "$("$BASE16_SHELL/profile_helper.sh")"
    base16_default-dark
fi

echo
echo "NOTES :"
echo "  Set up GPG key : https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key"
echo "  Run \"vim ~/.vim/plugged/LanguageClient-neovim/rust-toolchain\" and edit to 1.57.0 before starting nvim"

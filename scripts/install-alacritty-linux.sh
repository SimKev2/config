#!/bin/bash
# Install required tools
# apt install -y cmake libfreetype6-dev libfontconfig1-dev xclip libxcb-shape0-dev libxcb-render0-dev

# Download, compile and install Alacritty
# git clone https://github.com/jwilm/alacritty ~/.local/programs/
cd ~/.local/programs/alacritty
# cargo build --release

# Add Man-Page entries
sudo mkdir -p /usr/local/share/man/man1
gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null

# Copy default config into home dir
mkdir -p ~/.config/alacritty
touch ~/.config/alacritty/alacritty.yml
cat <<EOF > ~/.config/alacritty/alacritty.yml
import:
  - ~/config/alacritty-overrides-linux.yaml
EOF

# Create desktop file
mkdir -p ~/.local/share/applications/
cp extra/linux/Alacritty.desktop ~/.local/share/applications/

# Copy binary to path
# sudo cp target/release/alacritty ~/.local/bin/alacritty

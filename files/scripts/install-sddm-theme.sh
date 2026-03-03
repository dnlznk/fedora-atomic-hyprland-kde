#!/usr/bin/env bash
set -oue pipefail

# Install SDDM astronaut theme dependencies
dnf install -y \
    qt6-qtsvg \
    qt6-qtvirtualkeyboard \
    qt6-qtmultimedia

sudo mkdir -p /usr/local/share/sddm/themes

# Clone the theme into the system SDDM themes directory
git clone -b master --depth 1 \
    https://github.com/Keyitdev/sddm-astronaut-theme.git \
    /usr/local/share/sddm/themes/sddm-astronaut-theme

# Select pixel_sakura variant
sed -i 's|^ConfigFile=.*|ConfigFile=Themes/pixel_sakura.conf|' \
    /usr/local/share/sddm/themes/sddm-astronaut-theme/metadata.desktop

# Cop and instally fonts
sudo cp -r /usr/local/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
sudo fc-cache -f

# Point SDDM at the theme — overwrites wayblue's default maldives config
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/theme.conf << 'EOF'
[Theme]
ThemeDir=/usr/local/share/sddm/themes
Current=sddm-astronaut-theme
EOF

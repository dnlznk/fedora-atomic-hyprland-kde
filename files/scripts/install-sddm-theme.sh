#!/usr/bin/env bash
set -oue pipefail

# 1. Install dependencies
dnf install -y \
    qt6-qtsvg \
    qt6-qtvirtualkeyboard \
    qt6-qtmultimedia

# 2. Define the paths
WRITABLE_PATH="/usr/local/share/sddm/themes/sddm-astronaut-theme"
SYSTEM_PATH="/usr/share/sddm/themes/sddm-astronaut-theme"

# 3. Create the writable directory and clone
mkdir -p "/usr/local/share/sddm/themes"
if [ ! -d "$WRITABLE_PATH" ]; then
    git clone -b master --depth 1 \
        https://github.com/Keyitdev/sddm-astronaut-theme.git \
        "$WRITABLE_PATH"
fi

# 4. Select pixel_sakura variant in the WRITABLE path
sed -i 's|^ConfigFile=.*|ConfigFile=Themes/pixel_sakura.conf|' \
    "$WRITABLE_PATH/metadata.desktop"

# 5. THE TRICK: Create the symlink
# We link the standard path to our writable path
mkdir -p /usr/share/sddm/themes
ln -s "$WRITABLE_PATH" "$SYSTEM_PATH"

# 6. Fonts (Keep these in /usr/share for reliability)
mkdir -p /usr/share/fonts/sddm-astronaut
cp -r "$WRITABLE_PATH/Fonts/"* /usr/share/fonts/sddm-astronaut/

# 7. Standard Config (No ThemeDir needed now!)
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/theme.conf << 'EOF'
[Theme]
Current=sddm-astronaut-theme
EOF

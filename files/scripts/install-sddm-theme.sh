#!/usr/bin/env bash
set -oue pipefail

# 1. Install dependencies
dnf install -y \
    qt6-qtsvg \
    qt6-qtvirtualkeyboard \
    qt6-qtmultimedia \
    git

# 2. Set the writable paths
THEME_DIR="/usr/local/share/sddm/themes/sddm-astronaut-theme"
FONT_DIR="/usr/local/share/fonts/sddm-astronaut"

mkdir -p "/usr/local/share/sddm/themes"
mkdir -p "$FONT_DIR"

# 3. Clone the theme
if [ ! -d "$THEME_DIR" ]; then
    git clone -b master --depth 1 \
        https://github.com/Keyitdev/sddm-astronaut-theme.git \
        "$THEME_DIR"
fi

# 4. Select pixel_sakura variant
sed -i 's|^ConfigFile=.*|ConfigFile=Themes/pixel_sakura.conf|' \
    "$THEME_DIR/metadata.desktop"

# 5. Copy Fonts (Putting them in /usr/local/share/fonts keeps them editable too)
cp -r "$THEME_DIR/Fonts/"* "$FONT_DIR/"

# 6. Tell SDDM to look in /usr/local/ (VERY IMPORTANT)
# By default, SDDM only looks in /usr/share/sddm/themes
mkdir -p /usr/lib/sddm.conf.d
cat > /usr/lib/sddm.conf.d/theme.conf << 'EOF'
[Theme]
ThemeDir=/usr/local/share/sddm/themes
Current=sddm-astronaut-theme
EOF

# Note: No 'dnf clean' or 'rm' here to avoid the BlueBuild cache mount error!

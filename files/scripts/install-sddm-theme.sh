#!/usr/bin/env bash
set -oue pipefail

# 1. Install dependencies (including git for the clone)
# Use dnf/dnf5 depending on your base image; ublue usually has dnf
dnf install -y \
    qt6-qtsvg \
    qt6-qtvirtualkeyboard \
    qt6-qtmultimedia \
    git

# 2. Define standard paths (Using /usr/share for the image build)
THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"
FONT_DIR="/usr/share/fonts/sddm-astronaut"

mkdir -p "/usr/share/sddm/themes"
mkdir -p "$FONT_DIR"

# 3. Clone the theme
# Check if it exists first to avoid build errors on retries
if [ ! -d "$THEME_DIR" ]; then
    git clone -b master --depth 1 \
        https://github.com/Keyitdev/sddm-astronaut-theme.git \
        "$THEME_DIR"
fi

# 4. Select pixel_sakura variant
# Ensure we are targeting the file correctly
sed -i 's|^ConfigFile=.*|ConfigFile=Themes/pixel_sakura.conf|' \
    "$THEME_DIR/metadata.desktop"

# 5. Move Fonts to the system font path
# This makes them available system-wide in the image
cp -r "$THEME_DIR/Fonts/"* "$FONT_DIR/"

# 6. Configure SDDM
# We write to /usr/lib/sddm.conf.d/ or /etc/sddm.conf.d/
# For image builds, /usr/lib/sddm.conf.d/ is often cleaner
mkdir -p /usr/lib/sddm.conf.d
cat > /usr/lib/sddm.conf.d/theme.conf << 'EOF'
[Theme]
Current=sddm-astronaut-theme
EOF

# 7. Cleanup (Keep your image size small!)
dnf clean all
rm -rf /var/cache/dnf

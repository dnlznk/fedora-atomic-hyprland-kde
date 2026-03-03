#!/usr/bin/env bash
set -oue pipefail

# 1. Install KDE Plasma packages
# --allowerasing is key here to resolve Wayblue/KDE Qt6 version mismatches
dnf install -y --allowerasing \
    plasma-desktop \
    plasma-nm \
    plasma-pa \
    plasma-systemmonitor \
    dolphin \
    kscreen \
    powerdevil \
    kde-gtk-config \
    sddm-kcm

# 2. Final Cleanup (Crucial for Image Builds)
# 'clean all' removes cached packages and metadata
dnf clean all

# 3. Manual Cache Removal (The "100%" fix)
# Sometimes dnf/dnf5 leaves behind plugin data or empty directories
# We wipe /var/cache/dnf (or dnf5) and /var/log to keep the image pristine
rm -rf /var/cache/dnf
rm -rf /var/cache/libdnf5
rm -rf /var/log/*

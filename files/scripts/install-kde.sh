#!/usr/bin/env bash
set -oue pipefail

# Install KDE Plasma as a second session on top of the wayblue Hyprland base.
# --allowerasing is required to allow dnf to upgrade Qt6 to a consistent version
# — without it the solver refuses because wayblue's pinned Qt6 conflicts with
# the newer Qt6 that KDE's dependencies pull in.
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

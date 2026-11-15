#!/bin/sh
# MC-shell installer for Fedora (dnf).  Installs runtime dependencies, then hands
# over to install.sh for the per-user copy + wrapper.
set -eu

SRC=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

say() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }

say "installing Fedora dependencies (dnf)"
$SUDO dnf install -y --setopt=install_weak_deps=False \
    curl cava brightnessctl grim slurp wf-recorder \
    pipewire wireplumber \
    NetworkManager bluez bluez-tools \
    fontconfig tar unzip || {
        echo "warning: some packages could not be installed; continuing" >&2
    }

if ! command -v qs >/dev/null 2>&1; then
    cat <<'MSG' >&2
Quickshell (qs) was not found.

Quickshell is not packaged in Fedora yet. Build it from source once:

    sudo dnf install -y cmake ninja-build gcc-c++ qt6-qtbase-devel \
        qt6-qtdeclarative-devel qt6-qtwayland-devel wayland-devel \
        pipewire-devel libxkbcommon-devel
    git clone --recursive https://github.com/quickshell-mirror/quickshell.git
    cd quickshell && cmake -B build -G Ninja && cmake --build build
    sudo cmake --install build

Then re-run this script.
MSG
    exit 1
fi

say "installing MC-shell into ~/.config/quickshell/mc-shell"
"$SRC/install.sh" "$@"
say "done — start it with: mc-shell"

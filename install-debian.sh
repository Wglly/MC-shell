#!/bin/sh
# MC-shell installer for Debian / Ubuntu (apt).  Installs runtime dependencies,
# then hands over to install.sh for the per-user copy + wrapper.
set -eu

SRC=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

say() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }

say "updating apt indexes"
$SUDO apt-get update -y

say "installing Debian/Ubuntu dependencies (apt)"
$SUDO apt-get install -y --no-install-recommends \
    curl cava brightnessctl grim slurp wf-recorder \
    pipewire wireplumber \
    network-manager bluez bluez-tools \
    fontconfig tar unzip || {
        echo "warning: some packages could not be installed; continuing" >&2
    }

if ! command -v qs >/dev/null 2>&1; then
    cat <<'MSG' >&2
Quickshell (qs) was not found.

Debian/Ubuntu do not ship Quickshell yet. Build it from source once:

    sudo apt-get install -y build-essential cmake ninja-build \
        qt6-base-dev qt6-declarative-dev qt6-wayland-dev \
        libwayland-dev libpipewire-0.3-dev libxkbcommon-dev
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

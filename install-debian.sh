#!/bin/sh
# MC-shell one-click installer for Debian / Ubuntu.
# Installs runtime + build dependencies, builds Quickshell into ~/.local when the
# distro does not ship it, then installs MC-shell itself.
set -eu

SRC=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"
PREFIX="${HOME}/.local"
BUILD_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/mc-shell-quickshell"

say() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }

ensure_path() {
    case ":$PATH:" in
        *":$PREFIX/bin:"*) ;;
        *) export PATH="$PREFIX/bin:$PATH" ;;
    esac
    for rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
        [ -f "$rc" ] || continue
        grep -q 'mc-shell: local bin' "$rc" 2>/dev/null && continue
        printf '\n# mc-shell: local bin\ncase ":$PATH:" in *":%s/bin:"*) ;; *) export PATH="%s/bin:$PATH" ;; esac\n' \
            "$PREFIX" "$PREFIX" >> "$rc"
    done
}

build_quickshell() {
    say "building Quickshell (this takes a few minutes)"
    $SUDO apt-get install -y --no-install-recommends \
        git build-essential cmake ninja-build pkg-config \
        qt6-base-dev qt6-base-private-dev qt6-declarative-dev \
        qt6-declarative-private-dev qt6-wayland-dev qt6-wayland-private-dev \
        libwayland-dev wayland-protocols libxkbcommon-dev \
        libpipewire-0.3-dev libdrm-dev libgbm-dev libjemalloc-dev || \
        warn "some build dependencies may be missing"

    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    git clone --recurse-submodules --depth=1 \
        https://github.com/quickshell-mirror/quickshell.git "$BUILD_DIR/src"
    cmake -S "$BUILD_DIR/src" -B "$BUILD_DIR/build" -G Ninja \
        -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$PREFIX"
    cmake --build "$BUILD_DIR/build"
    cmake --install "$BUILD_DIR/build"
}

say "installing Debian/Ubuntu dependencies"
$SUDO apt-get update -y
$SUDO apt-get install -y --no-install-recommends \
    curl git cava brightnessctl grim slurp wf-recorder \
    pipewire wireplumber \
    network-manager bluez bluez-tools \
    fontconfig tar unzip || warn "some runtime packages could not be installed"

if ! command -v qs >/dev/null 2>&1; then
    if $SUDO apt-get install -y quickshell 2>/dev/null && command -v qs >/dev/null 2>&1; then
        say "installed Quickshell from the distribution repositories"
    else
        build_quickshell
    fi
fi

ensure_path
command -v qs >/dev/null 2>&1 || { warn "Quickshell build failed; see the output above"; exit 1; }

say "installing MC-shell"
"$SRC/install.sh" "$@"
say "done — start it with: mc-shell"

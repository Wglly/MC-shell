import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import QtQuick
import qs.modules.common
import qs.modules.bar
import qs.modules.launcher
import qs.modules.control
import qs.modules.osd
import qs.modules.notifications
import qs.services

// MC-shell — a Minecraft-styled desktop shell for Hyprland and niri.
ShellRoot {
    id: shell

    // Minecraft's font is bundled so the shell looks the same everywhere.
    FontLoader {
        id: mcFont
        source: Qt.resolvedUrl("assets/fonts/Monocraft.ttf")
        onStatusChanged: {
            if (status === FontLoader.Ready)
                Theme.fontFamily = name;
        }
    }

    // Pipewire nodes only expose live volume/mute while they are tracked.
    PwObjectTracker {
        objects: Pipewire.nodes.values
    }

    // A bar on every monitor.
    Variants {
        model: Quickshell.screens
        delegate: Bar {
            screen: modelData
        }
    }

    Launcher {
        screen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null
    }

    ControlCenter {
        screen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null
    }

    Osd {
        screen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null
    }

    Toasts {
        screen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null
    }

    // Keybindings from Hyprland/niri call into these:
    //   qs ipc -c mc-shell call shell launcher
    //   qs ipc -c mc-shell call shell control
    //   qs ipc -c mc-shell call shell close
    IpcHandler {
        target: "shell"

        function launcher(): void {
            ShellState.toggleOverlay("launcher");
        }
        function control(): void {
            ShellState.toggleOverlay("control");
        }
        function close(): void {
            ShellState.closeOverlay();
        }
        function workspaces(): string {
            return JSON.stringify(Compositor.workspaces);
        }
        function backend(): string {
            return Compositor.backend;
        }
        function focus(workspaceId: int): void {
            Compositor.focusWorkspace(workspaceId);
        }
        function stepWorkspace(delta: int): void {
            Compositor.step(delta);
        }

        // Media/OSD helpers so compositor keybindings can drive the shell.
        function volumeUp(): void {
            Audio.step(1);
        }
        function volumeDown(): void {
            Audio.step(-1);
        }
        function volumeMute(): void {
            Audio.toggleMute();
        }
        function brightnessUp(): void {
            System.setBrightness(System.brightness + 0.05);
            ShellState.flashOsd("brightness", System.brightness, "BRIGHTNESS");
        }
        function brightnessDown(): void {
            System.setBrightness(System.brightness - 0.05);
            ShellState.flashOsd("brightness", System.brightness, "BRIGHTNESS");
        }
    }
}

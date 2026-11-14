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
import qs.modules.dock
import qs.modules.sidebars
import qs.modules.widgets
import qs.modules.settings
import qs.modules.overview
import qs.modules.dashboard
import qs.modules.power
import qs.modules.wallpaper
import qs.services

// MC-shell — a Minecraft-styled desktop shell for Hyprland and niri.
ShellRoot {
    id: shell

    readonly property var primaryScreen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null

    // Minecraft's font is bundled so the shell looks the same everywhere.
    FontLoader {
        id: mcFont
        source: Qt.resolvedUrl("assets/fonts/Monocraft.ttf")
        onStatusChanged: {
            if (status === FontLoader.Ready)
                Theme.fontFamily = name;
        }
    }

    // Theme colours come from Settings but live in the common module, so we
    // push them across instead of making common import services.
    Binding {
        target: Theme
        property: "grass"
        value: Settings.get("theme.accent", "#5fbf4f")
    }
    Binding {
        target: Theme
        property: "outline"
        value: Settings.get("theme.outline", "#1a1a1a")
    }
    Binding {
        target: Theme
        property: "bevelLight"
        value: Settings.get("theme.bevelLight", "#ffffff")
    }
    Binding {
        target: Theme
        property: "bevelDark"
        value: Settings.get("theme.bevelDark", "#4a4a4a")
    }
    Binding {
        target: Theme
        property: "panel"
        value: Settings.get("theme.panel", "#c6c6c6")
    }
    Binding {
        target: Theme
        property: "barBg"
        value: Settings.get("theme.barBg", "#17140f")
    }
    Binding {
        target: Theme
        property: "cardBg"
        value: Settings.get("theme.cardBg", "#1c1712")
    }
    Binding {
        target: Theme
        property: "dockBg"
        value: Settings.get("theme.dockBg", "#6b4a24")
    }
    Binding {
        target: Theme
        property: "text"
        value: Settings.get("theme.text", "#f4f4f4")
    }
    Binding {
        target: Theme
        property: "textDim"
        value: Settings.get("theme.textDim", "#b9b9b9")
    }
    Binding {
        target: Theme
        property: "textOnPanel"
        value: Settings.get("theme.textOnPanel", "#3f3f3f")
    }
    Binding {
        target: Theme
        property: "textShadow"
        value: Settings.get("theme.textShadow", "#3a3a3a")
    }
    Binding {
        target: Theme
        property: "textHints"
        value: Settings.get("theme.textHints", "#6a6a6a")
    }
    Binding {
        target: Theme
        property: "panelDark"
        value: Settings.get("theme.panelDark", "#8b8b8b")
    }
    Binding {
        target: Theme
        property: "panelTextShadow"
        value: Settings.get("theme.panelTextShadow", "#ffffff")
    }
    Binding {
        target: Theme
        property: "panelTexture"
        value: Settings.get("theme.panelTexture", "dirt")
    }

    Binding {
        target: Theme
        property: "gold"
        value: Settings.get("theme.gold", "#ffcc4d")
    }

    // Weather location follows the settings field.
    Binding {
        target: Weather
        property: "city"
        value: Settings.get("widgets.weather.city", "")
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

    // Wallpaper + desktop widgets + layered chrome (primary monitor).
    Wallpaper {
        targetScreen: shell.primaryScreen
    }
    ClockWidget { targetScreen: shell.primaryScreen }
    WeatherWidget { targetScreen: shell.primaryScreen }
    VisualizerWidget { targetScreen: shell.primaryScreen }
    CalendarWidget { targetScreen: shell.primaryScreen }
    StatsWidget { targetScreen: shell.primaryScreen }
    MediaWidget { targetScreen: shell.primaryScreen }
    UserWidget { targetScreen: shell.primaryScreen }

    Dock {
        targetScreen: shell.primaryScreen
    }

    Sidebar {
        side: "left"
        targetScreen: shell.primaryScreen
    }
    Sidebar {
        side: "right"
        targetScreen: shell.primaryScreen
    }

    Launcher {
        screen: shell.primaryScreen
    }

    ControlCenter {
        screen: shell.primaryScreen
    }

    SettingsWindow { }

    Overview { }

    Dashboard { }

    PowerMenu { }

    Osd {
        screen: shell.primaryScreen
    }

    Toasts {
        screen: shell.primaryScreen
    }

    // Keybindings from Hyprland/niri call into these:
    //   mc-shell ipc call shell launcher
    //   mc-shell ipc call shell settings
    //   mc-shell ipc call shell power
    IpcHandler {
        target: "shell"

        function launcher(): void {
            ShellState.toggleOverlay("launcher");
        }
        function control(): void {
            ShellState.toggleOverlay("control");
        }
        function settings(): void {
            ShellState.toggleOverlay("settings");
        }
        function power(): void {
            ShellState.toggleOverlay("power");
        }
        function overview(): void {
            ShellState.toggleOverlay("overview");
        }
        function dashboard(): void {
            ShellState.toggleOverlay("dashboard");
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
        function moveWindow(windowId: string, workspaceId: int): void {
            Compositor.moveWindow(windowId, workspaceId);
        }
        function windows(): string {
            return JSON.stringify(Compositor.windows);
        }
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
            ShellState.flashOsd("brightness", System.brightness, I18n.t("osd.brightness"));
        }
        function brightnessDown(): void {
            System.setBrightness(System.brightness - 0.05);
            ShellState.flashOsd("brightness", System.brightness, I18n.t("osd.brightness"));
        }
        function reload(): void {
            Settings.save();
        }
        // mc-shell ipc call shell set bar.position left
        function set(key: string, value: string): void {
            var v = value;
            if (value === "true")
                v = true;
            else if (value === "false")
                v = false;
            else if (value !== "" && !isNaN(Number(value)))
                v = Number(value);
            else if (value.charAt(0) === "[" || value.charAt(0) === "{") {
                try { v = JSON.parse(value); } catch (e) { }
            }
            Settings.set(key, v);
        }
        function language(code: string): void {
            Settings.set("language", code);
        }
        function preset(name: string): void {
            Settings.applyPreset(name);
        }
        // mc-shell ipc call shell settingsTab 2
        function settingsTab(index: int): void {
            ShellState.settingsTab = index;
        }
    }
}

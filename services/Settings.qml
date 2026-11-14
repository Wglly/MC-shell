pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Settings.qml — persistent configuration for MC-shell.
//
// Everything lives in ~/.config/mc-shell/config.json.  Components bind to
// Settings.data.<group>.<key>; Settings.set("group.key", value) writes and
// schedules a debounced save.
QtObject {
    id: root

    readonly property string configDir: (Quickshell.env("XDG_CONFIG_HOME") || (Quickshell.env("HOME") + "/.config")) + "/mc-shell"
    property string path: ""
    property var data: root.defaults()
    property bool loaded: false
    property bool dirty: false

    function defaults() {
        return {
            version: 2,
            language: "auto",
            bar: {
                position: "top",      // top | bottom | left | right
                visible: true,
                showStats: true,
                showTray: true,
                showTitle: true,
                showClock: true,
                thickness: 40
            },
            dock: {
                position: "bottom",   // bottom | top | left | right
                visible: true,
                autoHide: false,
                iconSize: 42,
                showMedia: true,      // mini player + dashboard button row
                columns: 9,           // free grid: 1..12
                rows: 3,              // free grid: 1..6
                pinned: ["firefox.desktop", "org.gnome.Nautilus.desktop", "kitty.desktop",
                         "org.gnome.Console.desktop", "org.gnome.TextEditor.desktop",
                         "libreoffice-writer.desktop", "steam.desktop"]
            },
            theme: {
                preset: "classic",     // classic | cave | snow | desert | village
                accent: "#5fbf4f",
                gold: "#ffcc4d",
                texture: "deepslate", // deepslate | stone | dirt | cobblestone | oak_planks | bedrock
                barTexture: "deepslate",
                panelTexture: "dirt",
                cardTexture: "oak_planks",
                barBg: "#17140f",
                panel: "#c6c6c6",
                cardBg: "#1c1712",
                dockBg: "#6b4a24",
                text: "#f4f4f4",
                textDim: "#b9b9b9",
                textOnPanel: "#3f3f3f",
                textShadow: "#3a3a3a",
                textHints: "#6a6a6a",
                outline: "#1a1a1a",
                bevelLight: "#ffffff",
                bevelDark: "#4a4a4a",
                scale: 1.0
            },
            wallpaper: {
                enabled: false,
                path: "",
                color: "#101418",
                fillMode: "fill"      // fill | fit | tile
            },
            widgets: {
                clock: { enabled: true, x: 0.06, y: 0.10, showDate: true },
                weather: { enabled: true, x: 0.06, y: 0.32, city: "" },
                visualizer: { enabled: true, x: 0.06, y: 0.54, bars: 32 },
                calendar: { enabled: false, x: 0.06, y: 0.76 },
                stats: { enabled: false, x: 0.76, y: 0.10 },
                media: { enabled: false, x: 0.06, y: 0.66 },
                user: { enabled: true, x: 0.76, y: 0.30 }
            },
            dashboard: {
                enabled: true
            },
            sidebars: {
                left: { enabled: true, width: 260, widgets: ["stats", "calendar"] },
                right: { enabled: true, width: 260, widgets: ["music", "weather"] }
            },
            overview: {
                enabled: true,
                columns: 3,           // workspace cards per row
                desktops: 6,          // how many desktops to show
                showTitles: true,
                backdrop: 0.72
            },
            power: {
                confirm: true
            }
        };
    }

    // FileView exposes text either as a method or a property depending on the
    // Quickshell version; cope with both.
    function readText() {
        var v = cfg.text;
        if (typeof v === "function")
            return v.call(cfg) || "";
        return v || "";
    }


    // ------------------------------------------------------------ theme presets
    // Every preset writes the flat theme.* tokens, so switching is instant and
    // components only ever read Theme.*.
    readonly property var presets: ({
        classic: {
            accent: "#5fbf4f", gold: "#ffcc4d",
            barTexture: "deepslate", panelTexture: "dirt", cardTexture: "oak_planks",
            barBg: "#17140f", panel: "#c6c6c6", cardBg: "#1c1712", dockBg: "#6b4a24",
            text: "#f4f4f4", textDim: "#b9b9b9", textOnPanel: "#3f3f3f",
            textShadow: "#3a3a3a", textHints: "#6a6a6a",
            outline: "#1a1a1a", bevelLight: "#ffffff", bevelDark: "#4a4a4a",
            panelDark: "#8b8b8b", panelTextShadow: "#ffffff"
        },
        cave: {
            accent: "#ff9b3d", gold: "#ffc44d",
            barTexture: "deepslate", panelTexture: "cobblestone", cardTexture: "cobblestone",
            barBg: "#080808", panel: "#333333", cardBg: "#101010", dockBg: "#3b2a1a",
            text: "#f0e6d2", textDim: "#9c9488", textOnPanel: "#f0e6d2",
            textShadow: "#000000", textHints: "#a89f90",
            outline: "#000000", bevelLight: "#6e6e6e", bevelDark: "#202020",
            panelDark: "#262626", panelTextShadow: "#000000"
        },
        snow: {
            accent: "#3f8fd8", gold: "#e0a92a",
            barTexture: "snow", panelTexture: "ice", cardTexture: "snow",
            barBg: "#dfe9f2", panel: "#e8f1f7", cardBg: "#f4f9fc", dockBg: "#b9d4e6",
            text: "#1b2a3a", textDim: "#4f6272", textOnPanel: "#1b2a3a",
            textShadow: "#ffffff", textHints: "#5d7285",
            outline: "#7f97a8", bevelLight: "#ffffff", bevelDark: "#9fb6c6",
            panelDark: "#c9d8e4", panelTextShadow: "#ffffff"
        },
        desert: {
            accent: "#a8641a", gold: "#7a4c0e",
            barTexture: "sandstone", panelTexture: "sandstone", cardTexture: "dirt",
            barBg: "#d9c08c", panel: "#efdcb6", cardBg: "#f2e2c2", dockBg: "#8c6a3f",
            text: "#3a2a16", textDim: "#6b5334", textOnPanel: "#3a2a16",
            textShadow: "#fff4d8", textHints: "#7a6142",
            outline: "#8a6a3a", bevelLight: "#fff4d8", bevelDark: "#b08c54",
            panelDark: "#d9c08c", panelTextShadow: "#fff4d8"
        },
        village: {
            accent: "#6b8f3a", gold: "#e8b84a",
            barTexture: "oak_planks", panelTexture: "oak_planks", cardTexture: "oak_planks",
            barBg: "#3b2a18", panel: "#d8c39a", cardBg: "#2a1d10", dockBg: "#6b4a24",
            text: "#f3e6cf", textDim: "#c4b294", textOnPanel: "#3a2a16",
            textShadow: "#2a1d10", textHints: "#7a6142",
            outline: "#241708", bevelLight: "#efe0c0", bevelDark: "#6b5232",
            panelDark: "#b89a6a", panelTextShadow: "#efe0c0"
        }
    })

    function applyPreset(name) {
        var preset = root.presets[name];
        if (!preset)
            return;
        root.set("theme.preset", name);
        for (var key in preset)
            root.set("theme." + key, preset[key]);
    }

    function merge(base, incoming) {
        if (incoming === null || incoming === undefined || typeof incoming !== "object")
            return base;
        var out = Array.isArray(base) ? base.slice() : Object.assign({}, base);
        for (var key in incoming) {
            var v = incoming[key];
            if (v !== null && typeof v === "object" && !Array.isArray(v) && base !== null && typeof base === "object"
                    && base[key] !== null && typeof base[key] === "object" && !Array.isArray(base[key])) {
                out[key] = root.merge(base[key], v);
            } else {
                out[key] = v;
            }
        }
        return out;
    }

    function set(pathStr, value) {
        var parts = ("" + pathStr).split(".");
        var copy = JSON.parse(JSON.stringify(root.data));
        var node = copy;
        for (var i = 0; i < parts.length - 1; i++) {
            if (node[parts[i]] === null || typeof node[parts[i]] !== "object")
                node[parts[i]] = {};
            node = node[parts[i]];
        }
        node[parts[parts.length - 1]] = value;
        root.data = copy;
        root.dirty = true;
        saveTimer.restart();
    }

    function get(pathStr, fallback) {
        var parts = ("" + pathStr).split(".");
        var node = root.data;
        for (var i = 0; i < parts.length; i++) {
            if (node === null || node === undefined || typeof node !== "object")
                return fallback;
            node = node[parts[i]];
        }
        return node === undefined || node === null ? fallback : node;
    }

    function toggle(pathStr) {
        root.set(pathStr, !root.get(pathStr, false));
    }

    function reset() {
        root.data = root.defaults();
        root.dirty = true;
        root.save();
    }

    function save() {
        if (root.path === "")
            return;
        root.dirty = false;
        cfgFile.setText(JSON.stringify(root.data, null, 2) + "\n");
    }

    property FileView cfgFile: FileView {
        id: cfg
        path: root.path
        watchChanges: false

        onLoaded: {
            var parsed = null;
            try {
                parsed = JSON.parse(root.readText());
            } catch (e) {
                parsed = null;
            }
            root.data = parsed ? root.merge(root.defaults(), parsed) : root.defaults();
            root.loaded = true;
        }
        onLoadFailed: {
            // First run: keep the defaults and write them out.
            root.loaded = true;
            if (root.path !== "")
                root.save();
        }
    }

    property Timer saveTimer: Timer {
        interval: 250
        onTriggered: root.save()
    }

    property Process mkdir: Process {
        command: ["mkdir", "-p", root.configDir]
        onExited: root.path = root.configDir + "/config.json"
    }

    Component.onCompleted: root.mkdir.running = true
}

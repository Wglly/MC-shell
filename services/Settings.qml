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
            version: 4,
            language: "auto",
            bar: {
                position: "top",      // top | bottom | left | right
                visible: true,
                showStats: true,
                showTray: true,
                showTitle: true,
                showClock: true,
                thickness: 40,
                items: {
                    launcher: true, workspaces: true, title: true, clock: true,
                    media: true, stats: true, net: true, volume: true, battery: true,
                    tray: true, user: true, basketLeft: true, basketRight: true, dockstrip: true,
                    overview: true, dashboard: true, settings: true, power: true
                },
                sections: {
                    left: ["launcher", "workspaces", "dockstrip", "title"],
                    center: ["clock"],
                    right: ["media", "stats", "net", "volume", "battery", "tray",
                            "user", "basketLeft", "basketRight", "overview",
                            "dashboard", "settings", "power"]
                }
            },
            dock: {
                position: "bottom",   // bottom | top | left | right
                visible: true,
                autoHide: false,
                iconSize: 42,
                showMedia: true,      // mini player + dashboard button row
                mode: "standalone",   // standalone | bar (compact strip inside the bar)
                avoidWindows: true,   // tuck the dock away while apps are open
                hoverZone: 12,        // px of edge that reacts to the pointer
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
                dockTexture: "oak_planks",
                barTextureOpacity: 0.85,
                barTextureStretch: false,
                barBg: "#17140f",
                panel: "#c6c6c6",
                cardBg: "#1c1712",
                dockBg: "#6b4a24",
                text: "#f4f4f4",
                textDim: "#b9b9b9",
                cardText: "#f4f4f4",
                cardTextDim: "#b9b9b9",
                cardTitle: "#ffcc4d",
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
                folder: "",
                color: "#101418",
                fillMode: "fill"      // fill | fit | tile
            },
            widgets: {
                clock: { enabled: true, x: 0.06, y: 0.10, showDate: true, scale: 1.0 },
                weather: { enabled: true, x: 0.06, y: 0.32, city: "", scale: 1.0 },
                visualizer: { enabled: true, x: 0.06, y: 0.54, bars: 32, scale: 1.0 },
                calendar: { enabled: false, x: 0.06, y: 0.76, scale: 1.0 },
                stats: { enabled: false, x: 0.76, y: 0.10, scale: 1.0 },
                media: { enabled: false, x: 0.06, y: 0.66, scale: 1.0 },
                user: { enabled: true, x: 0.76, y: 0.30, scale: 1.0 }
            },
            capture: {
                screenshot: true,
                record: true
            },
            dashboard: {
                enabled: true
            },
            sidebars: {
                closeMode: "click",
                closeDelay: 450,
                left: { enabled: true, width: 260, widgets: ["perfmon", "wallpaper", "widgetmanager"] },
                right: { enabled: true, width: 260, widgets: ["user", "toggles", "sliders", "messages"] }
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
            dockTexture: "oak_planks", barTextureOpacity: 0.85, barTextureStretch: false,
            barBg: "#17140f", panel: "#c6c6c6", cardBg: "#1c1712", dockBg: "#6b4a24",
            text: "#f4f4f4", textDim: "#b9b9b9", textOnPanel: "#3f3f3f",
            textShadow: "#3a3a3a", textHints: "#6a6a6a",
            outline: "#1a1a1a", bevelLight: "#ffffff", bevelDark: "#4a4a4a",
            panelDark: "#8b8b8b", panelTextShadow: "#ffffff",
            cardText: "#f4f4f4", cardTextDim: "#b9b9b9", cardTitle: "#ffcc4d"
        },
        cave: {
            accent: "#ff9b3d", gold: "#ffc44d",
            barTexture: "deepslate", panelTexture: "cobblestone", cardTexture: "cobblestone",
            dockTexture: "oak_planks", barTextureOpacity: 0.85, barTextureStretch: false,
            barBg: "#080808", panel: "#333333", cardBg: "#101010", dockBg: "#3b2a1a",
            text: "#f0e6d2", textDim: "#9c9488", textOnPanel: "#f0e6d2",
            textShadow: "#000000", textHints: "#a89f90",
            outline: "#000000", bevelLight: "#6e6e6e", bevelDark: "#202020",
            panelDark: "#262626", panelTextShadow: "#000000",
            cardText: "#f0e6d2", cardTextDim: "#9c9488", cardTitle: "#ffc44d"
        },
        snow: {
            accent: "#3f8fd8", gold: "#e0a92a",
            barTexture: "snow", panelTexture: "ice", cardTexture: "snow",
            dockTexture: "oak_planks", barTextureOpacity: 0.85, barTextureStretch: false,
            barBg: "#dfe9f2", panel: "#e8f1f7", cardBg: "#f4f9fc", dockBg: "#b9d4e6",
            text: "#1b2a3a", textDim: "#4f6272", textOnPanel: "#1b2a3a",
            textShadow: "#ffffff", textHints: "#5d7285",
            outline: "#7f97a8", bevelLight: "#ffffff", bevelDark: "#9fb6c6",
            panelDark: "#c9d8e4", panelTextShadow: "#ffffff",
            cardText: "#1b2a3a", cardTextDim: "#4f6272", cardTitle: "#1b2a3a"
        },
        desert: {
            accent: "#a8641a", gold: "#7a4c0e",
            barTexture: "sandstone", panelTexture: "sandstone", cardTexture: "dirt",
            dockTexture: "oak_planks", barTextureOpacity: 0.85, barTextureStretch: false,
            barBg: "#d9c08c", panel: "#efdcb6", cardBg: "#f2e2c2", dockBg: "#8c6a3f",
            text: "#3a2a16", textDim: "#6b5334", textOnPanel: "#3a2a16",
            textShadow: "#fff4d8", textHints: "#7a6142",
            outline: "#8a6a3a", bevelLight: "#fff4d8", bevelDark: "#b08c54",
            panelDark: "#d9c08c", panelTextShadow: "#fff4d8",
            cardText: "#3a2a16", cardTextDim: "#6b5334", cardTitle: "#7a4c0e"
        },
        village: {
            accent: "#6b8f3a", gold: "#e8b84a",
            barTexture: "oak_planks", panelTexture: "oak_planks", cardTexture: "oak_planks",
            dockTexture: "oak_planks", barTextureOpacity: 0.85, barTextureStretch: false,
            barBg: "#3b2a18", panel: "#d8c39a", cardBg: "#2a1d10", dockBg: "#6b4a24",
            text: "#f3e6cf", textDim: "#c4b294", textOnPanel: "#3a2a16",
            textShadow: "#2a1d10", textHints: "#7a6142",
            outline: "#241708", bevelLight: "#efe0c0", bevelDark: "#6b5232",
            panelDark: "#b89a6a", panelTextShadow: "#efe0c0",
            cardText: "#f3e6cf", cardTextDim: "#c4b294", cardTitle: "#e8b84a"
        },
        winxp: {
            accent: "#316ac5", gold: "#ffd34d",
            barTexture: "winxp_bar", panelTexture: "winxp_panel", cardTexture: "winxp_card",
            dockTexture: "", barTextureOpacity: 1.0, barTextureStretch: true,
            barBg: "#245edb", panel: "#ece9d8", cardBg: "#ffffff", dockBg: "#245edb",
            text: "#ffffff", textDim: "#dbe8ff", textOnPanel: "#000000",
            textShadow: "#08316e", textHints: "#4a4a4a",
            outline: "#0a246a", bevelLight: "#ffffff", bevelDark: "#7f9db9",
            panelDark: "#d4d0c8", panelTextShadow: "#ffffff",
            cardText: "#1a1a1a", cardTextDim: "#444444", cardTitle: "#0a246a"
        },
        win7: {
            accent: "#4aa3df", gold: "#ffd34d",
            barTexture: "win7_bar", panelTexture: "win7_panel", cardTexture: "win7_card",
            dockTexture: "win7_task", barTextureOpacity: 1.0, barTextureStretch: true,
            barBg: "#24384c", panel: "#f2f2f2", cardBg: "#ffffff", dockBg: "#24384c",
            text: "#ffffff", textDim: "#c9d7e3", textOnPanel: "#1a1a1a",
            textShadow: "#0a141f", textHints: "#5a6672",
            outline: "#4a6480", bevelLight: "#e8f4ff", bevelDark: "#8fa6ba",
            panelDark: "#e2e2e2", panelTextShadow: "#ffffff",
            cardText: "#1a1a1a", cardTextDim: "#5a6672", cardTitle: "#1f4e79",
            cornerRadius: 10, glassOpacity: 0.8, glassBorder: "#7fb4d6"
        },
        win95: {
            accent: "#000080", gold: "#000080",
            barTexture: "", panelTexture: "", cardTexture: "",
            dockTexture: "", barTextureOpacity: 1.0, barTextureStretch: false,
            barBg: "#c0c0c0", panel: "#c0c0c0", cardBg: "#c0c0c0", dockBg: "#c0c0c0",
            text: "#000000", textDim: "#404040", textOnPanel: "#000000",
            textShadow: "#ffffff", textHints: "#000000",
            outline: "#000000", bevelLight: "#ffffff", bevelDark: "#808080",
            panelDark: "#a0a0a0", panelTextShadow: "#ffffff",
            cardText: "#000000", cardTextDim: "#404040", cardTitle: "#000080",
            bevelSize: 0
        }
    })

    function applyPreset(name) {
        var preset = root.presets[name];
        if (!preset)
            return;
        root.set("theme.preset", name);
        for (var key in preset)
            root.set("theme." + key, preset[key]);
        // glass surfaces only exist in themes that ask for them
        if (preset.cornerRadius === undefined)
            root.set("theme.cornerRadius", 0);
        if (preset.glassOpacity === undefined)
            root.set("theme.glassOpacity", 1.0);
        if (preset.glassBorder === undefined)
            root.set("theme.glassBorder", "#1a1a1a");
        if (preset.bevelSize === undefined)
            root.set("theme.bevelSize", 2);
    }

    // Bring older config files forward when the basket layout changes.
    function migrate(parsed) {
        var v = parsed && parsed.version ? parsed.version : 0;
        if (v < 3) {
            root.set("sidebars.left.widgets", ["perfmon", "wallpaper"]);
            root.set("sidebars.right.widgets", ["user", "toggles", "sliders", "messages", "widgetmanager"]);
            root.set("version", 3);
        }
        if (v < 4) {
            // widget manager lives in the left basket now
            var left = root.get("sidebars.left.widgets", []).slice();
            var right = root.get("sidebars.right.widgets", []).slice();
            var rIdx = right.indexOf("widgetmanager");
            if (rIdx >= 0)
                right.splice(rIdx, 1);
            if (left.indexOf("widgetmanager") < 0)
                left.push("widgetmanager");
            root.set("sidebars.left.widgets", left);
            root.set("sidebars.right.widgets", right);
            root.set("version", 4);
        }
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
            root.migrate(parsed);
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

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
                pinned: ["firefox.desktop", "org.gnome.Nautilus.desktop", "kitty.desktop",
                         "org.gnome.Console.desktop", "org.gnome.TextEditor.desktop",
                         "libreoffice-writer.desktop", "steam.desktop"]
            },
            theme: {
                accent: "#5fbf4f",
                gold: "#ffcc4d",
                texture: "deepslate", // deepslate | stone | dirt | cobblestone | oak_planks | bedrock
                barTexture: "deepslate",
                panelTexture: "dirt",
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
                stats: { enabled: false, x: 0.76, y: 0.10 }
            },
            sidebars: {
                left: { enabled: true, width: 260, widgets: ["stats", "calendar"] },
                right: { enabled: true, width: 260, widgets: ["music", "weather"] }
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

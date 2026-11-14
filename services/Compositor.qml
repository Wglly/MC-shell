pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.modules.common

// Compositor.qml — one workspace/window API for both Hyprland and niri.
//
// * Hyprland is read through Quickshell.Hyprland (event driven, zero polling).
// * niri has no Quickshell service in 0.3.x, so we talk to `niri msg` and keep
//   the state fresh from `niri msg event-stream`, debounced into two cheap
//   JSON queries.  No extra QML plugin needed.
QtObject {
    id: root

    readonly property bool isHyprland: (Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") || "") !== ""
    readonly property bool isNiri: !isHyprland && (Quickshell.env("NIRI_SOCKET") || "") !== ""
    readonly property string backend: isHyprland ? "hyprland" : (isNiri ? "niri" : "none")

    // ------------------------------------------------------------- niri state
    property var niriList: []
    property int niriFocusedId: -1
    property string niriTitle: ""
    property string niriAppId: ""
    property string niriOutput: ""

    // ------------------------------------------------------------ hypr helpers
    function mapHypr(wsList, focused) {
        var out = [];
        if (!wsList)
            return out;
        var focusId = focused && focused.id !== undefined ? focused.id : -1;
        for (var i = 0; i < wsList.length; i++) {
            var w = wsList[i];
            if (!w)
                continue;
            var id = w.id;
            if (typeof id !== "number" || id <= 0)
                continue; // skip special workspaces
            out.push({
                id: id,
                name: "" + (w.name === undefined ? id : w.name),
                active: id === focusId,
                occupied: (w.windows || 0) > 0
            });
        }
        out.sort(function (a, b) { return a.id - b.id; });
        return out;
    }

    // Single reactive workspace list for the bar.
    readonly property var workspaces: {
        if (root.backend === "hyprland")
            return root.mapHypr(Hyprland.workspaces.values, Hyprland.focusedWorkspace);
        return root.niriList;
    }

    readonly property int focusedId: {
        if (root.backend === "hyprland")
            return Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1;
        return root.niriFocusedId;
    }

    readonly property string windowTitle: {
        if (root.backend === "hyprland")
            return Hyprland.activeToplevel ? (Hyprland.activeToplevel.title || "") : "";
        return root.niriTitle;
    }

    readonly property string windowAppId: {
        if (root.backend === "hyprland")
            return Hyprland.activeToplevel ? (Hyprland.activeToplevel.appId || "") : "";
        return root.niriAppId;
    }

    readonly property string outputName: {
        if (root.backend === "hyprland")
            return Hyprland.focusedMonitor ? (Hyprland.focusedMonitor.name || "") : "";
        return root.niriOutput;
    }

    // --------------------------------------------------------------- actions
    function focusWorkspace(id) {
        if (root.backend === "hyprland") {
            Hyprland.dispatch("workspace " + id);
            return;
        }
        if (root.backend === "niri") {
            var ws = root.findNiri(id);
            if (ws) {
                niriAction.command = ["niri", "msg", "action", "focus-workspace", "" + ws.idx];
                if (!niriAction.running)
                    niriAction.running = true;
            }
        }
    }

    function findNiri(id) {
        for (var i = 0; i < root.niriList.length; i++)
            if (root.niriList[i].id === id)
                return root.niriList[i];
        return null;
    }

    function currentIndex() {
        var list = root.workspaces;
        for (var i = 0; i < list.length; i++)
            if (list[i].active)
                return i;
        return -1;
    }

    function step(delta) {
        var list = root.workspaces;
        if (list.length === 0)
            return;
        var idx = root.currentIndex();
        var next = idx < 0 ? 0 : idx + delta;
        if (next < 0)
            next = list.length - 1;
        if (next >= list.length)
            next = 0;
        root.focusWorkspace(list[next].id);
    }

    // ------------------------------------------------------------ niri plumbing
    function applyWorkspaces(raw) {
        var out = [];
        var focused = -1;
        var output = "";
        try {
            var arr = JSON.parse(raw);
            for (var i = 0; i < arr.length; i++) {
                var w = arr[i];
                if (!w || (w.idx !== undefined && w.idx !== null && w.idx < 1))
                    continue;
                out.push({
                    id: w.id,
                    idx: w.idx !== undefined ? w.idx : w.id,
                    name: w.name ? ("" + w.name) : ("" + w.idx),
                    active: !!w.is_focused,
                    occupied: w.active_window_id !== null && w.active_window_id !== undefined
                });
                if (w.is_focused) {
                    focused = w.id;
                    output = w.output || "";
                }
            }
        } catch (e) {
            console.warn("MC-shell: bad niri workspaces payload", e);
            return;
        }
        out.sort(function (a, b) { return a.id - b.id; });
        root.niriList = out;
        root.niriFocusedId = focused;
        if (output !== "")
            root.niriOutput = output;
    }

    function applyFocusedWindow(raw) {
        try {
            var w = JSON.parse(raw);
            if (!w) {
                root.niriTitle = "";
                root.niriAppId = "";
                return;
            }
            root.niriTitle = w.title || "";
            root.niriAppId = w.app_id || "";
            if (w.workspace_id !== undefined)
                root.niriOutput = root.niriOutput;
        } catch (e) {
            root.niriTitle = "";
            root.niriAppId = "";
        }
    }

    property bool refreshQueued: false
    function scheduleRefresh() {
        if (root.refreshQueued)
            return;
        root.refreshQueued = true;
        niriDebounce.restart();
    }

    property Timer niriDebounce: Timer {
        interval: 120
        onTriggered: {
            root.refreshQueued = false;
            niriWorkspaces.running = true;
            niriWindow.running = true;
        }
    }

    property Process niriWorkspaces: Process {
        command: ["niri", "msg", "--json", "workspaces"]
        stdout: StdioCollector {
            onStreamFinished: root.applyWorkspaces(text)
        }
    }

    property Process niriWindow: Process {
        command: ["niri", "msg", "--json", "focused-window"]
        stdout: StdioCollector {
            onStreamFinished: root.applyFocusedWindow(text)
        }
    }

    // Event stream: only used as a change signal, the state comes from the JSON
    // queries above so we never depend on an event payload shape.
    property Process niriEvents: Process {
        command: ["niri", "msg", "event-stream"]
        running: root.isNiri
        stdout: SplitParser {
            onRead: line => {
                if (line && line.length > 0)
                    root.scheduleRefresh();
            }
        }
        onExited: {
            if (root.isNiri)
                niriRestart.restart();
        }
    }

    property Timer niriRestart: Timer {
        interval: 1000
        onTriggered: root.niriEvents.running = true
    }

    // Safety net: cheap poll in case the event stream dies silently.
    property Timer niriPoll: Timer {
        interval: 3000
        running: root.isNiri
        repeat: true
        onTriggered: root.scheduleRefresh()
    }

    property Process niriAction: Process {
        command: ["niri", "msg", "action", "focus-workspace", "1"]
        onExited: root.scheduleRefresh()
    }

    Component.onCompleted: {
        if (root.isNiri)
            root.scheduleRefresh();
    }
}

pragma Singleton
import QtQuick

// ShellState.qml — tiny global state shared by the bar, overlays and OSD.
QtObject {
    id: state

    // "none" | "launcher" | "control" | "settings" | "power"
    property string overlay: "none"

    // active settings tab (see SettingsWindow.tabs)
    property int settingsTab: 0

    // side baskets are opened on demand from the bar
    // space the dock needs on its edge (driven by Dock.qml)
    property int dockReserve: 0

    // small context menu for dock slots (right click)
    property var dockMenu: ({ visible: false, name: "", path: "", pinned: false, canPin: false })

    function openDockMenu(app) {
        ShellState.dockMenu = {
            visible: true,
            name: app.name,
            path: app.path,
            pinned: app.pinned === true,
            canPin: app.path !== ""
        };
    }

    function closeDockMenu() {
        var m = ShellState.dockMenu;
        ShellState.dockMenu = { visible: false, name: m.name, path: m.path, pinned: m.pinned, canPin: m.canPin };
    }

    function toggleDockPin(path) {
        var id = path.split("/").pop();
        if (id === "")
            return;
        var list = Settings.get("dock.pinned", []).slice();
        var i = list.indexOf(id);
        var name = id.replace(/\.desktop$/, "");
        if (i >= 0) {
            list.splice(i, 1);
            Notifs.toast(I18n.t("dock.toast.unpinned"), name);
        } else {
            list.push(id);
            Notifs.toast(I18n.t("dock.toast.pinned"), name);
        }
        Settings.set("dock.pinned", list);
        ShellState.closeDockMenu();
    }
    property bool leftBasket: false
    property bool rightBasket: false

    function toggleBasket(side) {
        if (side === "left")
            ShellState.leftBasket = !ShellState.leftBasket;
        else if (side === "right")
            ShellState.rightBasket = !ShellState.rightBasket;
    }

    // OSD: "" hides, "volume" / "brightness" shows briefly
    property string osdKind: ""
    property real osdValue: 0
    property string osdLabel: ""

    function toggleOverlay(name) {
        state.overlay = state.overlay === name ? "none" : name
    }
    function closeOverlay() {
        state.overlay = "none"
    }

    function flashOsd(kind, value, label) {
        state.osdKind = kind
        state.osdValue = value
        state.osdLabel = label === undefined ? "" : label
        osdTimer.restart()
    }

    property Timer osdTimer: Timer {
        interval: 1600
        onTriggered: state.osdKind = ""
    }
}

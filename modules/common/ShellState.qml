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
    // bar dropdown: "" | "calendar" | "media" | "user"
    property string barPopup: ""
    // screen x of the anchor icon (-1 = centre)
    property real barPopupX: -1

    function toggleBarPopup(kind) {
        ShellState.barPopup = (ShellState.barPopup === kind) ? "" : kind;
    }

    function closeBarPopup() {
        ShellState.barPopup = "";
    }

    // keep the session awake (idle inhibit)
    property bool keepAwake: false

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

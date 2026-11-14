pragma Singleton
import QtQuick

// ShellState.qml — tiny global state shared by the bar, overlays and OSD.
QtObject {
    id: state

    // "none" | "launcher" | "control" | "settings" | "power"
    property string overlay: "none"

    // active settings tab (see SettingsWindow.tabs)
    property int settingsTab: 0

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

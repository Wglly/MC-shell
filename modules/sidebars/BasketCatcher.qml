import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.services

// BasketCatcher — a background click-catcher: clicking the desktop closes the baskets.
PanelWindow {
    id: root

    required property var targetScreen
    readonly property bool open: ShellState.leftBasket || ShellState.rightBasket

    screen: targetScreen
    visible: root.open
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top

    // leave the basket columns uncovered so clicks inside them reach the basket
    readonly property int leftPad: ShellState.leftBasket
        ? Math.max(0, Settings.get("sidebars.left.width", 260) + 24) : 0
    readonly property int rightPad: ShellState.rightBasket
        ? Math.max(0, Settings.get("sidebars.right.width", 260) + 24) : 0

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    margins.left: root.leftPad
    margins.right: root.rightPad

    readonly property bool hoverClose: Settings.get("sidebars.closeMode", "click") === "hover"

    function closeAll() {
        ShellState.leftBasket = false;
        ShellState.rightBasket = false;
    }

    Timer {
        id: leaveTimer
        interval: Math.max(0, Settings.get("sidebars.closeDelay", 450))
        repeat: false
        onTriggered: if (root.open) root.closeAll()
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: root.hoverClose
        onClicked: if (!root.hoverClose) root.closeAll()
        onContainsMouseChanged: {
            if (!root.hoverClose)
                return;
            if (containsMouse)
                leaveTimer.restart();
            else
                leaveTimer.stop();
        }
    }
}

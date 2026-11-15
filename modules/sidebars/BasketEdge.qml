import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.services

// BasketEdge — a 6px hover strip on the screen edge that opens a basket.
PanelWindow {
    id: root

    required property var targetScreen
    property string side: "left"

    readonly property bool enabledSide: Settings.get("sidebars." + root.side + ".enabled", true) === true
    readonly property bool open: root.side === "left" ? ShellState.leftBasket : ShellState.rightBasket

    screen: targetScreen
    visible: root.enabledSide && !root.open
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top

    anchors.top: true
    anchors.bottom: true
    anchors.left: root.side === "left"
    anchors.right: root.side === "right"
    implicitWidth: 6

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            if (root.side === "left")
                ShellState.leftBasket = true;
            else
                ShellState.rightBasket = true;
        }
    }
}

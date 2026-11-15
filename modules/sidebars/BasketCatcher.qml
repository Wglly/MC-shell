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
    WlrLayershell.layer: WlrLayer.Bottom

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    MouseArea {
        anchors.fill: parent
        onClicked: {
            ShellState.leftBasket = false;
            ShellState.rightBasket = false;
        }
    }
}

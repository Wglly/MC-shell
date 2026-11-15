import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.services

PanelWindow {
    id: spacer

    required property var targetScreen

    readonly property bool leftOpen: ShellState.leftBasket && Settings.get("sidebars.left.enabled", true) === true
    readonly property bool rightOpen: ShellState.rightBasket && Settings.get("sidebars.right.enabled", true) === true
    readonly property int leftSize: Settings.get("sidebars.left.width", 260) + 12
    readonly property int rightSize: Settings.get("sidebars.right.width", 260) + 12
    readonly property int zone: leftOpen ? leftSize : (rightOpen ? rightSize : 0)

    screen: targetScreen
    color: "transparent"
    visible: zone > 0
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: zone
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "mc-shell-basket-space"

    anchors.top: true
    anchors.bottom: true
    anchors.left: leftOpen
    anchors.right: rightOpen
    implicitWidth: zone
    implicitHeight: spacer.screen ? spacer.screen.height : 1080
}

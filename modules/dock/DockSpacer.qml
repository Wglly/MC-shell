import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.services

// DockSpacer — an invisible full-width surface on the Background layer whose only
// job is to reserve the dock's edge, so tiled windows slide up when the dock shows.
PanelWindow {
    id: spacer

    required property var targetScreen

    readonly property string edge: Settings.get("dock.position", "bottom")
    readonly property bool horizontal: edge === "top" || edge === "bottom"
    readonly property int reserve: Math.max(0, ShellState.dockReserve)

    screen: targetScreen
    color: "transparent"
    visible: Settings.get("dock.visible", true) === true && reserve > 0
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: reserve
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "mc-shell-dock-space"

    anchors.left: horizontal || edge === "right"
    anchors.right: horizontal || edge === "left"
    anchors.top: edge === "top"
    anchors.bottom: edge === "bottom"

    implicitWidth: horizontal ? spacer.screen.width : reserve
    implicitHeight: horizontal ? reserve : spacer.screen.height
}

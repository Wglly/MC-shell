import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.services

// BarSpacer — reserves the bar's edge from the Background layer, exactly like the dock
// spacer does, so the bar itself can stay pinned with a fixed size.
PanelWindow {
    id: spacer

    required property var targetScreen

    readonly property string pos: Settings.get("bar.position", "top")
    readonly property bool vertical: spacer.pos === "left" || spacer.pos === "right"
    readonly property int thick: Math.max(36, Settings.get("bar.thickness", 40))
    property bool armed: false
    readonly property int reserve: Settings.get("bar.visible", true) === true && spacer.armed ? spacer.thick : 0
    Timer {
        interval: 700
        running: true
        onTriggered: spacer.armed = true
    }

    screen: targetScreen
    color: "transparent"
    visible: spacer.reserve > 0
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: spacer.reserve
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "mc-shell-bar-space"

    anchors.left: spacer.vertical ? spacer.pos === "left" : true
    anchors.right: spacer.vertical ? spacer.pos === "right" : false
    anchors.top: spacer.vertical ? true : spacer.pos === "top"
    anchors.bottom: spacer.vertical ? false : spacer.pos === "bottom"

    implicitWidth: spacer.vertical ? spacer.reserve : spacer.screen.width
    implicitHeight: spacer.vertical ? spacer.screen.height : spacer.reserve
}

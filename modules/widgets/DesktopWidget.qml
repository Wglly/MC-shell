import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.services

// DesktopWidget — a draggable card living on the wallpaper layer.
//
// Position is stored as a ratio of the screen so it survives resolution
// changes.  Drag anywhere on the card; the new spot is saved on release.
PanelWindow {
    id: base

    required property string widgetKey
    required property var targetScreen

    // subclasses declare their natural size; the settings scale multiplies it
    property real baseWidth: 260
    property real baseHeight: 140
    readonly property real widgetScale: Math.max(0.6, Math.min(1.8,
        Settings.get("widgets.scale", 1.0)))

    screen: targetScreen
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Bottom
    visible: Settings.get("widgets." + base.widgetKey + ".enabled", false) === true

    anchors.top: true
    anchors.left: true

    implicitWidth: Math.round(baseWidth * widgetScale)
    implicitHeight: Math.round(baseHeight * widgetScale)

    default property alias widgetContent: contentItem.data

    Item {
        id: contentItem
        width: base.baseWidth
        height: base.baseHeight
        transform: Scale { origin.x: 0; origin.y: 0; xScale: base.widgetScale; yScale: base.widgetScale }
    }

    property real dragDx: 0
    property real dragDy: 0

    readonly property real ratioX: Settings.get("widgets." + base.widgetKey + ".x", 0.05)
    readonly property real ratioY: Settings.get("widgets." + base.widgetKey + ".y", 0.05)
    readonly property real screenW: base.screen ? base.screen.width : 1920
    readonly property real screenH: base.screen ? base.screen.height : 1080

    margins.left: Math.round(base.ratioX * base.screenW) + base.dragDx
    margins.top: Math.round(base.ratioY * base.screenH) + base.dragDy

    property bool dragEnabled: true

    MouseArea {
        id: dragArea
        anchors.fill: parent
        enabled: base.dragEnabled
        property real startX: 0
        property real startY: 0
        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

        onPressed: mouse => {
            startX = mouse.x;
            startY = mouse.y;
        }
        onPositionChanged: mouse => {
            if (!pressed)
                return;
            base.dragDx = mouse.x - startX;
            base.dragDy = mouse.y - startY;
        }
        onReleased: {
            var nx = Util.clamp((base.margins.left) / base.screenW, 0, Math.max(0, 1 - base.width / base.screenW));
            var ny = Util.clamp((base.margins.top) / base.screenH, 0, Math.max(0, 1 - base.height / base.screenH));
            base.dragDx = 0;
            base.dragDy = 0;
            Settings.set("widgets." + base.widgetKey + ".x", Math.round(nx * 1000) / 1000);
            Settings.set("widgets." + base.widgetKey + ".y", Math.round(ny * 1000) / 1000);
        }
    }
}

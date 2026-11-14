import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// Dock — the player inventory: a wooden 9x3 basket of app slots.
PanelWindow {
    id: root

    required property var targetScreen

    readonly property string pos: Settings.get("dock.position", "bottom")
    readonly property bool vertical: pos === "left" || pos === "right"
    readonly property bool enabled: Settings.get("dock.visible", true) === true
    readonly property bool autoHide: Settings.get("dock.autoHide", false) === true
    readonly property int iconSize: Math.max(28, Math.min(64, Settings.get("dock.iconSize", 42)))
    readonly property int slotPad: 3
    readonly property int columns: 9
    readonly property int rows: 3

    readonly property int panelW: (vertical ? root.rows : root.columns) * (root.iconSize + root.slotPad) + 14
    readonly property int panelH: (vertical ? root.columns : root.rows) * (root.iconSize + root.slotPad) + 14

    property bool expanded: !root.autoHide

    screen: targetScreen
    color: "transparent"
    visible: enabled
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top

    // PanelWindow only offers edge anchors, so centring is done with margins.
    anchors.left: root.vertical ? root.pos === "left" : true
    anchors.right: root.vertical ? root.pos === "right" : false
    anchors.top: root.vertical ? true : root.pos === "top"
    anchors.bottom: root.vertical ? false : root.pos === "bottom"

    implicitWidth: root.vertical ? (expanded ? panelW : 4) : panelW
    implicitHeight: root.vertical ? panelH : (expanded ? panelH : 4)

    readonly property real scrW: root.screen ? root.screen.width : 1920
    readonly property real scrH: root.screen ? root.screen.height : 1080

    // keep clear of the bar when it shares the same edge
    readonly property int barThickness: Settings.get("bar.thickness", 40)
    readonly property string barPos: Settings.get("bar.position", "top")
    readonly property bool barVisible: Settings.get("bar.visible", true) === true

    margins.top: root.vertical
        ? Math.round((root.scrH - root.panelH) / 2)
        : (root.pos === "top" ? 4 + (root.barVisible && root.barPos === "top" ? root.barThickness : 0) : 0)
    margins.bottom: root.vertical
        ? 0
        : (root.pos === "bottom" ? 4 + (root.barVisible && root.barPos === "bottom" ? root.barThickness : 0) : 0)
    margins.left: root.vertical
        ? 4 + (root.barVisible && root.barPos === "left" ? root.barThickness : 0)
        : Math.round((root.scrW - root.panelW) / 2)
    margins.right: 0

    // Hover handling for auto-hide: a thin strip stays on screen.
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.expanded = true
        onExited: if (root.autoHide) root.expanded = false
    }

    // --------------------------------------------------------------- contents
    McPanel {
        anchors.fill: parent
        visible: root.expanded
        background: "#6b4a24"
        texture: Theme.texturePath("oak_planks")
        textureOpacity: 0.95
        bevel: 3

        Grid {
            id: grid
            anchors.centerIn: parent
            columns: root.vertical ? root.rows : root.columns
            rows: root.vertical ? root.columns : root.rows
            spacing: root.slotPad

            Repeater {
                model: root.columns * root.rows

                delegate: Slot {
                    readonly property var app: index < root.dockApps.length ? root.dockApps[index] : null

                    width: root.iconSize
                    height: root.iconSize
                    icon: app && app.icon !== "" ? Quickshell.iconPath(app.icon, "") : ""
                    label: app ? app.name.charAt(0) : ""

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: app !== null
                        cursorShape: Qt.PointingHandCursor
                        onClicked: if (app) Apps.launch(app)
                    }
                }
            }
        }
    }

    // ------------------------------------------------------------- app mapping
    readonly property var dockApps: {
        var pinned = Settings.get("dock.pinned", []);
        var all = Apps.apps;
        var out = [];
        for (var i = 0; i < pinned.length && out.length < root.columns * root.rows; i++) {
            var id = pinned[i];
            for (var j = 0; j < all.length; j++) {
                if (all[j].path.endsWith("/" + id)) {
                    out.push(all[j]);
                    break;
                }
            }
        }
        if (out.length === 0) {
            for (var k = 0; k < all.length && out.length < 12; k++)
                out.push(all[k]);
        }
        return out;
    }
}

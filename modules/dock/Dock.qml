import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// Dock — the player inventory, plus a mini media player and a dashboard button.
PanelWindow {
    id: root

    required property var targetScreen

    readonly property string pos: Settings.get("dock.position", "bottom")
    readonly property bool vertical: pos === "left" || pos === "right"
    readonly property bool enabled: Settings.get("dock.visible", true) === true
    readonly property bool autoHide: Settings.get("dock.autoHide", false) === true
    readonly property int iconSize: Math.max(28, Math.min(64, Settings.get("dock.iconSize", 42)))
    readonly property int slotPad: 3
    // Free grid: rows/columns come straight from Settings.
    readonly property int columns: Math.max(1, Math.min(12, Settings.get("dock.columns", 9)))
    readonly property int rows: Math.max(1, Math.min(6, Settings.get("dock.rows", 3)))

    readonly property int gridCols: root.vertical ? root.rows : root.columns
    readonly property int gridRows: root.vertical ? root.columns : root.rows
    readonly property int panelW: root.gridCols * (root.iconSize + root.slotPad) + 14
    readonly property int panelH: root.gridRows * (root.iconSize + root.slotPad) + 14

    readonly property bool showMedia: Settings.get("dock.showMedia", true) === true
    readonly property int mediaH: (!root.vertical && root.showMedia) ? 38 : 0
    readonly property int dashH: root.vertical ? 34 : 0
    readonly property int extraH: (root.mediaH > 0 ? root.mediaH + 4 : 0) + (root.dashH > 0 ? root.dashH + 4 : 0)
    readonly property int fullH: root.panelH + root.extraH

    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

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
    implicitHeight: root.vertical ? root.fullH : (expanded ? root.fullH : 4)

    readonly property real scrW: root.screen ? root.screen.width : 1920
    readonly property real scrH: root.screen ? root.screen.height : 1080

    // keep clear of the bar when it shares the same edge
    readonly property int barThickness: Settings.get("bar.thickness", 40)
    readonly property string barPos: Settings.get("bar.position", "top")
    readonly property bool barVisible: Settings.get("bar.visible", true) === true

    margins.top: root.vertical
        ? Math.round((root.scrH - root.fullH) / 2)
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
    Column {
        anchors.fill: parent
        spacing: 4
        visible: root.expanded

        // dashboard-only row for vertical docks
        McPanel {
            visible: root.vertical
            width: parent.width
            height: 30
            background: Theme.dockBg
            texture: Theme.texturePath("oak_planks")
            textureOpacity: 0.9

            Slot {
                anchors.centerIn: parent
                width: 24
                height: 24
                icon: Qt.resolvedUrl("../../assets/textures/icon_dashboard.png")
                onClicked: ShellState.toggleOverlay("dashboard")
            }
        }

        // mini media player + dashboard button
        McPanel {
            visible: !root.vertical && root.showMedia
            width: parent.width
            height: root.mediaH
            background: Theme.dockBg
            texture: Theme.texturePath("oak_planks")
            textureOpacity: 0.9

            Row {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 6
                spacing: 6

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.max(80, parent.width - 210)
                    spacing: 1

                    PixelText {
                        width: parent.width
                        elide: Text.ElideRight
                        text: root.player
                            ? (root.player.trackTitle || I18n.t("control.nothingPlaying"))
                            : I18n.t("control.nothingPlaying")
                        font.pixelSize: 10
                        color: Theme.text
                    }
                    PixelText {
                        width: parent.width
                        elide: Text.ElideRight
                        visible: root.player !== null
                        text: root.player ? (root.player.trackArtist || "") : ""
                        font.pixelSize: 9
                        color: Theme.textDim
                    }
                }

                McButton {
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: 40
                    implicitHeight: 26
                    visible: root.player !== null
                    label: "|◀"
                    enabledButton: root.player && root.player.canGoPrevious
                    onClicked: if (root.player) root.player.previous()
                }
                McButton {
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: 44
                    implicitHeight: 26
                    visible: root.player !== null
                    label: root.player && root.player.isPlaying ? "||" : "▶"
                    onClicked: if (root.player) root.player.togglePlaying()
                }
                McButton {
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: 40
                    implicitHeight: 26
                    visible: root.player !== null
                    label: "▶|"
                    enabledButton: root.player && root.player.canGoNext
                    onClicked: if (root.player) root.player.next()
                }
                Slot {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 26
                    height: 26
                    icon: Qt.resolvedUrl("../../assets/textures/icon_dashboard.png")
                    onClicked: ShellState.toggleOverlay("dashboard")
                }
            }
        }

        // inventory
        McPanel {
            width: parent.width
            height: root.panelH
            background: Theme.dockBg
            texture: Theme.texturePath("oak_planks")
            textureOpacity: 0.95
            bevel: 3

            Grid {
                id: grid
                anchors.centerIn: parent
                columns: root.gridCols
                rows: root.gridRows
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

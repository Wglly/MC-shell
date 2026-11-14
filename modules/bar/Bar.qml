import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Networking
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.bar
import qs.services

// Bar — one PanelWindow per monitor; position, thickness and contents come
// from Settings.  Horizontal (top/bottom) and vertical (left/right) layouts.
PanelWindow {
    id: root

    required property var modelData
    screen: modelData

    readonly property string pos: Settings.get("bar.position", "top")
    readonly property bool vertical: pos === "left" || pos === "right"
    readonly property int thickness: Math.max(36, Settings.get("bar.thickness", 40))
    readonly property bool barVisible: Settings.get("bar.visible", true)

    anchors {
        left: root.vertical ? root.pos === "left" : true
        right: root.vertical ? root.pos === "right" : true
        top: root.vertical ? true : root.pos === "top"
        bottom: root.vertical ? true : root.pos === "bottom"
    }
    implicitWidth: root.vertical ? root.thickness : 0
    implicitHeight: root.vertical ? 0 : root.thickness
    color: "transparent"
    visible: root.barVisible
    exclusiveZone: root.barVisible ? root.thickness : 0
    exclusionMode: ExclusionMode.Normal

    // ------------------------------------------------------------- background
    McPanel {
        anchors.fill: parent
        bevel: 2
        background: Theme.barBg
        texture: Theme.texturePath(Settings.get("theme.barTexture", "deepslate"))
        textureOpacity: Theme.barTextureOpacity
        textureFillMode: Theme.barTextureStretch ? Image.Stretch : Image.Tile
    }

    // ------------------------------------------------------------- horizontal
    Item {
        visible: !root.vertical
        anchors.fill: parent
        anchors.margins: 4

        Row {
            id: leftRow
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Slot {
                width: 30
                height: 30
                icon: Qt.resolvedUrl("../../assets/textures/grass_block_top.png")
                onClicked: ShellState.toggleOverlay("launcher")
            }

            Workspaces { anchors.verticalCenter: parent.verticalCenter }

            WindowTitle {
                anchors.verticalCenter: parent.verticalCenter
                width: Math.min(240, Math.max(0, root.width * 0.2))
                visible: Settings.get("bar.showTitle", true) && root.width > 980
            }
        }

        Clock {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            visible: Settings.get("bar.showClock", true)
        }

        Row {
            id: rightRow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            StatsHud {
                anchors.verticalCenter: parent.verticalCenter
                visible: Settings.get("bar.showStats", true) && root.width > 1150
            }

            NetChip { anchors.verticalCenter: parent.verticalCenter }
            VolChip { anchors.verticalCenter: parent.verticalCenter }
            BatChip { anchors.verticalCenter: parent.verticalCenter }
            TrayRow {
                anchors.verticalCenter: parent.verticalCenter
                visible: Settings.get("bar.showTray", true)
            }

            Slot {
                width: 30
                height: 30
                icon: Qt.resolvedUrl("../../assets/textures/icon_basket_left.png")
                active: ShellState.leftBasket
                onClicked: ShellState.toggleBasket("left")
            }
            Slot {
                width: 30
                height: 30
                icon: Qt.resolvedUrl("../../assets/textures/icon_basket_right.png")
                active: ShellState.rightBasket
                onClicked: ShellState.toggleBasket("right")
            }
            Slot {
                width: 30
                height: 30
                icon: Qt.resolvedUrl("../../assets/textures/icon_overview.png")
                onClicked: ShellState.toggleOverlay("overview")
            }
            Slot {
                width: 30
                height: 30
                icon: Qt.resolvedUrl("../../assets/textures/icon_gear.png")
                onClicked: ShellState.toggleOverlay("settings")
            }
            Slot {
                width: 30
                height: 30
                icon: Qt.resolvedUrl("../../assets/textures/icon_power.png")
                onClicked: ShellState.toggleOverlay("power")
            }
        }
    }

    // --------------------------------------------------------------- vertical
    Item {
        visible: root.vertical
        anchors.fill: parent
        anchors.margins: 4

        Column {
            id: topColumn
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            Slot {
                width: 30
                height: 30
                x: Math.round((parent.width - width) / 2)
                icon: Qt.resolvedUrl("../../assets/textures/grass_block_top.png")
                onClicked: ShellState.toggleOverlay("launcher")
            }

            Workspaces {
                vertical: true
                x: Math.round((parent.width - width) / 2)
            }
        }

        Clock {
            compact: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            visible: Settings.get("bar.showClock", true)
        }

        Column {
            id: bottomColumn
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            StatsHud {
                vertical: true
                x: Math.round((parent.width - width) / 2)
                visible: Settings.get("bar.showStats", true)
            }

            NetChip { compact: true; x: Math.round((parent.width - width) / 2) }
            VolChip { compact: true; x: Math.round((parent.width - width) / 2) }
            BatChip { compact: true; x: Math.round((parent.width - width) / 2) }

            TrayRow {
                vertical: true
                x: Math.round((parent.width - width) / 2)
                visible: Settings.get("bar.showTray", true)
            }

            Slot {
                width: 30
                height: 30
                x: Math.round((parent.width - width) / 2)
                icon: Qt.resolvedUrl("../../assets/textures/icon_basket_left.png")
                active: ShellState.leftBasket
                onClicked: ShellState.toggleBasket("left")
            }
            Slot {
                width: 30
                height: 30
                x: Math.round((parent.width - width) / 2)
                icon: Qt.resolvedUrl("../../assets/textures/icon_basket_right.png")
                active: ShellState.rightBasket
                onClicked: ShellState.toggleBasket("right")
            }
            Slot {
                width: 30
                height: 30
                x: Math.round((parent.width - width) / 2)
                icon: Qt.resolvedUrl("../../assets/textures/icon_overview.png")
                onClicked: ShellState.toggleOverlay("overview")
            }
            Slot {
                width: 30
                height: 30
                x: Math.round((parent.width - width) / 2)
                icon: Qt.resolvedUrl("../../assets/textures/icon_gear.png")
                onClicked: ShellState.toggleOverlay("settings")
            }
            Slot {
                width: 30
                height: 30
                x: Math.round((parent.width - width) / 2)
                icon: Qt.resolvedUrl("../../assets/textures/icon_power.png")
                onClicked: ShellState.toggleOverlay("power")
            }
        }
    }
}

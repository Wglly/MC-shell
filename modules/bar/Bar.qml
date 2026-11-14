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

// Bar — one PanelWindow per monitor, laid out like a Minecraft HUD row.
PanelWindow {
    id: root

    // Supplied by the Variants delegate in shell.qml.
    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Theme.barHeight
    color: "transparent"
    exclusiveZone: Theme.barHeight
    exclusionMode: ExclusionMode.Normal

    // ------------------------------------------------------------- background
    McPanel {
        anchors.fill: parent
        bevel: 2
        background: "#17140f"
        texture: Qt.resolvedUrl("../../assets/textures/deepslate.png")
        textureOpacity: 0.85
    }

    // ------------------------------------------------------------------- left
    Row {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Slot {
            width: 30
            height: 30
            icon: Qt.resolvedUrl("../../assets/textures/grass_block_top.png")
            onClicked: ShellState.toggleOverlay("launcher")
        }

        Workspaces { }

        PixelText {
            id: title
            anchors.verticalCenter: parent.verticalCenter
            width: Math.min(260, Math.max(0, root.width * 0.22))
            elide: Text.ElideRight
            text: Compositor.windowTitle !== "" ? Compositor.windowTitle
                : (Compositor.windowAppId !== "" ? Compositor.windowAppId : "")
            color: Theme.textDim
            font.pixelSize: Theme.fontSmall
            visible: root.width > 900
        }
    }

    // ----------------------------------------------------------------- center
    Clock {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    // ------------------------------------------------------------------ right
    Row {
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        StatsHud { visible: root.width > 1100 }

        Chip {
            label: "NET"
            value: netValue
            valueColor: netConnected ? Theme.grass : Theme.red
            onClicked: ShellState.toggleOverlay("control")

            readonly property var conn: {
                var ds = Networking.devices.values;
                for (var i = 0; i < ds.length; i++)
                    if (ds[i].connected)
                        return ds[i];
                return null;
            }
            readonly property bool netConnected: conn !== null
            readonly property string netValue: conn ? "ON" : "OFF"
        }

        Chip {
            label: "VOL"
            value: Audio.label
            valueColor: Audio.muted ? Theme.red : Theme.text
            onClicked: ShellState.toggleOverlay("control")
            onScrolled: delta => Audio.step(delta)
        }

        Chip {
            label: "BAT"
            visible: UPower.displayDevice && UPower.displayDevice.isPresent
            value: UPower.displayDevice ? Math.round(UPower.displayDevice.percentage * 100) + "%" : "--"
            valueColor: UPower.displayDevice && UPower.displayDevice.percentage < 0.2 ? Theme.red : Theme.text
            onClicked: ShellState.toggleOverlay("control")
        }

        TrayRow { }

        Chip {
            label: "PWR"
            valueColor: Theme.gold
            onClicked: ShellState.toggleOverlay("control")
        }
    }
}

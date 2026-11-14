import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// Osd — the XP bar that pops up when you change volume or brightness.
PanelWindow {
    id: root

    visible: ShellState.osdKind !== ""
    color: "transparent"
    implicitWidth: 300
    implicitHeight: 110
    anchors {
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay

    Item {
        anchors.fill: parent

        McPanel {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 26
            width: 280
            height: 54
            background: Theme.cardBg
            texture: Qt.resolvedUrl("../../assets/textures/deepslate.png")
            textureOpacity: 0.6

            Column {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                Row {
                    width: parent.width
                    spacing: 6

                    PixelText {
                        text: ShellState.osdLabel !== "" ? ShellState.osdLabel
                            : (ShellState.osdKind === "volume" ? I18n.t("osd.volume") : I18n.t("osd.brightness"))
                        font.pixelSize: Theme.fontSmall
                        color: Theme.text
                    }
                    Item { width: parent.width - 120; height: 1 }
                    PixelText {
                        text: Math.round(ShellState.osdValue * 100) + "%"
                        font.pixelSize: Theme.fontSmall
                        color: Theme.gold
                    }
                }

                // XP-bar style meter
                Rectangle {
                    width: parent.width
                    height: 12
                    color: "#1b2a10"
                    border.width: 1
                    border.color: "#000000"

                    Rectangle {
                        x: 1
                        y: 1
                        height: parent.height - 2
                        width: Math.max(0, (parent.width - 2) * Util.clamp(ShellState.osdValue, 0, 1))
                        color: ShellState.osdKind === "volume" ? Theme.xp : Theme.gold

                        Rectangle {
                            anchors.top: parent.top
                            width: parent.width
                            height: 3
                            color: "#ffffff"
                            opacity: 0.35
                        }
                    }
                }
            }
        }
    }
}

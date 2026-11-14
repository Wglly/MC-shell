import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// PerfCard — CPU / RAM / load / uptime, the "performance monitor" basket card.
McPanel {
    id: root

    implicitWidth: 250
    implicitHeight: 190
    background: Theme.cardBg
    texture: Theme.texturePath(Settings.get("theme.cardTexture", "oak_planks"))
    textureOpacity: 0.28

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        PixelText {
            text: I18n.t("widget.perfmon")
            font.pixelSize: Theme.fontSmall
            color: Theme.gold
        }

        // CPU meter
        Row {
            width: parent.width
            spacing: 6

            PixelText {
                width: 40
                text: "CPU"
                font.pixelSize: 10
                color: Theme.textDim
            }
            Rectangle {
                width: parent.width - 92
                height: 10
                color: Theme.panelDark
                border.width: 1
                border.color: Theme.outline

                Rectangle {
                    x: 1
                    y: 1
                    height: parent.height - 2
                    width: Math.max(0, (parent.width - 2) * Stats.cpu)
                    color: Stats.cpu > 0.85 ? Theme.red : Theme.xp
                }
            }
            PixelText {
                width: 34
                horizontalAlignment: Text.AlignRight
                text: Math.round(Stats.cpu * 100) + "%"
                font.pixelSize: 10
                color: Theme.text
            }
        }

        // RAM meter
        Row {
            width: parent.width
            spacing: 6

            PixelText {
                width: 40
                text: "RAM"
                font.pixelSize: 10
                color: Theme.textDim
            }
            Rectangle {
                width: parent.width - 92
                height: 10
                color: Theme.panelDark
                border.width: 1
                border.color: Theme.outline

                Rectangle {
                    x: 1
                    y: 1
                    height: parent.height - 2
                    width: Math.max(0, (parent.width - 2) * Stats.mem)
                    color: Stats.mem > 0.9 ? Theme.red : Theme.grass
                }
            }
            PixelText {
                width: 34
                horizontalAlignment: Text.AlignRight
                text: Math.round(Stats.mem * 100) + "%"
                font.pixelSize: 10
                color: Theme.text
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Theme.bevelDark
        }

        PixelText {
            text: "LOAD  " + Stats.load1.toFixed(2) + " / " + Stats.load5.toFixed(2)
            font.pixelSize: 9
            color: Theme.textDim
        }
        PixelText {
            text: "MEM   " + Stats.memUsed.toFixed(1) + " / " + Stats.memTotal.toFixed(1) + " GB"
            font.pixelSize: 9
            color: Theme.textDim
        }
        PixelText {
            text: I18n.t("control.up") + "  " + System.uptimeText()
            font.pixelSize: 9
            color: Theme.textDim
        }
    }
}

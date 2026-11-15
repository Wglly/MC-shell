import QtQuick
import qs.modules.common
import qs.modules.bar
import qs.modules.common.widgets
import qs.services

// StatsCard — CPU / RAM as hearts, drumsticks and XP-style meters.
McPanel {
    id: root

    implicitWidth: 250
    implicitHeight: 160
    background: Theme.cardBg
    texture: Theme.texturePath("stone")
    textureOpacity: 0.28

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Row {
            spacing: 6
            StatsGroup { kind: "cpu"; anchors.verticalCenter: parent.verticalCenter }
        }
        Row {
            spacing: 6
            StatsGroup { kind: "ram"; anchors.verticalCenter: parent.verticalCenter }
        }

        // XP-bar style memory meter
        Rectangle {
            width: parent.width
            height: 10
            color: "#1b2a10"
            border.width: 1
            border.color: "#000000"

            Rectangle {
                x: 1
                y: 1
                height: parent.height - 2
                width: Math.max(0, (parent.width - 2) * Stats.mem)
                color: Theme.xp
            }
        }

        PixelText {
            width: parent.width
            text: Stats.memUsed.toFixed(1) + " / " + Stats.memTotal.toFixed(1) + " GB   "
                  + "UP " + System.uptimeText()
            font.pixelSize: Theme.raw(10)
            color: Theme.cardTextDim
        }
    }
}

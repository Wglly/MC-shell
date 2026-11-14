import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// StatsHud — CPU as hearts and RAM as hunger, Minecraft HUD style.
Row {
    id: root

    spacing: 6

    readonly property int maxIcons: 5

    Row {
        spacing: 1
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: root.maxIcons
            delegate: Image {
                width: 13
                height: 13
                smooth: false
                mipmap: false
                source: index < Math.ceil(Stats.cpu * root.maxIcons)
                    ? Qt.resolvedUrl("../../assets/textures/heart.png")
                    : Qt.resolvedUrl("../../assets/textures/heart_empty.png")
            }
        }

        PixelText {
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: 4
            text: Math.round(Stats.cpu * 100) + "%"
            font.pixelSize: Theme.fontSmall
            color: Stats.cpu > 0.85 ? Theme.red : Theme.text
        }
    }

    Row {
        spacing: 1
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: root.maxIcons
            delegate: Image {
                width: 13
                height: 13
                smooth: false
                mipmap: false
                opacity: index < Math.ceil(Stats.mem * root.maxIcons) ? 1.0 : 0.35
                source: Qt.resolvedUrl("../../assets/textures/hunger.png")
            }
        }

        PixelText {
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: 4
            text: Math.round(Stats.mem * 100) + "%"
            font.pixelSize: Theme.fontSmall
            color: Stats.mem > 0.9 ? Theme.red : Theme.text
        }
    }
}

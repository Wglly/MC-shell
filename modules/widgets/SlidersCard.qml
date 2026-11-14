import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// SlidersCard — the end4-style volume + brightness basket.
McPanel {
    id: root

    implicitWidth: 250
    implicitHeight: 170
    background: Theme.cardBg
    texture: Theme.texturePath(Settings.get("theme.cardTexture", "oak_planks"))
    textureOpacity: 0.24

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        PixelText {
            text: I18n.t("widget.sliders")
            font.pixelSize: Theme.fontSmall
            color: Theme.cardTitle
        }

        Row {
            width: parent.width
            spacing: 6

            PixelText {
                width: 42
                anchors.verticalCenter: parent.verticalCenter
                text: "VOL"
                font.pixelSize: 10
                color: Theme.cardTextDim
            }
            McSlider {
                width: parent.width - 88
                value: Audio.volume
                onMoved: v => Audio.setVolume(v)
            }
            McButton {
                width: 34
                height: 24
                label: Audio.muted ? "X" : "ON"
                checked: Audio.muted
                onClicked: Audio.toggleMute()
            }
        }

        Row {
            width: parent.width
            spacing: 6

            PixelText {
                width: 42
                anchors.verticalCenter: parent.verticalCenter
                text: "BRI"
                font.pixelSize: 10
                color: Theme.cardTextDim
            }
            McSlider {
                width: parent.width - 88
                value: System.brightness
                fillColor: Theme.gold
                onMoved: v => System.setBrightness(v)
            }
            PixelText {
                width: 34
                anchors.verticalCenter: parent.verticalCenter
                text: Math.round(System.brightness * 100) + "%"
                font.pixelSize: 9
                color: Theme.cardTextDim
            }
        }
    }
}

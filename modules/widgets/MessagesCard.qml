import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// MessagesCard — recent notifications, with do-not-disturb and clear.
McPanel {
    id: root

    implicitWidth: 250
    implicitHeight: 230
    background: Theme.cardBg
    texture: Theme.texturePath(Settings.get("theme.cardTexture", "oak_planks"))
    textureOpacity: 0.24

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6

        Row {
            width: parent.width
            spacing: 4

            PixelText {
                text: I18n.t("widget.messages")
                font.pixelSize: Theme.fs(Theme.fontSmall)
                color: Theme.cardTitle
            }
            Item { width: parent.width - 150; height: 1 }
            McButton {
                width: 56
                height: 24
                label: "DND"
                checked: Notifs.dnd
                onClicked: Notifs.dnd = !Notifs.dnd
            }
            McButton {
                width: 44
                height: 24
                label: "X"
                onClicked: Notifs.clearHistory()
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Theme.bevelDark
        }

        PixelText {
            visible: Notifs.history.length === 0
            text: I18n.t("widget.messages.empty")
            font.pixelSize: Theme.raw(9)
            color: Theme.cardTextDim
        }

        Repeater {
            model: Notifs.history.slice(0, 5)

            delegate: Column {
                width: parent.width
                spacing: 1

                PixelText {
                    width: parent.width
                    elide: Text.ElideRight
                    text: modelData.app.toUpperCase()
                    font.pixelSize: Theme.raw(8)
                    color: Theme.grass
                }
                PixelText {
                    width: parent.width
                    elide: Text.ElideRight
                    text: modelData.summary
                    font.pixelSize: Theme.raw(10)
                    color: Theme.cardText
                }
            }
        }
    }
}

import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// WidgetManagerCard — add/remove desktop widgets straight from the basket.
McPanel {
    id: root

    implicitWidth: 250
    implicitHeight: 300
    background: Theme.cardBg
    texture: Theme.texturePath(Settings.get("theme.cardTexture", "oak_planks"))
    textureOpacity: 0.24

    readonly property var keys: ["clock", "weather", "visualizer", "calendar", "stats", "media", "user"]

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 4

        PixelText {
            text: I18n.t("widget.widgetmanager")
            font.pixelSize: Theme.fs(Theme.fontSmall)
            color: Theme.cardTitle
        }
        Rectangle {
            width: parent.width
            height: 1
            color: Theme.bevelDark
        }

        Repeater {
            model: root.keys

            delegate: Row {
                width: parent.width
                height: 24
                spacing: 4

                PixelText {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 62
                    elide: Text.ElideRight
                    text: I18n.t("widget." + modelData)
                    font.pixelSize: 10
                    color: Theme.cardText
                }
                McButton {
                    width: 56
                    height: 22
                    label: Settings.get("widgets." + modelData + ".enabled", false) ? I18n.t("common.on") : I18n.t("common.off")
                    checked: Settings.get("widgets." + modelData + ".enabled", false)
                    onClicked: Settings.toggle("widgets." + modelData + ".enabled")
                }
            }
        }
    }
}

import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// ThemePage — colours, block textures and UI scale.
Column {
    id: page

    width: parent ? parent.width : 560
    spacing: 10

    readonly property var textures: ["deepslate", "stone", "dirt", "cobblestone", "oak_planks", "bedrock"]

    PixelText {
        text: I18n.t("settings.tab.theme")
        font.pixelSize: Theme.fontLarge
        color: Theme.textOnPanel
        styleColor: "#ffffff"
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.theme.accent")

        Row {
            anchors.right: parent.right
            spacing: 8

            Rectangle {
                width: 24
                height: 24
                color: Theme.grass
                border.width: 2
                border.color: "#000000"
            }
            McTextField {
                inputWidth: 110
                text: Settings.get("theme.accent", "#5fbf4f")
                onEdited: value => Settings.set("theme.accent", value)
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.theme.gold")

        Row {
            anchors.right: parent.right
            spacing: 8

            Rectangle {
                width: 24
                height: 24
                color: Theme.gold
                border.width: 2
                border.color: "#000000"
            }
            McTextField {
                inputWidth: 110
                text: Settings.get("theme.gold", "#ffcc4d")
                onEdited: value => Settings.set("theme.gold", value)
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.theme.texture")

        Row {
            anchors.right: parent.right
            spacing: 3

            Repeater {
                model: page.textures
                delegate: McButton {
                    implicitWidth: 64
                    label: modelData.substring(0, 3).toUpperCase()
                    checked: Settings.get("theme.barTexture", "deepslate") === modelData
                    onClicked: Settings.set("theme.barTexture", modelData)
                }
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.theme.panelTexture")

        Row {
            anchors.right: parent.right
            spacing: 3

            Repeater {
                model: page.textures
                delegate: McButton {
                    implicitWidth: 64
                    label: modelData.substring(0, 3).toUpperCase()
                    checked: Settings.get("theme.panelTexture", "dirt") === modelData
                    onClicked: Settings.set("theme.panelTexture", modelData)
                }
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.theme.scale")

        Row {
            anchors.right: parent.right
            spacing: 8

            McSlider {
                width: 168
                value: (Settings.get("theme.scale", 1.0) - 0.8) / 0.6
                onMoved: v => Settings.set("theme.scale", Math.round((0.8 + v * 0.6) * 100) / 100)
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 44
                text: Settings.get("theme.scale", 1.0).toFixed(2) + "x"
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: "#ffffff"
            }
        }
    }

    // texture preview strip
    Row {
        width: parent.width
        spacing: 4

        Repeater {
            model: page.textures
            delegate: Rectangle {
                width: 54
                height: 54
                border.width: 1
                border.color: "#000000"

                Image {
                    anchors.fill: parent
                    source: Theme.texturePath(modelData)
                    fillMode: Image.Tile
                    smooth: false
                    mipmap: false
                }
            }
        }
    }

    PixelText {
        width: parent.width
        text: I18n.t("settings.theme.note")
        font.pixelSize: 9
        color: "#5a5a5a"
        styleColor: "#ffffff"
        wrapMode: Text.Wrap
    }
}

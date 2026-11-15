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
    readonly property string activePreset: Settings.get("theme.preset", "classic")

    function p(key, name, fallback) {
        var presets = Settings.presets;
        var chosen = presets[name] || presets.classic;
        return chosen[key] !== undefined ? chosen[key] : fallback;
    }
    function presetBg(name) { return p("cardBg", name, "#1c1712"); }
    function presetTexture(name) { return p("panelTexture", name, "dirt"); }
    function presetAccent(name) { return p("accent", name, "#5fbf4f"); }
    function presetText(name) { return p("text", name, "#f4f4f4"); }

    PixelText {
        text: I18n.t("settings.tab.theme")
        font.pixelSize: Theme.fontLarge
        color: Theme.textOnPanel
        styleColor: Theme.panelTextShadow
    }

    PixelText {
        text: I18n.t("settings.theme.presets")
        font.pixelSize: Theme.fontSmall
        color: Theme.textHints
        styleColor: Theme.panelTextShadow
    }

    Flow {
        width: parent.width
        spacing: 6

        Repeater {
            model: ["classic", "cave", "snow", "desert", "village", "win7", "winxp", "win95"]

            delegate: Item {
                width: 106
                height: 84

                McPanel {
                    anchors.fill: parent
                    bevel: 2
                    background: page.presetBg(modelData)
                    texture: Theme.texturePath(page.presetTexture(modelData))
                    textureOpacity: 0.55
                    outlineColor: root.activePreset === modelData ? Theme.gold : Theme.outline
                }

                Column {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -6
                    spacing: 3

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 22
                        height: 22
                        color: page.presetAccent(modelData)
                        border.width: 2
                        border.color: "#000000"
                    }
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 18
                    color: "#000000"
                    opacity: 0.62
                }
                PixelText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 3
                    width: parent.width - 6
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    text: I18n.t("theme." + modelData)
                    font.pixelSize: Theme.raw(8)
                    color: "#ffffff"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Settings.applyPreset(modelData)
                }
            }
        }
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
                styleColor: Theme.panelTextShadow
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

    SettingRow {
        width: parent.width
        label: I18n.t("settings.theme.glass")

        Row {
            anchors.right: parent.right
            spacing: 8
            McSlider {
                width: 150
                value: (Settings.get("theme.glassOpacity", 0.8) - 0.1) / 0.9
                onMoved: v => Settings.set("theme.glassOpacity", Math.round((0.1 + v * 0.9) * 100) / 100)
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 48
                text: Math.round(Settings.get("theme.glassOpacity", 0.8) * 100) + "%"
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
        }
    }

    PixelText {
        width: parent.width
        text: I18n.t("settings.theme.note")
        font.pixelSize: Theme.raw(9)
        color: Theme.textHints
        styleColor: Theme.panelTextShadow
        wrapMode: Text.Wrap
    }
}

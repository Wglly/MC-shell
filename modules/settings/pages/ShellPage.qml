import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// ShellPage — the quick "shell control" panel: live geometry for the bar, the
// dock and both side baskets, without digging through the other tabs.
Column {
    id: page

    width: parent ? parent.width : 560
    spacing: 10

    function section(title) {
        return title;
    }

    PixelText {
        text: I18n.t("settings.shell.title")
        font.pixelSize: Theme.fontLarge
        color: Theme.textOnPanel
        styleColor: Theme.panelTextShadow
    }

    PixelText {
        text: I18n.t("settings.shell.hint")
        font.pixelSize: 9
        color: Theme.textHints
        styleColor: Theme.panelTextShadow
    }

    // ------------------------------------------------------------------ BAR
    PixelText {
        text: I18n.t("settings.tab.bar")
        font.pixelSize: Theme.fontSmall
        color: Theme.gold
        styleColor: Theme.panelTextShadow
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.bar.position")

        Row {
            anchors.right: parent.right
            spacing: 4

            Repeater {
                model: ["top", "bottom", "left", "right"]
                delegate: McButton {
                    implicitWidth: 72
                    label: I18n.t("pos." + modelData)
                    checked: Settings.get("bar.position", "top") === modelData
                    onClicked: Settings.set("bar.position", modelData)
                }
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.shell.barHeight")

        Row {
            anchors.right: parent.right
            spacing: 8

            McSlider {
                width: 200
                value: (Settings.get("bar.thickness", 40) - 32) / 48
                onMoved: v => Settings.set("bar.thickness", Math.round(32 + v * 48))
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 44
                text: Settings.get("bar.thickness", 40) + "px"
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
        }
    }

    // ----------------------------------------------------------------- DOCK
    PixelText {
        text: I18n.t("settings.tab.dock")
        font.pixelSize: Theme.fontSmall
        color: Theme.gold
        styleColor: Theme.panelTextShadow
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.dock.position")

        Row {
            anchors.right: parent.right
            spacing: 4

            Repeater {
                model: ["bottom", "top", "left", "right"]
                delegate: McButton {
                    implicitWidth: 72
                    label: I18n.t("pos." + modelData)
                    checked: Settings.get("dock.position", "bottom") === modelData
                    onClicked: Settings.set("dock.position", modelData)
                }
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.dock.iconSize")

        Row {
            anchors.right: parent.right
            spacing: 8

            McSlider {
                width: 200
                value: (Settings.get("dock.iconSize", 42) - 28) / 40
                onMoved: v => Settings.set("dock.iconSize", Math.round(28 + v * 40))
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 44
                text: Settings.get("dock.iconSize", 42) + "px"
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.shell.dockSize")

        Row {
            anchors.right: parent.right
            spacing: 8

            McSlider {
                width: 120
                value: (Settings.get("dock.columns", 9) - 1) / 11
                onMoved: v => Settings.set("dock.columns", Math.round(1 + v * 11))
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 26
                text: "×" + Settings.get("dock.columns", 9)
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
            McSlider {
                width: 120
                value: (Settings.get("dock.rows", 3) - 1) / 5
                onMoved: v => Settings.set("dock.rows", Math.round(1 + v * 5))
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 26
                text: Settings.get("dock.rows", 3) + ""
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
        }
    }

    // ------------------------------------------------------------- SIDEBARS
    PixelText {
        text: I18n.t("settings.tab.sidebars")
        font.pixelSize: Theme.fontSmall
        color: Theme.gold
        styleColor: Theme.panelTextShadow
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.sidebars.left")

        Row {
            anchors.right: parent.right
            spacing: 8

            McButton {
                implicitWidth: 64
                label: Settings.get("sidebars.left.enabled", true) ? I18n.t("common.on") : I18n.t("common.off")
                checked: Settings.get("sidebars.left.enabled", true)
                onClicked: Settings.toggle("sidebars.left.enabled")
            }
            McSlider {
                width: 120
                value: (Settings.get("sidebars.left.width", 260) - 160) / 200
                onMoved: v => Settings.set("sidebars.left.width", Math.round(160 + v * 200))
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 46
                text: Settings.get("sidebars.left.width", 260) + "px"
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.sidebars.right")

        Row {
            anchors.right: parent.right
            spacing: 8

            McButton {
                implicitWidth: 64
                label: Settings.get("sidebars.right.enabled", true) ? I18n.t("common.on") : I18n.t("common.off")
                checked: Settings.get("sidebars.right.enabled", true)
                onClicked: Settings.toggle("sidebars.right.enabled")
            }
            McSlider {
                width: 120
                value: (Settings.get("sidebars.right.width", 260) - 160) / 200
                onMoved: v => Settings.set("sidebars.right.width", Math.round(160 + v * 200))
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 46
                text: Settings.get("sidebars.right.width", 260) + "px"
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
        }
    }

    PixelText {
        width: parent.width
        text: I18n.t("settings.shell.note")
        font.pixelSize: 9
        color: Theme.textHints
        styleColor: Theme.panelTextShadow
        wrapMode: Text.Wrap
    }
}

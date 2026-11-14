import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// BarPage — bar visibility, edge, thickness and which HUD parts to show.
Column {
    id: page

    width: parent ? parent.width : 560
    spacing: 10

    PixelText {
        text: I18n.t("settings.tab.bar")
        font.pixelSize: Theme.fontLarge
        color: Theme.textOnPanel
        styleColor: "#ffffff"
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.bar.visible")

        McButton {
            anchors.right: parent.right
            label: Settings.get("bar.visible", true) ? I18n.t("common.on") : I18n.t("common.off")
            checked: Settings.get("bar.visible", true)
            onClicked: Settings.toggle("bar.visible")
        }
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
                    implicitWidth: 76
                    label: I18n.t("pos." + modelData)
                    checked: Settings.get("bar.position", "top") === modelData
                    onClicked: Settings.set("bar.position", modelData)
                }
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.bar.thickness")

        Row {
            anchors.right: parent.right
            spacing: 8

            McSlider {
                width: 168
                value: (Settings.get("bar.thickness", 40) - 36) / 36
                onMoved: v => Settings.set("bar.thickness", Math.round(36 + v * 36))
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 40
                text: Settings.get("bar.thickness", 40) + "px"
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: "#ffffff"
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.bar.stats")

        McButton {
            anchors.right: parent.right
            label: Settings.get("bar.showStats", true) ? I18n.t("common.on") : I18n.t("common.off")
            checked: Settings.get("bar.showStats", true)
            onClicked: Settings.toggle("bar.showStats")
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.bar.tray")

        McButton {
            anchors.right: parent.right
            label: Settings.get("bar.showTray", true) ? I18n.t("common.on") : I18n.t("common.off")
            checked: Settings.get("bar.showTray", true)
            onClicked: Settings.toggle("bar.showTray")
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.bar.title")

        McButton {
            anchors.right: parent.right
            label: Settings.get("bar.showTitle", true) ? I18n.t("common.on") : I18n.t("common.off")
            checked: Settings.get("bar.showTitle", true)
            onClicked: Settings.toggle("bar.showTitle")
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.bar.clock")

        McButton {
            anchors.right: parent.right
            label: Settings.get("bar.showClock", true) ? I18n.t("common.on") : I18n.t("common.off")
            checked: Settings.get("bar.showClock", true)
            onClicked: Settings.toggle("bar.showClock")
        }
    }

    PixelText {
        width: parent.width
        text: I18n.t("settings.bar.note")
        font.pixelSize: 9
        color: "#5a5a5a"
        styleColor: "#ffffff"
        wrapMode: Text.Wrap
    }
}

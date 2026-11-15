import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// OverviewPage — desktop overview (window mover) configuration.
Column {
    id: page

    width: parent ? parent.width : 560
    spacing: 10

    PixelText {
        text: I18n.t("settings.tab.overview")
        font.pixelSize: Theme.fontLarge
        color: Theme.textOnPanel
        styleColor: Theme.panelTextShadow
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.overview.enabled")

        McButton {
            anchors.right: parent.right
            label: Settings.get("overview.enabled", true) ? I18n.t("common.on") : I18n.t("common.off")
            checked: Settings.get("overview.enabled", true)
            onClicked: Settings.toggle("overview.enabled")
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.overview.columns")

        Row {
            anchors.right: parent.right
            spacing: 8

            McSlider {
                width: 168
                value: (Settings.get("overview.columns", 3) - 1) / 5
                onMoved: v => Settings.set("overview.columns", Math.round(1 + v * 5))
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 30
                text: Settings.get("overview.columns", 3)
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.overview.desktops")

        Row {
            anchors.right: parent.right
            spacing: 8

            McSlider {
                width: 168
                value: (Settings.get("overview.desktops", 6) - 1) / 11
                onMoved: v => Settings.set("overview.desktops", Math.round(1 + v * 11))
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 30
                text: Settings.get("overview.desktops", 6)
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.overview.titles")

        McButton {
            anchors.right: parent.right
            label: Settings.get("overview.titles", true) ? I18n.t("common.on") : I18n.t("common.off")
            checked: Settings.get("overview.titles", true)
            onClicked: Settings.toggle("overview.titles")
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.overview.backdrop")

        Row {
            anchors.right: parent.right
            spacing: 8

            McSlider {
                width: 168
                fillColor: Theme.gold
                value: (Settings.get("overview.backdrop", 0.72) - 0.3) / 0.65
                onMoved: v => Settings.set("overview.backdrop", Math.round((0.3 + v * 0.65) * 100) / 100)
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 40
                text: Math.round(Settings.get("overview.backdrop", 0.72) * 100) + "%"
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
        }
    }

    PixelText {
        width: parent.width
        text: I18n.t("settings.overview.note")
        font.pixelSize: Theme.raw(9)
        color: Theme.textHints
        styleColor: Theme.panelTextShadow
        wrapMode: Text.Wrap
    }
}

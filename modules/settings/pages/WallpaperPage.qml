import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// WallpaperPage — our own background layer (works on Hyprland and niri).
Column {
    id: page

    width: parent ? parent.width : 560
    spacing: 10

    PixelText {
        text: I18n.t("settings.tab.wallpaper")
        font.pixelSize: Theme.fontLarge
        color: Theme.textOnPanel
        styleColor: Theme.panelTextShadow
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.wallpaper.enabled")

        McButton {
            anchors.right: parent.right
            label: Settings.get("wallpaper.enabled", false) ? I18n.t("common.on") : I18n.t("common.off")
            checked: Settings.get("wallpaper.enabled", false)
            onClicked: Settings.toggle("wallpaper.enabled")
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.wallpaper.path")
        hint: I18n.t("settings.wallpaper.pathHint")

        McTextField {
            anchors.right: parent.right
            inputWidth: 320
            text: Settings.get("wallpaper.path", "")
            placeholder: I18n.t("settings.wallpaper.pathHint")
            onEdited: value => Settings.set("wallpaper.path", value)
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.wallpaper.color")

        McTextField {
            anchors.right: parent.right
            inputWidth: 120
            text: Settings.get("wallpaper.color", "#101418")
            onEdited: value => Settings.set("wallpaper.color", value)
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.wallpaper.fill")

        Row {
            anchors.right: parent.right
            spacing: 4

            Repeater {
                model: ["fill", "fit", "tile"]
                delegate: McButton {
                    implicitWidth: 72
                    label: modelData.toUpperCase()
                    checked: Settings.get("wallpaper.fillMode", "fill") === modelData
                    onClicked: Settings.set("wallpaper.fillMode", modelData)
                }
            }
        }
    }

    PixelText {
        width: parent.width
        text: I18n.t("settings.wallpaper.note")
        font.pixelSize: Theme.raw(9)
        color: Theme.textHints
        styleColor: Theme.panelTextShadow
        wrapMode: Text.Wrap
    }
}

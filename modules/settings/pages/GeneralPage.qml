import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// GeneralPage — language + shortcut cheat sheet.
Column {
    id: page

    width: parent ? parent.width : 560
    spacing: 10

    PixelText {
        text: I18n.t("settings.general.language")
        font.pixelSize: Theme.fontLarge
        color: Theme.textOnPanel
        styleColor: "#ffffff"
    }

    Row {
        spacing: 6

        Repeater {
            model: [
                { value: "auto", key: "settings.language.auto" },
                { value: "en", key: "" },
                { value: "zh_CN", key: "" },
                { value: "zh_TW", key: "" }
            ]

            delegate: McButton {
                implicitWidth: 92
                height: 30
                label: modelData.value === "en" ? "English"
                    : modelData.value === "zh_CN" ? "简体中文"
                    : modelData.value === "zh_TW" ? "繁體中文"
                    : I18n.t("settings.language.auto")
                checked: Settings.get("language", "auto") === modelData.value
                onClicked: Settings.set("language", modelData.value)
            }
        }
    }

    PixelText {
        text: I18n.t("settings.general.languageHint")
        font.pixelSize: 9
        color: "#6a6a6a"
        styleColor: "#ffffff"
    }

    Rectangle { width: parent.width; height: 2; color: "#8a8a8a" }

    PixelText {
        text: I18n.t("settings.general.shortcuts")
        font.pixelSize: Theme.fontLarge
        color: Theme.textOnPanel
        styleColor: "#ffffff"
    }

    PixelText {
        text: I18n.t("settings.general.hint")
        font.pixelSize: 10
        color: "#4a4a4a"
        styleColor: "#ffffff"
    }

    McPanel {
        width: parent.width
        height: 132
        background: "#1d1d1d"
        texture: Qt.resolvedUrl("../../../assets/textures/deepslate.png")
        textureOpacity: 0.5

        PixelText {
            anchors.fill: parent
            anchors.margins: 10
            font.pixelSize: 10
            color: Theme.textDim
            wrapMode: Text.Wrap
            text: "mc-shell ipc call shell launcher\n"
                + "mc-shell ipc call shell control\n"
                + "mc-shell ipc call shell settings\n"
                + "mc-shell ipc call shell power\n"
                + "mc-shell ipc call shell volumeUp / volumeDown / volumeMute\n"
                + "mc-shell ipc call shell brightnessUp / brightnessDown"
        }
    }

    Row {
        spacing: 8

        McButton {
            label: I18n.t("common.reset")
            accentColor: Theme.red
            onClicked: Settings.reset()
        }
    }
}

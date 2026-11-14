import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// DockPage — the player-inventory app basket.
Column {
    id: page

    width: parent ? parent.width : 560
    spacing: 10

    PixelText {
        text: I18n.t("settings.tab.dock")
        font.pixelSize: Theme.fontLarge
        color: Theme.textOnPanel
        styleColor: "#ffffff"
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.dock.visible")

        McButton {
            anchors.right: parent.right
            label: Settings.get("dock.visible", true) ? I18n.t("common.on") : I18n.t("common.off")
            checked: Settings.get("dock.visible", true)
            onClicked: Settings.toggle("dock.visible")
        }
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
                    implicitWidth: 76
                    label: I18n.t("pos." + modelData)
                    checked: Settings.get("dock.position", "bottom") === modelData
                    onClicked: Settings.set("dock.position", modelData)
                }
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.dock.autohide")

        McButton {
            anchors.right: parent.right
            label: Settings.get("dock.autoHide", false) ? I18n.t("common.on") : I18n.t("common.off")
            checked: Settings.get("dock.autoHide", false)
            onClicked: Settings.toggle("dock.autoHide")
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.dock.iconSize")

        Row {
            anchors.right: parent.right
            spacing: 8

            McSlider {
                width: 168
                value: (Settings.get("dock.iconSize", 42) - 28) / 36
                onMoved: v => Settings.set("dock.iconSize", Math.round(28 + v * 36))
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 44
                text: Settings.get("dock.iconSize", 42) + "px"
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: "#ffffff"
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("settings.dock.pinned")
        hint: I18n.t("settings.dock.pinnedHint")

        McTextField {
            anchors.right: parent.right
            inputWidth: 320
            text: Settings.get("dock.pinned", []).join(", ")
            placeholder: "firefox.desktop, code.desktop"
            onEdited: value => {
                var parts = value.split(",");
                var out = [];
                for (var i = 0; i < parts.length; i++) {
                    var v = parts[i].trim();
                    if (v !== "")
                        out.push(v);
                }
                Settings.set("dock.pinned", out);
            }
        }
    }

    McPanel {
        width: parent.width
        height: 96
        background: "#6b4a24"
        texture: Theme.texturePath("oak_planks")
        textureOpacity: 0.95

        PixelText {
            anchors.centerIn: parent
            text: Settings.get("dock.position", "bottom").toUpperCase()
                  + "   " + Settings.get("dock.pinned", []).length + " APPS"
            font.pixelSize: Theme.fontSmall
            color: Theme.text
        }
    }
}

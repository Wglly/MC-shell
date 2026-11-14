import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// BarPage — bar visibility, edge, thickness and which HUD parts to show.
Column {
    id: page

    width: parent ? parent.width : 560
    spacing: 10

    readonly property var allKeys: ["launcher", "workspaces", "title", "clock", "media", "stats",
                                    "net", "volume", "battery", "tray", "user", "basketLeft",
                                    "basketRight", "overview", "dashboard", "settings", "power"]

    function sectionsCopy() {
        var sec = Settings.get("bar.sections", null) || {};
        return {
            left: (sec.left || []).slice(),
            center: (sec.center || []).slice(),
            right: (sec.right || []).slice()
        };
    }

    function sectionOf(key) {
        var sec = page.sectionsCopy();
        if (sec.left.indexOf(key) >= 0) return "left";
        if (sec.center.indexOf(key) >= 0) return "center";
        if (sec.right.indexOf(key) >= 0) return "right";
        return "";
    }

    function moveTo(key, section) {
        var sec = page.sectionsCopy();
        ["left", "center", "right"].forEach(function (s) {
            var i = sec[s].indexOf(key);
            if (i >= 0)
                sec[s].splice(i, 1);
        });
        if (section !== "")
            sec[section].push(key);
        Settings.set("bar.sections", sec);
    }

    PixelText {
        text: I18n.t("settings.tab.bar")
        font.pixelSize: Theme.fontLarge
        color: Theme.textOnPanel
        styleColor: Theme.panelTextShadow
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
                styleColor: Theme.panelTextShadow
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
        text: I18n.t("settings.bar.sections")
        font.pixelSize: Theme.fontSmall
        color: Theme.gold
        styleColor: Theme.panelTextShadow
    }

    PixelText {
        width: parent.width
        text: I18n.t("settings.bar.sectionsHint")
        font.pixelSize: 9
        color: Theme.textHints
        styleColor: Theme.panelTextShadow
        wrapMode: Text.Wrap
    }

    Repeater {
        model: page.allKeys

        delegate: SettingRow {
            id: rowItem
            width: page.width
            label: I18n.t("bar.item." + modelData)
            property string keyName: modelData

            Row {
                anchors.right: parent.right
                spacing: 4

                McButton {
                    implicitWidth: 44
                    label: Settings.get("bar.items." + rowItem.keyName, true) === true
                        ? I18n.t("common.on") : I18n.t("common.off")
                    checked: Settings.get("bar.items." + rowItem.keyName, true) === true
                    onClicked: Settings.toggle("bar.items." + rowItem.keyName)
                }

                Repeater {
                    model: ["left", "center", "right"]

                    delegate: McButton {
                        implicitWidth: 62
                        label: modelData === "left" ? I18n.t("settings.bar.sectionLeft")
                            : (modelData === "center" ? I18n.t("settings.bar.sectionCenter")
                            : I18n.t("settings.bar.sectionRight"))
                        checked: page.sectionOf(rowItem.keyName) === modelData
                        onClicked: page.moveTo(rowItem.keyName, modelData)
                    }
                }
            }
        }
    }

    PixelText {
        width: parent.width
        text: I18n.t("settings.bar.note")
        font.pixelSize: 9
        color: Theme.textHints
        styleColor: Theme.panelTextShadow
        wrapMode: Text.Wrap
    }
}

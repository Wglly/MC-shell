import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// SidebarsPage — the left/right baskets and the widgets they carry.
Column {
    id: page

    width: parent ? parent.width : 560
    spacing: 10

    readonly property var allWidgets: ["stats", "calendar", "music", "weather", "clock"]

    function hasWidget(side, name) {
        var list = Settings.get("sidebars." + side + ".widgets", []);
        return list.indexOf(name) >= 0;
    }

    function toggleWidget(side, name) {
        var list = Settings.get("sidebars." + side + ".widgets", []).slice();
        var i = list.indexOf(name);
        if (i >= 0)
            list.splice(i, 1);
        else
            list.push(name);
        Settings.set("sidebars." + side + ".widgets", list);
    }

    PixelText {
        text: I18n.t("settings.tab.sidebars")
        font.pixelSize: Theme.fontLarge
        color: Theme.textOnPanel
        styleColor: "#ffffff"
    }

    Repeater {
        model: ["left", "right"]

        delegate: Column {
            width: page.width
            spacing: 8
            property string sideName: modelData

            PixelText {
                text: I18n.t("settings.sidebars." + modelData)
                font.pixelSize: Theme.fontSmall
                color: Theme.gold
                styleColor: "#ffffff"
            }

            SettingRow {
                width: page.width
                label: I18n.t("settings.sidebars.enabled")

                McButton {
                    anchors.right: parent.right
                    label: Settings.get("sidebars." + sideName + ".enabled", false) ? I18n.t("common.on") : I18n.t("common.off")
                    checked: Settings.get("sidebars." + sideName + ".enabled", false)
                    onClicked: Settings.toggle("sidebars." + sideName + ".enabled")
                }
            }

            SettingRow {
                width: page.width
                label: I18n.t("settings.sidebars.width")

                Row {
                    anchors.right: parent.right
                    spacing: 8

                    McSlider {
                        width: 150
                        value: (Settings.get("sidebars." + sideName + ".width", 220) - 160) / 160
                        onMoved: v => Settings.set("sidebars." + sideName + ".width", Math.round(160 + v * 160))
                    }
                    PixelText {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 44
                        text: Settings.get("sidebars." + sideName + ".width", 220) + "px"
                        font.pixelSize: Theme.fontSmall
                        color: Theme.textOnPanel
                        styleColor: "#ffffff"
                    }
                }
            }

            SettingRow {
                width: page.width
                label: I18n.t("settings.sidebars.widgets")

                Row {
                    anchors.right: parent.right
                    spacing: 3

                    Repeater {
                        model: page.allWidgets
                        delegate: McButton {
                            implicitWidth: 82
                            label: I18n.t("widget." + modelData)
                            checked: page.hasWidget(sideName, modelData)
                            onClicked: page.toggleWidget(sideName, modelData)
                        }
                    }
                }
            }

            Rectangle { width: page.width; height: 1; color: "#9a9a9a" }
        }
    }

    PixelText {
        width: parent.width
        text: I18n.t("settings.sidebars.note")
        font.pixelSize: 9
        color: "#5a5a5a"
        styleColor: "#ffffff"
        wrapMode: Text.Wrap
    }
}

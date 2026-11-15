import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// SidebarsPage — which widgets each basket carries, plus width/visibility.
Column {
    id: page

    width: parent ? parent.width : 560
    spacing: 8

    readonly property var allWidgets: ["stats", "calendar", "music", "weather", "clock", "media", "user",
                                       "perfmon", "wallpaper", "messages", "widgetmanager", "sliders", "toggles", "capture"]

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
        styleColor: Theme.panelTextShadow
    }

    Repeater {
        model: ["left", "right"]

        delegate: Column {
            width: page.width
            spacing: 6
            property string sideName: modelData

            PixelText {
                text: I18n.t("settings.sidebars." + sideName)
                font.pixelSize: Theme.fontSmall
                color: Theme.gold
                styleColor: Theme.panelTextShadow
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
                        width: 140
                        value: (Settings.get("sidebars." + sideName + ".width", 260) - 160) / 200
                        onMoved: v => Settings.set("sidebars." + sideName + ".width", Math.round(160 + v * 200))
                    }
                    PixelText {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 48
                        text: Settings.get("sidebars." + sideName + ".width", 260) + "px"
                        font.pixelSize: Theme.fontSmall
                        color: Theme.textOnPanel
                        styleColor: Theme.panelTextShadow
                    }
                }
            }

            PixelText {
                text: I18n.t("settings.sidebars.widgets")
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }

            Grid {
                width: page.width
                columns: 4
                spacing: 3

                Repeater {
                    model: page.allWidgets
                    delegate: McButton {
                        width: 128
                        height: 26
                        label: I18n.t("widget." + modelData)
                        checked: page.hasWidget(sideName, modelData)
                        onClicked: page.toggleWidget(sideName, modelData)
                    }
                }
            }

            Rectangle {
                width: page.width
                height: 1
                color: Theme.bevelDark
            }
        }
    }

    SettingRow {
        width: page.width
        label: I18n.t("settings.sidebars.close")

        Row {
            anchors.right: parent.right
            spacing: 6
            McButton {
                implicitWidth: 120
                label: I18n.t("settings.sidebars.closeClick")
                checked: Settings.get("sidebars.closeMode", "click") === "click"
                onClicked: Settings.set("sidebars.closeMode", "click")
            }
            McButton {
                implicitWidth: 130
                label: I18n.t("settings.sidebars.closeHover")
                checked: Settings.get("sidebars.closeMode", "hover") === "hover"
                onClicked: Settings.set("sidebars.closeMode", "hover")
            }
        }
    }

    PixelText {
        width: parent.width
        text: I18n.t("settings.sidebars.note")
        font.pixelSize: 9
        color: Theme.textHints
        styleColor: Theme.panelTextShadow
        wrapMode: Text.Wrap
    }
}

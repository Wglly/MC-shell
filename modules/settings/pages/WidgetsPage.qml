import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// WidgetsPage — enable / configure the cards that live on the wallpaper.
Column {
    id: page

    width: parent ? parent.width : 560
    spacing: 8

    readonly property var widgetKeys: ["clock", "weather", "visualizer", "calendar", "stats", "media", "user"]

    function resetPosition(key) {
        var defaults = { clock: [0.06, 0.10], weather: [0.06, 0.32], visualizer: [0.06, 0.54],
                         calendar: [0.06, 0.76], stats: [0.76, 0.10],
                         media: [0.06, 0.66], user: [0.76, 0.30] };
        var d = defaults[key];
        if (!d)
            return;
        Settings.set("widgets." + key + ".x", d[0]);
        Settings.set("widgets." + key + ".y", d[1]);
    }

    SettingRow {
        width: page.width
        label: I18n.t("settings.widgets.scale")

        Row {
            anchors.right: parent.right
            spacing: 8

            McSlider {
                width: 150
                value: (Settings.get("widgets.scale", 1.0) - 0.6) / 1.2
                onMoved: v => Settings.set("widgets.scale", Math.round((0.6 + v * 1.2) * 100) / 100)
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 52
                text: Math.round(Settings.get("widgets.scale", 1.0) * 100) + "%"
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
        }
    }

    SettingRow {
        width: page.width
        label: I18n.t("settings.widgets.fontScale")

        Row {
            anchors.right: parent.right
            spacing: 8

            McSlider {
                width: 150
                value: (Settings.get("widgets.fontScale", 1.0) - 0.7) / 0.8
                onMoved: v => Settings.set("widgets.fontScale", Math.round((0.7 + v * 0.8) * 100) / 100)
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 52
                text: Math.round(Settings.get("widgets.fontScale", 1.0) * 100) + "%"
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
        }
    }

    PixelText {
        text: I18n.t("settings.widgets.title")
        font.pixelSize: Theme.fontLarge
        color: Theme.textOnPanel
        styleColor: Theme.panelTextShadow
    }

    PixelText {
        text: I18n.t("settings.widgets.hint")
        font.pixelSize: 9
        color: Theme.textHints
        styleColor: Theme.panelTextShadow
    }

    Repeater {
        model: page.widgetKeys

        delegate: SettingRow {
            width: page.width
            label: I18n.t("widget." + modelData)

            Row {
                anchors.right: parent.right
                spacing: 6

                McSlider {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 96
                    value: (Settings.get("widgets." + modelData + ".scale", 1.0) - 0.5) / 1.5
                    onMoved: v => Settings.set("widgets." + modelData + ".scale",
                                               Math.round((0.5 + v * 1.5) * 100) / 100)
                }
                PixelText {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 40
                    text: Math.round(Settings.get("widgets." + modelData + ".scale", 1.0) * 100) + "%"
                    font.pixelSize: 9
                    color: Theme.textOnPanel
                    styleColor: Theme.panelTextShadow
                }
                McButton {
                    label: "POS"
                    implicitWidth: 46
                    onClicked: page.resetPosition(modelData)
                }
                McButton {
                    implicitWidth: 72
                    label: Settings.get("widgets." + modelData + ".enabled", false) ? I18n.t("common.on") : I18n.t("common.off")
                    checked: Settings.get("widgets." + modelData + ".enabled", false)
                    onClicked: Settings.toggle("widgets." + modelData + ".enabled")
                }
            }
        }
    }

    Rectangle { width: parent.width; height: 2; color: "#8a8a8a" }

    SettingRow {
        width: parent.width
        label: I18n.t("widget.weather.city")
        hint: I18n.t("widget.weather.cityHint")

        McTextField {
            anchors.right: parent.right
            inputWidth: 220
            text: Settings.get("widgets.weather.city", "")
            placeholder: I18n.t("widget.weather.cityHint")
            onEdited: value => {
                Settings.set("widgets.weather.city", value);
                Weather.city = value;
                Weather.refresh();
            }
        }
    }

    SettingRow {
        width: parent.width
        label: I18n.t("widget.visualizer.bars")

        Row {
            anchors.right: parent.right
            spacing: 8

            McSlider {
                width: 150
                value: (Settings.get("widgets.visualizer.bars", 32) - 8) / 56
                onMoved: v => Settings.set("widgets.visualizer.bars", Math.round(8 + v * 56))
            }
            PixelText {
                anchors.verticalCenter: parent.verticalCenter
                width: 36
                text: Settings.get("widgets.visualizer.bars", 32)
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
        }
    }
}

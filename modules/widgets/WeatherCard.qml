import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// WeatherCard — current sky over your head (wttr.in).
McPanel {
    id: root

    implicitWidth: 250
    implicitHeight: 150
    background: Theme.cardBg
    texture: Theme.texturePath("cobblestone")
    textureOpacity: 0.30

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 4

        Row {
            spacing: 10

            Image {
                width: 36
                height: 36
                smooth: false
                mipmap: false
                source: Theme.texturePath(Weather.iconName)
            }

            Column {
                spacing: 2
                PixelText {
                    text: Weather.ok ? (Weather.tempC + "°C") : (Weather.loading ? "…" : "--°C")
                    font.pixelSize: Theme.raw(26)
                    color: Theme.cardText
                }
                PixelText {
                    text: Weather.ok ? Weather.condition : I18n.t("weather.loading")
                    font.pixelSize: Theme.raw(10)
                    color: Theme.cardTextDim
                    elide: Text.ElideRight
                    width: 150
                }
            }
        }

        PixelText {
            width: parent.width
            elide: Text.ElideRight
            text: Weather.ok
                ? (Weather.location + "   " + Weather.maxC + "° / " + Weather.minC + "°")
                : I18n.t("weather.unavailable")
            font.pixelSize: Theme.raw(10)
            color: Theme.cardTextDim
        }

        PixelText {
            visible: Weather.ok
            text: "H " + Weather.humidity + "%   W " + Weather.windKmph + " km/h"
            font.pixelSize: Theme.raw(10)
            color: Theme.cardTextDim
        }
    }
}

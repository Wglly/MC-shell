import QtQuick
import qs.modules.widgets

// Desktop weather card.
DesktopWidget {
    widgetKey: "weather"
    baseWidth: 250
    baseHeight: 150

    WeatherCard {
        anchors.fill: parent
    }
}

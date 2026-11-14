import QtQuick
import qs.modules.widgets

// Desktop weather card.
DesktopWidget {
    widgetKey: "weather"
    implicitWidth: 250
    implicitHeight: 150

    WeatherCard {
        anchors.fill: parent
    }
}

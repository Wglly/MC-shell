import QtQuick
import qs.modules.widgets

// Desktop clock card.
DesktopWidget {
    widgetKey: "clock"
    baseWidth: 260
    baseHeight: 132

    ClockCard {
        anchors.fill: parent
    }
}

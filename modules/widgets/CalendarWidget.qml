import QtQuick
import qs.modules.widgets

// Desktop calendar card.
DesktopWidget {
    widgetKey: "calendar"
    baseWidth: 260
    baseHeight: 250

    CalendarCard {
        anchors.fill: parent
    }
}

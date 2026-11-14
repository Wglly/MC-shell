import QtQuick
import qs.modules.widgets

// Desktop calendar card.
DesktopWidget {
    widgetKey: "calendar"
    implicitWidth: 260
    implicitHeight: 250

    CalendarCard {
        anchors.fill: parent
    }
}

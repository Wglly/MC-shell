import QtQuick
import qs.modules.widgets

// Desktop clock card.
DesktopWidget {
    widgetKey: "clock"
    implicitWidth: 260
    implicitHeight: 132

    ClockCard {
        anchors.fill: parent
    }
}

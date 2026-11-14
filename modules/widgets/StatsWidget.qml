import QtQuick
import qs.modules.widgets

// Desktop system stats card.
DesktopWidget {
    widgetKey: "stats"
    implicitWidth: 250
    implicitHeight: 160

    StatsCard {
        anchors.fill: parent
    }
}

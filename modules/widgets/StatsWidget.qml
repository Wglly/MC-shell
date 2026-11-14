import QtQuick
import qs.modules.widgets

// Desktop system stats card.
DesktopWidget {
    widgetKey: "stats"
    baseWidth: 250
    baseHeight: 160

    StatsCard {
        anchors.fill: parent
    }
}

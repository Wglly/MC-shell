import QtQuick
import qs.modules.widgets

// Desktop media player card.
DesktopWidget {
    widgetKey: "media"
    baseWidth: 300
    baseHeight: 210

    MusicCard {
        anchors.fill: parent
    }
}

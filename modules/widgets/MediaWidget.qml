import QtQuick
import qs.modules.widgets

// Desktop media player card.
DesktopWidget {
    widgetKey: "media"
    implicitWidth: 300
    implicitHeight: 180

    MusicCard {
        anchors.fill: parent
    }
}

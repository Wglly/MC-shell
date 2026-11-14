import QtQuick
import qs.modules.widgets

// Desktop user card.
DesktopWidget {
    widgetKey: "user"
    baseWidth: 280
    baseHeight: 190

    UserCard {
        anchors.fill: parent
    }
}

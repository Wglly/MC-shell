import QtQuick
import qs.modules.widgets

// Desktop user card.
DesktopWidget {
    widgetKey: "user"
    implicitWidth: 280
    implicitHeight: 190

    UserCard {
        anchors.fill: parent
    }
}

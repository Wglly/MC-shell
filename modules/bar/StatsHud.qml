import QtQuick
import qs.modules.common
import qs.services

// StatsHud — CPU as hearts and RAM as hunger, Minecraft HUD style.
Item {
    id: root

    property bool vertical: false

    implicitWidth: vertical ? column.implicitWidth : row.implicitWidth
    implicitHeight: vertical ? column.implicitHeight : row.implicitHeight

    Row {
        id: row
        visible: !root.vertical
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        StatsGroup { kind: "cpu" }
        StatsGroup { kind: "ram" }
    }

    Column {
        id: column
        visible: root.vertical
        spacing: 2
        anchors.horizontalCenter: parent.horizontalCenter

        StatsGroup { kind: "cpu" }
        StatsGroup { kind: "ram" }
    }
}

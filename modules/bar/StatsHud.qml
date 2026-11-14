import QtQuick
import qs.modules.common
import qs.services

// StatsHud — CPU as hearts and RAM as hunger, Minecraft HUD style.
Item {
    id: root

    property bool vertical: false

    implicitWidth: vertical ? column.implicitWidth : row.implicitWidth
    implicitHeight: vertical ? column.implicitHeight : row.implicitHeight

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            var p = root.mapToItem(null, root.width / 2, 0);
            ShellState.barPopupX = p.x;
            ShellState.toggleBarPopup("stats");
        }
    }

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

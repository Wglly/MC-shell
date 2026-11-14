import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// TrayRow — system tray icons as tiny inventory slots.
Item {
    id: root

    property bool vertical: false

    implicitWidth: vertical ? 26 : row.implicitWidth
    implicitHeight: vertical ? column.implicitHeight : 26

    Row {
        id: row
        visible: !root.vertical
        spacing: 2
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: SystemTray.items.values
            delegate: Slot {
                width: 26
                height: 26
                icon: modelData.icon !== "" ? Quickshell.iconPath(modelData.icon, "") : ""
            }
        }
    }

    Column {
        id: column
        visible: root.vertical
        spacing: 2
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            model: SystemTray.items.values
            delegate: Slot {
                width: 26
                height: 26
                icon: modelData.icon !== "" ? Quickshell.iconPath(modelData.icon, "") : ""
            }
        }
    }
}

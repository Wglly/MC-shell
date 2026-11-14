import QtQuick
import Quickshell
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// Workspaces — the Minecraft hotbar.  One slot per workspace, numbered, with
// the current workspace framed in white like the selected hotbar slot.
Item {
    id: root

    property bool vertical: false

    implicitWidth: vertical ? 30 : row.implicitWidth
    implicitHeight: vertical ? column.implicitHeight : 30

    Row {
        id: row
        visible: !root.vertical
        spacing: 2
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: Compositor.workspaces
            delegate: Slot {
                width: 30
                height: 30
                label: modelData.name
                active: modelData.active
                occupied: modelData.occupied
                onClicked: Compositor.focusWorkspace(modelData.id)
            }
        }

        Slot {
            width: 30
            height: 30
            label: "--"
            opacity: 0.5
            visible: Compositor.workspaces.length === 0
        }
    }

    Column {
        id: column
        visible: root.vertical
        spacing: 2
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            model: Compositor.workspaces
            delegate: Slot {
                width: 30
                height: 30
                label: modelData.name
                active: modelData.active
                occupied: modelData.occupied
                onClicked: Compositor.focusWorkspace(modelData.id)
            }
        }
    }
}

import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// Workspaces — the Minecraft hotbar.  One slot per workspace, numbered, with
// the current workspace framed in white like the selected hotbar slot.
Row {
    id: root

    spacing: 2

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

    // niri / Hyprland with no workspaces yet: show a dim placeholder.
    Slot {
        width: 30
        height: 30
        label: "--"
        opacity: 0.5
        visible: Compositor.workspaces.length === 0
    }
}

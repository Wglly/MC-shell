import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import qs.modules.common
import qs.modules.common.widgets

// TrayRow — system tray icons as tiny inventory slots.
Row {
    id: root

    spacing: 2
    visible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items.values

        delegate: Slot {
            width: 26
            height: 26
            icon: modelData.icon !== "" ? Quickshell.iconPath(modelData.icon, "") : ""
        }
    }
}

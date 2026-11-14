import QtQuick
import Quickshell.Services.UPower
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// BatChip — battery percentage (hidden on desktops without a battery).
Chip {
    id: root

    label: I18n.t("bar.battery")
    visible: UPower.displayDevice && UPower.displayDevice.isPresent
    value: UPower.displayDevice ? Math.round(UPower.displayDevice.percentage * 100) + "%" : "--"
    valueColor: UPower.displayDevice && UPower.displayDevice.percentage < 0.2 ? Theme.red : Theme.textOnPanel
    onClicked: ShellState.toggleOverlay("control")
}

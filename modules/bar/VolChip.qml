import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// VolChip — volume readout; wheel adjusts it, click opens the options screen.
Chip {
    id: root

    label: I18n.t("bar.volume")
    value: Audio.label
    valueColor: Audio.muted ? Theme.red : Theme.textOnPanel
    onClicked: ShellState.toggleOverlay("control")
    onScrolled: delta => Audio.step(delta)
}

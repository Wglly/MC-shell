import QtQuick
import Quickshell.Networking
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// NetChip — connectivity status in the bar.
Chip {
    id: root

    label: I18n.t("bar.network")

    readonly property var conn: {
        var ds = Networking.devices.values;
        for (var i = 0; i < ds.length; i++)
            if (ds[i].connected)
                return ds[i];
        return null;
    }
    readonly property bool connected: conn !== null

    value: root.connected ? I18n.t("common.on") : I18n.t("common.off")
    valueColor: root.connected ? Theme.grass : Theme.red
    onClicked: mouse => {
        var p = parent.mapToItem(null, mouse.x, mouse.y);
        ShellState.barPopupX = p.x;
        ShellState.popupAnchorY = p.y;
        ShellState.toggleOverlay("connectivity");
    }
}

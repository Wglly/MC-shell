import QtQuick
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// TogglesCard — the quick toggle columns (Wi-Fi / BT / mic / DND).
McPanel {
    id: root

    implicitWidth: 250
    implicitHeight: 190
    background: Theme.cardBg
    texture: Theme.texturePath(Settings.get("theme.cardTexture", "oak_planks"))
    textureOpacity: 0.24

    readonly property var mic: Pipewire.defaultAudioSource ? Pipewire.defaultAudioSource.audio : null

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        PixelText {
            text: I18n.t("widget.toggles")
            font.pixelSize: Theme.fontSmall
            color: Theme.gold
        }

        Grid {
            columns: 2
            spacing: 6

            McButton {
                width: 108
                height: 30
                label: "WIFI " + (Networking.wifiEnabled ? I18n.t("common.on") : I18n.t("common.off"))
                checked: Networking.wifiEnabled
                onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
            }
            McButton {
                width: 108
                height: 30
                visible: Bluetooth.defaultAdapter !== null
                label: "BT " + (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled ? I18n.t("common.on") : I18n.t("common.off"))
                checked: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled
                onClicked: {
                    if (Bluetooth.defaultAdapter)
                        Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
                }
            }
            McButton {
                width: 108
                height: 30
                label: "MIC " + (root.mic && root.mic.muted ? I18n.t("common.off") : I18n.t("common.on"))
                checked: root.mic && root.mic.muted
                onClicked: if (root.mic) root.mic.muted = !root.mic.muted
            }
            McButton {
                width: 108
                height: 30
                label: "DND " + (Notifs.dnd ? I18n.t("common.on") : I18n.t("common.off"))
                checked: Notifs.dnd
                onClicked: Notifs.dnd = !Notifs.dnd
            }
        }
    }
}

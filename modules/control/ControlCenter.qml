import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Networking
import Quickshell.Bluetooth
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// ControlCenter — a Minecraft "options" screen: sliders, toggles, power.
PanelWindow {
    id: root

    visible: ShellState.overlay === "control"
    color: "transparent"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    Rectangle {
        anchors.fill: parent
        color: "#05070a"
        opacity: 0.45
        MouseArea {
            anchors.fill: parent
            onClicked: ShellState.closeOverlay()
        }
    }

    McPanel {
        id: panel
        anchors.centerIn: parent
        width: Math.min(600, parent.width - 80)
        height: content.implicitHeight + 50
        background: "#c6c6c6"
        texture: Qt.resolvedUrl("../../assets/textures/oak_planks.png")
        textureOpacity: 0.25

        ColumnLayout {
            id: content
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            RowLayout {
                Layout.fillWidth: true

                PixelText {
                    text: I18n.t("control.title")
                    font.pixelSize: Theme.fontLarge
                    color: Theme.textOnPanel
                    styleColor: "#ffffff"
                }
                Item { Layout.fillWidth: true }
                McButton {
                    label: "X"
                    implicitWidth: 34
                    onClicked: ShellState.closeOverlay()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 2
                color: "#8a8a8a"
            }

            // -------------------------------------------------------- sound
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                PixelText {
                    Layout.preferredWidth: 74
                    text: I18n.t("control.sound")
                    font.pixelSize: Theme.fontSmall
                    color: Theme.textOnPanel
                    styleColor: "#ffffff"
                }
                McSlider {
                    Layout.fillWidth: true
                    value: Audio.volume
                    onMoved: value => Audio.setVolume(value)
                }
                McButton {
                    label: Audio.muted ? "OFF" : "ON"
                    implicitWidth: 46
                    checked: Audio.muted
                    onClicked: Audio.toggleMute()
                }
                PixelText {
                    Layout.preferredWidth: 46
                    Layout.rightMargin: 4
                    horizontalAlignment: Text.AlignRight
                    text: Audio.label
                    font.pixelSize: Theme.fontSmall
                    color: Theme.textOnPanel
                    styleColor: "#ffffff"
                }
            }

            // ------------------------------------------------------ brightness
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                visible: System.brightnessAvailable

                PixelText {
                    Layout.preferredWidth: 74
                    text: I18n.t("control.brightness")
                    font.pixelSize: Theme.fontSmall
                    color: Theme.textOnPanel
                    styleColor: "#ffffff"
                }
                McSlider {
                    Layout.fillWidth: true
                    value: System.brightness
                    fillColor: Theme.gold
                    onMoved: value => System.setBrightness(value)
                }
                PixelText {
                    Layout.preferredWidth: 46
                    Layout.rightMargin: 4
                    horizontalAlignment: Text.AlignRight
                    text: Math.round(System.brightness * 100) + "%"
                    font.pixelSize: Theme.fontSmall
                    color: Theme.textOnPanel
                    styleColor: "#ffffff"
                }
            }

            // --------------------------------------------------------- toggles
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                McButton {
                    Layout.fillWidth: true
                    label: I18n.t("control.wifi") + " " + (Networking.wifiEnabled ? I18n.t("common.on") : I18n.t("common.off"))
                    checked: Networking.wifiEnabled
                    onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
                }
                McButton {
                    Layout.fillWidth: true
                    visible: Bluetooth.defaultAdapter !== null
                    label: I18n.t("control.bluetooth") + " " + (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled ? I18n.t("common.on") : I18n.t("common.off"))
                    checked: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled
                    onClicked: {
                        if (Bluetooth.defaultAdapter)
                            Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
                    }
                }
                McButton {
                    Layout.fillWidth: true
                    label: I18n.t("control.battery") + " " + (UPower.displayDevice && UPower.displayDevice.isPresent
                        ? Math.round(UPower.displayDevice.percentage * 100) + "%" : "--")
                    onClicked: { }
                }
            }

            // -------------------------------------------------------- media
            McPanel {
                Layout.fillWidth: true
                implicitHeight: 92
                bevel: 2
                inset: true
                background: "#1d1d1d"
                texture: Qt.resolvedUrl("../../assets/textures/deepslate.png")
                textureOpacity: 0.5

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    PixelText {
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: root.player ? (root.player.trackTitle || "?") : I18n.t("control.nothingPlaying")
                        font.pixelSize: Theme.fontSmall
                        color: root.player ? Theme.gold : Theme.textDim
                    }
                    PixelText {
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: root.player ? (root.player.trackArtist || "") : ""
                        font.pixelSize: 11
                        color: Theme.textDim
                    }
                    RowLayout {
                        spacing: 6
                        visible: root.player !== null

                        McButton {
                            label: I18n.t("control.prev")
                            implicitWidth: 60
                            implicitHeight: 26
                            enabledButton: root.player && root.player.canGoPrevious
                            onClicked: if (root.player) root.player.previous()
                        }
                        McButton {
                            label: root.player && root.player.isPlaying ? I18n.t("control.pause") : I18n.t("control.play")
                            implicitWidth: 66
                            implicitHeight: 26
                            onClicked: if (root.player) root.player.togglePlaying()
                        }
                        McButton {
                            label: I18n.t("control.next")
                            implicitWidth: 60
                            implicitHeight: 26
                            enabledButton: root.player && root.player.canGoNext
                            onClicked: if (root.player) root.player.next()
                        }
                    }
                }
            }

            // -------------------------------------------------------- system
            PixelText {
                Layout.fillWidth: true
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: "#ffffff"
                text: I18n.t("control.cpu") + " " + Math.round(Stats.cpu * 100) + "%   " + I18n.t("control.ram") + " " + Stats.memUsed.toFixed(1) + "/"
                      + Stats.memTotal.toFixed(1) + "G   " + I18n.t("control.up") + " " + System.uptimeText()
            }

            // --------------------------------------------------------- power
            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                McButton { Layout.fillWidth: true; label: I18n.t("control.lock"); onClicked: System.lockSession() }
                McButton { Layout.fillWidth: true; label: I18n.t("control.sleep"); onClicked: System.suspend() }
                McButton { Layout.fillWidth: true; label: I18n.t("control.reboot"); onClicked: System.reboot() }
                McButton { Layout.fillWidth: true; label: I18n.t("control.off"); accentColor: Theme.red; onClicked: System.powerOff() }
            }
        }
    }

    // Escape closes whatever is open.
    Item {
        anchors.fill: parent
        focus: root.visible
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                ShellState.closeOverlay();
                event.accepted = true;
            }
        }
    }
}

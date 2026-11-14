import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// Toasts — Minecraft "advancement" boxes sliding in under the bar.
PanelWindow {
    id: root

    visible: Notifs.items.length > 0
    color: "transparent"
    implicitWidth: 340
    implicitHeight: Math.max(1, Notifs.items.length * 92 + 12)
    anchors {
        top: true
        right: true
    }
    margins { top: Theme.barHeight + 6; right: 8 }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay

    Column {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 6

        Repeater {
            model: Notifs.items

            delegate: McPanel {
                width: parent.width
                height: 86
                background: "#1a1a1a"
                texture: Qt.resolvedUrl("../../assets/textures/dirt.png")
                textureOpacity: 0.35

                MouseArea {
                    anchors.fill: parent
                    onClicked: Notifs.dismiss(modelData.key)
                }

                Column {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 3

                    PixelText {
                        width: parent.width
                        elide: Text.ElideRight
                        text: modelData.app.toUpperCase()
                        font.pixelSize: 10
                        color: Theme.gold
                    }
                    PixelText {
                        width: parent.width
                        elide: Text.ElideRight
                        text: modelData.summary
                        font.pixelSize: Theme.fontSmall
                        color: Theme.text
                    }
                    PixelText {
                        width: parent.width
                        height: parent.height - 34
                        elide: Text.ElideRight
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        text: modelData.body
                        font.pixelSize: 10
                        color: Theme.textDim
                    }
                }
            }
        }
    }
}

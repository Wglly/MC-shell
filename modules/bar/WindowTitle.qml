import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// WindowTitle — the focused window, clipped like Minecraft's HUD text.
Item {
    id: root

    property int maxWidth: 260

    implicitWidth: Math.min(maxWidth, label.implicitWidth)
    implicitHeight: 18

    PixelText {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        width: root.width
        elide: Text.ElideRight
        text: Compositor.windowTitle !== "" ? Compositor.windowTitle : Compositor.windowAppId
        color: Theme.textDim
        font.pixelSize: Theme.fontSmall
    }
}

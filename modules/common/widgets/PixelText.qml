import QtQuick
import qs.modules.common

// PixelText — Monocraft text with Minecraft's hard 1px drop shadow.
Text {
    id: root

    color: Theme.text
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontNormal
    font.weight: Font.Normal
    renderType: Text.NativeRendering
    style: Text.Raised
    styleColor: Theme.textShadow
    verticalAlignment: Text.AlignVCenter
    antialiasing: false
    // Minecraft text never wraps in the HUD.
    wrapMode: Text.NoWrap
}

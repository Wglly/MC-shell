import QtQuick
import qs.modules.common

// Chip — a small framed HUD readout for the bar (VOL / NET / BAT ...).
Item {
    id: root

    property string label: ""
    property string value: ""
    property color valueColor: Theme.textOnPanel
    property bool interactive: true
    // Vertical bars only have ~44px of width: drop the label, keep the value.
    property bool compact: false
    signal clicked()
    signal scrolled(int delta)

    implicitWidth: root.compact ? 44 : Math.max(54, textItem.implicitWidth + 14)
    implicitHeight: root.compact ? 24 : 26
    opacity: interactive ? 1.0 : 0.85

    McPanel {
        anchors.fill: parent
        bevel: 2
        background: area.containsMouse && root.interactive ? Theme.panelDark : Theme.panel
        texture: Theme.texturePath(Theme.panelTexture)
        textureOpacity: 0.16
    }

    Text {
        id: textItem
        anchors.centerIn: parent
        width: parent.width - 6
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
        text: root.compact
            ? (root.value !== "" ? root.value : root.label)
            : (root.label + (root.value !== "" ? " " + root.value : ""))
        color: root.valueColor
        font.family: Theme.fontFamily
        font.pixelSize: root.compact ? 10 : Theme.fontSmall
        renderType: Text.NativeRendering
        style: Text.Raised
        styleColor: Theme.textShadow
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.interactive
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
        onWheel: wheel => root.scrolled(wheel.angleDelta.y > 0 ? 1 : -1)
    }
}

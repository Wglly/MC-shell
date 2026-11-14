import QtQuick
import qs.modules.common

// Chip — a small framed HUD readout for the bar (VOL / NET / BAT ...).
Item {
    id: root

    property string label: ""
    property string value: ""
    property color valueColor: Theme.text
    property bool interactive: true
    signal clicked()
    signal scrolled(int delta)

    implicitWidth: Math.max(54, textItem.implicitWidth + 14)
    implicitHeight: 26
    opacity: interactive ? 1.0 : 0.85

    McPanel {
        anchors.fill: parent
        bevel: 2
        background: area.containsMouse && root.interactive ? "#34302b" : "#26221e"
        texture: Qt.resolvedUrl("../../../assets/textures/stone.png")
        textureOpacity: 0.18
    }

    Text {
        id: textItem
        anchors.centerIn: parent
        text: root.label + (root.value !== "" ? " " + root.value : "")
        color: root.valueColor
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSmall
        renderType: Text.NativeRendering
        style: Text.Raised
        styleColor: "#1a1a1a"
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

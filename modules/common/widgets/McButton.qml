import QtQuick
import qs.modules.common

// McButton — the gray GUI button from Minecraft's menus.
Item {
    id: root

    property string label: ""
    property bool checked: false
    property bool enabledButton: true
    property color accentColor: Theme.textOnPanel
    signal clicked()

    implicitWidth: Math.max(72, textItem.implicitWidth + 22)
    implicitHeight: 30
    opacity: enabledButton ? 1.0 : 0.5

    McPanel {
        anchors.fill: parent
        bevel: 2
        background: !root.enabledButton ? Theme.panelDark
            : area.pressed ? "#8f8f8f"
            : area.containsMouse ? "#d7d7d7"
            : Theme.panel
        texture: Qt.resolvedUrl("../../../assets/textures/stone.png")
        textureOpacity: 0.12
    }

    PixelText {
        id: textItem
        anchors.centerIn: parent
        text: root.label
        color: root.checked ? Theme.gold : root.accentColor
        styleColor: "#ffffff"
        font.pixelSize: Theme.fontSmall
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabledButton
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}

import QtQuick
import qs.modules.common

// Slot — one inventory slot.  Used for workspaces (the hotbar) and tray icons.
Item {
    id: root

    property bool active: false
    property bool hovered: false
    property bool occupied: false
    property string icon: ""
    property string label: ""

    implicitWidth: Theme.slotSize
    implicitHeight: Theme.slotSize

    // slot body: dark inset square exactly like the inventory GUI
    Rectangle {
        anchors.fill: parent
        color: Theme.slotDark
    }
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: area.containsMouse ? "#5a5a5a" : (root.occupied ? "#4a4a4a" : "#3b3b3b")
    }
    // inner bevel
    Rectangle {
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 1 }
        height: 2
        color: "#2a2a2a"
    }
    Rectangle {
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom; margins: 1 }
        width: 2
        color: "#2a2a2a"
    }
    Rectangle {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 1 }
        height: 2
        color: "#a8a8a8"
    }
    Rectangle {
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom; margins: 1 }
        width: 2
        color: "#a8a8a8"
    }

    Image {
        anchors.centerIn: parent
        width: parent.width - 10
        height: parent.height - 10
        visible: root.icon !== ""
        source: root.icon
        fillMode: Image.PreserveAspectFit
        smooth: false
        mipmap: false
    }

    PixelText {
        anchors.centerIn: parent
        visible: root.icon === "" && root.label !== ""
        text: root.label
        color: root.active ? Theme.gold : Theme.text
        font.pixelSize: Theme.fontSmall
    }

    // selection: white hotbar ring
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 2
        border.color: root.active ? "#ffffff" : "transparent"
        visible: root.active
    }
    Rectangle {
        anchors.fill: parent
        anchors.margins: -2
        color: "transparent"
        border.width: 1
        border.color: root.active ? "#000000" : "transparent"
        visible: root.active
    }

    signal clicked()

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}

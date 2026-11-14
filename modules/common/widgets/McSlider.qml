import QtQuick
import qs.modules.common

// McSlider — the chunky slider from Minecraft's options screen.
Item {
    id: root

    property real value: 0.5
    property string icon: ""
    property color fillColor: Theme.grass
    signal moved(real value)

    implicitWidth: 160
    implicitHeight: 30

    function setFromX(x) {
        var ratio = Math.max(0, Math.min(1, x / Math.max(1, track.width)));
        root.value = ratio;
        root.moved(ratio);
    }

    // track
    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 12
        color: "#2b2b2b"
        border.width: 1
        border.color: Theme.outline
    }

    // fill
    Rectangle {
        anchors.verticalCenter: track.verticalCenter
        x: 1
        width: Math.max(0, (track.width - 2) * root.value)
        height: 10
        color: root.fillColor
        opacity: 0.9
    }

    // knob
    Rectangle {
        id: knob
        width: 12
        height: 22
        anchors.verticalCenter: parent.verticalCenter
        x: Math.max(0, Math.min(track.width - width, track.width * root.value - width / 2))
        color: dragging ? "#e8e8e8" : "#c6c6c6"
        border.width: 1
        border.color: Theme.outline

        Rectangle {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom; margins: 1 }
            width: 2
            color: "#ffffff"
        }
        Rectangle {
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom; margins: 1 }
            width: 2
            color: "#7a7a7a"
        }

        readonly property bool dragging: area.drag.active
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: (mouse) => root.setFromX(mouse.x)
        onPositionChanged: (mouse) => { if (pressed) root.setFromX(mouse.x) }
    }
}

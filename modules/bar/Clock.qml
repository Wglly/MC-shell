import QtQuick
import qs.modules.common
import qs.modules.common.widgets

// Clock — "DAY 320 · 14:30" in Minecraft's chunky lettering.
Item {
    id: root

    property date now: new Date()
    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    PixelText {
        id: label
        anchors.centerIn: parent
        text: "DAY " + Util.dayNumber(root.now) + "  " + Util.clockText(root.now)
        font.pixelSize: Theme.fontNormal
        color: Theme.gold
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.now = new Date()
    }
}

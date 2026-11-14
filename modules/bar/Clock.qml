import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// Clock — "DAY 320 · 14:30" in Minecraft's chunky lettering.
Item {
    id: root

    property bool compact: false
    property date now: new Date()
    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    PixelText {
        id: label
        anchors.centerIn: parent
        text: root.compact
            ? Util.clockText(root.now)
            : I18n.t("bar.dayFormat")
                .replace("{d}", Util.dayNumber(root.now))
                .replace("{t}", Util.clockText(root.now))
        font.pixelSize: root.compact ? 11 : Theme.fontNormal
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

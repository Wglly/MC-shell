import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// ClockCard — big Minecraft clock with the "DAY n" counter.
McPanel {
    id: root

    implicitWidth: 260
    implicitHeight: 132
    background: Theme.cardBg
    texture: Theme.texturePath("oak_planks")
    textureOpacity: 0.32

    property date now: new Date()

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 4

        PixelText {
            text: Util.clockText(root.now)
            font.pixelSize: 40
            color: Theme.gold
        }
        PixelText {
            text: Util.weekday(root.now).toUpperCase() + "  " + root.now.getDate() + " / " + (root.now.getMonth() + 1)
            font.pixelSize: Theme.fontSmall
            color: Theme.text
        }
        PixelText {
            text: I18n.t("bar.dayFormat")
                .replace("{d}", Util.dayNumber(root.now))
                .replace("{t}", Util.clockText(root.now))
            font.pixelSize: 11
            color: Theme.textDim
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.now = new Date()
    }
}

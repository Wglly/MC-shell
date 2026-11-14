import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// StatsGroup — five hearts (CPU) or five drumsticks (RAM).
Row {
    id: root

    property string kind: "cpu"     // cpu | ram
    property int maxIcons: 5

    spacing: 1

    readonly property real value: kind === "cpu" ? Stats.cpu : Stats.mem

    Repeater {
        model: root.maxIcons
        delegate: Image {
            width: 13
            height: 13
            smooth: false
            mipmap: false
            opacity: root.kind === "ram" && index >= Math.ceil(root.value * root.maxIcons) ? 0.35 : 1.0
            source: root.kind === "cpu"
                ? (index < Math.ceil(root.value * root.maxIcons)
                    ? Qt.resolvedUrl("../../assets/textures/heart.png")
                    : Qt.resolvedUrl("../../assets/textures/heart_empty.png"))
                : Qt.resolvedUrl("../../assets/textures/hunger.png")
        }
    }

    PixelText {
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: 4
        text: Math.round(root.value * 100) + "%"
        font.pixelSize: Theme.fontSmall
        color: root.value > 0.9 ? Theme.red : Theme.text
    }
}

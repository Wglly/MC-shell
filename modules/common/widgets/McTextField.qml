import QtQuick
import qs.modules.common

// McTextField — Minecraft anvil-style text input.
Item {
    id: root

    property alias text: input.text
    property string placeholder: ""
    property int inputWidth: 240
    signal edited(string value)

    implicitWidth: inputWidth
    implicitHeight: 30

    Rectangle {
        anchors.fill: parent
        color: "#1a1a1a"
        border.width: 2
        border.color: "#000000"
    }
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: "transparent"
        border.width: 1
        border.color: "#7d7d7d"
    }

    TextInput {
        id: input
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        verticalAlignment: TextInput.AlignVCenter
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontNormal
        renderType: Text.NativeRendering
        selectByMouse: true
        clip: true
        onTextChanged: root.edited(text)
        onEditingFinished: root.edited(text)

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.placeholder
            color: "#6f6f6f"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSmall
            visible: input.text.length === 0
        }
    }
}

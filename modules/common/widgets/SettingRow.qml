import QtQuick
import qs.modules.common
import qs.modules.common.widgets

// SettingRow — label on the left, any control on the right.
Item {
    id: root

    property string label: ""
    property string hint: ""
    default property alias control: holder.data

    implicitWidth: 560
    implicitHeight: Math.max(38, hint !== "" ? 48 : 38)

    PixelText {
        id: labelText
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: root.hint !== "" ? 4 : 11
        text: root.label
        font.pixelSize: Theme.fontSmall
        color: Theme.textOnPanel
        styleColor: Theme.panelTextShadow
        width: Math.max(120, root.width * 0.42)
        elide: Text.ElideRight
    }

    PixelText {
        visible: root.hint !== ""
        anchors.left: parent.left
        anchors.top: labelText.bottom
        anchors.topMargin: 2
        width: Math.max(120, root.width * 0.42)
        text: root.hint
        font.pixelSize: Theme.raw(9)
        color: Theme.textHints
        styleColor: Theme.panelTextShadow
        elide: Text.ElideRight
    }

    Item {
        id: holder
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: Math.max(160, root.width - labelText.width - 12)
        height: Math.max(30, childrenRect.height)
    }
}

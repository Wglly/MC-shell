import QtQuick
import Quickshell
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// UserChip — the player's avatar in the bar; click for the profile popup.
Item {
    id: root

    implicitWidth: 28
    implicitHeight: 28

    readonly property string avatarPath: "file://" + (Quickshell.env("HOME") || "") + "/.face"
    property bool hasAvatar: false

    Rectangle {
        anchors.fill: parent
        color: Theme.panelDark
        border.width: 2
        border.color: ShellState.barPopup === "user" ? Theme.gold : Theme.outline
    }

    Image {
        anchors.fill: parent
        anchors.margins: 2
        source: root.avatarPath
        fillMode: Image.PreserveAspectCrop
        smooth: false
        visible: root.hasAvatar
        onStatusChanged: root.hasAvatar = (status === Image.Ready)
    }

    Image {
        anchors.centerIn: parent
        width: 18
        height: 18
        visible: !root.hasAvatar
        source: Qt.resolvedUrl("../../assets/textures/icon_user.png")
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            var p = root.mapToItem(null, root.width / 2, 0);
            ShellState.barPopupX = p.x;
            ShellState.popupAnchorY = p.y;
            ShellState.toggleBarPopup("user");
        }
    }
}

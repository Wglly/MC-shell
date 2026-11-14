import QtQuick
import Quickshell.Services.Mpris
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// MediaBar — compact "now playing" chip in the bar; click for the big view.
Item {
    id: root

    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    visible: root.player !== null
    implicitWidth: row.implicitWidth
    implicitHeight: 28

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Image {
            anchors.verticalCenter: parent.verticalCenter
            width: 22
            height: 22
            visible: root.player !== null && root.player.trackArtUrl !== ""
            source: root.player ? (root.player.trackArtUrl || "") : ""
            fillMode: Image.PreserveAspectCrop
            smooth: false
        }

        Item {
            anchors.verticalCenter: parent.verticalCenter
            width: 132
            height: 26

            Column {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                spacing: 0

                PixelText {
                    width: parent.width
                    elide: Text.ElideRight
                    text: root.player ? (root.player.trackTitle || I18n.t("control.nothingPlaying")) : ""
                    font.pixelSize: 10
                    color: Theme.gold
                }
                PixelText {
                    width: parent.width
                    elide: Text.ElideRight
                    text: root.player ? (root.player.trackArtist || "") : ""
                    font.pixelSize: 8
                    color: Theme.textDim
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: ShellState.toggleBarPopup("media")
            }
        }

        McButton {
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: 26
            implicitHeight: 22
            label: root.player && root.player.isPlaying ? "||" : "▶"
            onClicked: if (root.player) root.player.togglePlaying()
        }
    }
}

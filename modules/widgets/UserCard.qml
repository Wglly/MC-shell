import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// UserCard — the player's profile: avatar, name, host and session uptime.
McPanel {
    id: root

    implicitWidth: 280
    implicitHeight: 190
    background: Theme.cardBg
    texture: Theme.texturePath(Settings.get("theme.cardTexture", "oak_planks"))
    textureOpacity: 0.3

    readonly property string userName: Quickshell.env("USER") || "player"
    property string hostName: ""
    property bool hasAvatar: false

    readonly property string avatarPath: "file://" + (Quickshell.env("HOME") || "") + "/.face"

    Process {
        command: ["hostname"]
        stdout: StdioCollector {
            onStreamFinished: root.hostName = text.trim()
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Row {
            spacing: 10

            Item {
                width: 56
                height: 56

                Rectangle {
                    anchors.fill: parent
                    color: Theme.panelDark
                    border.width: 2
                    border.color: Theme.outline
                }

                Image {
                    anchors.fill: parent
                    anchors.margins: 2
                    source: root.avatarPath
                    fillMode: Image.PreserveAspectCrop
                    smooth: false
                    onStatusChanged: root.hasAvatar = (status === Image.Ready)
                }

                Image {
                    anchors.centerIn: parent
                    width: 36
                    height: 36
                    visible: !root.hasAvatar
                    source: Qt.resolvedUrl("../../assets/textures/icon_user.png")
                    smooth: false
                }
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                PixelText {
                    text: root.userName
                    font.pixelSize: Theme.fontLarge
                    color: Theme.cardTitle
                }
                PixelText {
                    text: root.hostName !== "" ? root.hostName : "localhost"
                    font.pixelSize: 10
                    color: Theme.cardTextDim
                }
                PixelText {
                    text: I18n.t("widget.user.online")
                    font.pixelSize: 9
                    color: Theme.grass
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 2
            color: Theme.bevelDark
        }

        PixelText {
            width: parent.width
            text: I18n.t("widget.user.uptime") + " " + System.uptimeText()
            font.pixelSize: 10
            color: Theme.cardTextDim
        }

        PixelText {
            width: parent.width
            text: I18n.t("widget.user.shell") + "  MC-shell"
            font.pixelSize: 10
            color: Theme.cardTextDim
        }
    }
}

import QtQuick
import Quickshell.Services.Mpris
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// MusicCard — now playing, with jukebox controls.
McPanel {
    id: root

    implicitWidth: 260
    implicitHeight: 210
    background: Theme.cardBg
    texture: Theme.texturePath("bedrock")
    textureOpacity: 0.35

    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        PixelText {
            width: parent.width
            elide: Text.ElideRight
            text: root.player ? (root.player.trackTitle || "?") : I18n.t("control.nothingPlaying")
            font.pixelSize: Theme.fs(Theme.fontSmall)
            color: Theme.cardTitle
        }
        PixelText {
            width: parent.width
            elide: Text.ElideRight
            text: root.player ? (root.player.trackArtist || "") : ""
            font.pixelSize: Theme.raw(10)
            color: Theme.cardTextDim
        }

        Item { width: 1; height: 2 }

        // lyrics (time-synced when lrclib has them)
        Item {
            width: parent.width
            height: 36

            Column {
                anchors.fill: parent
                spacing: 2

                PixelText {
                    width: parent.width
                    elide: Text.ElideRight
                    text: Lyrics.loading ? I18n.t("music.lyrics.loading")
                        : (Lyrics.current !== "" ? Lyrics.current
                        : I18n.t("music.lyrics.none"))
                    font.pixelSize: Theme.raw(10)
                    color: Lyrics.current !== "" ? Theme.gold : Theme.cardTextDim
                }
                PixelText {
                    width: parent.width
                    elide: Text.ElideRight
                    visible: Lyrics.next !== ""
                    text: Lyrics.next
                    font.pixelSize: Theme.raw(9)
                    color: Theme.cardTextDim
                }
            }
        }

        Row {
            spacing: 6
            visible: root.player !== null

            McButton {
                label: "PREV"
                implicitWidth: 62
                implicitHeight: 26
                enabledButton: root.player && root.player.canGoPrevious
                onClicked: if (root.player) root.player.previous()
            }
            McButton {
                label: root.player && root.player.isPlaying ? "PAUSE" : "PLAY"
                implicitWidth: 70
                implicitHeight: 26
                onClicked: if (root.player) root.player.togglePlaying()
            }
            McButton {
                label: "NEXT"
                implicitWidth: 62
                implicitHeight: 26
                enabledButton: root.player && root.player.canGoNext
                onClicked: if (root.player) root.player.next()
            }
        }
    }
}

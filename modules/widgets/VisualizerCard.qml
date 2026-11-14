import QtQuick
import Quickshell.Services.Mpris
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// VisualizerCard — cava spectrum drawn as XP-bar style columns.
McPanel {
    id: root

    implicitWidth: 300
    implicitHeight: 120
    background: "#0d1408"
    texture: Theme.texturePath("deepslate")
    textureOpacity: 0.45

    property int barCount: Math.max(8, Math.min(64, Settings.get("widgets.visualizer.bars", 32)))

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 4

        PixelText {
            width: parent.width
            elide: Text.ElideRight
            text: Mpris.players.values.length > 0
                ? (Mpris.players.values[0].trackTitle || I18n.t("widget.visualizer"))
                : I18n.t("widget.visualizer")
            font.pixelSize: 10
            color: Theme.textDim
        }

        Item {
            width: parent.width
            height: parent.height - 22

            Row {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 2
                height: parent.height

                Repeater {
                    model: root.barCount

                    delegate: Item {
                        width: 4
                        height: parent.height

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: Math.max(2, parent.height * root.levelFor(index))
                            color: Theme.xp

                            Rectangle {
                                anchors.top: parent.top
                                width: parent.width
                                height: 2
                                color: "#d9ffb0"
                                opacity: 0.6
                            }
                        }
                    }
                }
            }
        }
    }

    function levelFor(i) {
        var bars = Visualizer.bars;
        if (!bars || bars.length === 0)
            return 0.02;
        // compress/expand cava's frame to the requested bar count
        var idx = Math.floor(i * bars.length / root.barCount);
        return Math.max(0.02, bars[Math.min(bars.length - 1, idx)]);
    }
}

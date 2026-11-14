import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// CalendarCard — the month grid, Minecraft sign style.
McPanel {
    id: root

    implicitWidth: 260
    implicitHeight: 250
    background: "#20180f"
    texture: Theme.texturePath("oak_planks")
    textureOpacity: 0.30

    property date today: new Date()
    property int monthOffset: 0

    readonly property date viewDate: {
        var d = new Date(root.today.getFullYear(), root.today.getMonth() + root.monthOffset, 1);
        return d;
    }

    readonly property var days: {
        var first = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth(), 1);
        var startPad = first.getDay();
        var count = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() + 1, 0).getDate();
        var out = [];
        for (var i = 0; i < startPad; i++)
            out.push(0);
        for (var d = 1; d <= count; d++)
            out.push(d);
        while (out.length % 7 !== 0)
            out.push(0);
        return out;
    }

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 4

        Row {
            width: parent.width
            spacing: 6

            PixelText {
                text: (root.viewDate.getMonth() + 1) + " / " + root.viewDate.getFullYear()
                font.pixelSize: Theme.fontSmall
                color: Theme.gold
            }
            Item { width: parent.width - 110; height: 1 }
            PixelText {
                text: "<"
                font.pixelSize: Theme.fontSmall
                color: Theme.text
                MouseArea { anchors.fill: parent; anchors.margins: -4; onClicked: root.monthOffset-- }
            }
            PixelText {
                text: ">"
                font.pixelSize: Theme.fontSmall
                color: Theme.text
                MouseArea { anchors.fill: parent; anchors.margins: -4; onClicked: root.monthOffset++ }
            }
        }

        Row {
            spacing: 0
            Repeater {
                model: ["S", "M", "T", "W", "T", "F", "S"]
                delegate: PixelText {
                    width: 32
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    font.pixelSize: 9
                    color: Theme.textDim
                }
            }
        }

        Grid {
            columns: 7
            Repeater {
                model: root.days
                delegate: PixelText {
                    width: 32
                    height: 22
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: modelData === 0 ? "" : ("" + modelData)
                    font.pixelSize: 11
                    color: modelData === root.today.getDate()
                           && root.monthOffset === 0 ? Theme.gold : Theme.text
                }
            }
        }
    }
}

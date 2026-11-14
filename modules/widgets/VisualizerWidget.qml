import QtQuick
import qs.modules.widgets

// Desktop music visualiser card.
DesktopWidget {
    widgetKey: "visualizer"
    implicitWidth: 300
    implicitHeight: 120

    VisualizerCard {
        anchors.fill: parent
    }
}

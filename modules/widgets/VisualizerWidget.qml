import QtQuick
import qs.modules.widgets

// Desktop music visualiser card.
DesktopWidget {
    widgetKey: "visualizer"
    baseWidth: 300
    baseHeight: 120

    VisualizerCard {
        anchors.fill: parent
    }
}

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.widgets
import qs.services

// Sidebar — a "basket" docked to the left or right edge, holding widget cards.
PanelWindow {
    id: root

    required property string side          // "left" | "right"
    required property var targetScreen

    readonly property string key: side === "left" ? "sidebars.left" : "sidebars.right"
    readonly property bool enabled: Settings.get(key + ".enabled", false) === true
    readonly property int panelWidth: Math.max(160, Settings.get(key + ".width", 220))
    readonly property var widgetNames: Settings.get(key + ".widgets", [])
    readonly property int barThickness: Settings.get("bar.thickness", 40)
    readonly property string barPos: Settings.get("bar.position", "top")

    screen: targetScreen
    color: "transparent"
    visible: enabled
    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top

    anchors.left: side === "left"
    anchors.right: side === "right"
    anchors.top: true
    anchors.bottom: true

    implicitWidth: panelWidth
    margins.top: (barPos === "top" ? barThickness : 0) + 6
    margins.bottom: (barPos === "bottom" ? barThickness : 0) + 6

    McPanel {
        anchors.fill: parent
        background: "#1b1610"
        texture: Theme.texturePath(Settings.get("theme.panelTexture", "dirt"))
        textureOpacity: 0.55

        Flickable {
            anchors.fill: parent
            anchors.margins: 8
            contentHeight: cards.height
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: cards
                width: parent.width
                spacing: 8

                Repeater {
                    model: root.widgetNames

                    delegate: Loader {
                        width: cards.width
                        sourceComponent: modelData === "stats" ? statsCard
                            : modelData === "calendar" ? calendarCard
                            : modelData === "music" ? musicCard
                            : modelData === "weather" ? weatherCard
                            : modelData === "clock" ? clockCard
                            : null

                        onLoaded: if (item) item.width = width
                    }
                }
            }
        }
    }

    Component { id: statsCard; StatsCard { } }
    Component { id: calendarCard; CalendarCard { } }
    Component { id: musicCard; MusicCard { } }
    Component { id: weatherCard; WeatherCard { } }
    Component { id: clockCard; ClockCard { } }
}

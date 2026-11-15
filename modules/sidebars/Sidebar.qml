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
    visible: enabled && (side === "left" ? ShellState.leftBasket : ShellState.rightBasket)
    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top
    // Keyboard focus is needed for the wallpaper card's URL field (typing/paste).
    WlrLayershell.keyboardFocus: (ShellState.leftBasket || ShellState.rightBasket)
        ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    // single-edge anchoring so compositor exclusive zones cannot shift the basket
    anchors.left: side === "left"
    anchors.right: side === "right"
    anchors.top: true

    implicitWidth: panelWidth
    // Make sure the basket is a full-height column even when the cards inside
    // are shorter than the screen (and scrollable when they are taller).
    implicitHeight: Math.max(300, (screen ? screen.height : 1080)
        - (root.barPos === "top" ? root.barThickness : 0) - 12)

    // Avoid the bar and the dock when they share an edge with this basket.
    readonly property bool dockVisible: Settings.get("dock.visible", true) === true
    readonly property string dockPos: Settings.get("dock.position", "bottom")
    readonly property int dockIcon: Settings.get("dock.iconSize", 42)
    readonly property int dockCols: Settings.get("dock.columns", 9)
    readonly property int dockRows: Settings.get("dock.rows", 3)
    // vertical dock: columns are drawn on the Y axis (transposed grid)
    readonly property int dockVertSize: dockRows * (dockIcon + 3) + 14
    readonly property int dockHorizSize: dockCols * (dockIcon + 3) + 14

    margins.top: (barPos === "top" ? barThickness : 0) + 6
    margins.bottom: 0
        + (dockVisible && dockPos === "bottom" ? dockHorizSize + 4 : 0)
    margins.left: side === "left"
        ? (barPos === "left" ? barThickness : 0) + 4
          + (dockVisible && dockPos === "left" ? dockVertSize + 4 : 0)
        : 0
    margins.right: side === "right"
        ? (barPos === "right" ? barThickness : 0) + 4
          + (dockVisible && dockPos === "right" ? dockVertSize + 4 : 0)
        : 0

    McPanel {
        liquid: true
        anchors.fill: parent
        background: Theme.cardBg
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
                            : modelData === "media" ? musicCard
                            : modelData === "user" ? userCard
                            : modelData === "perfmon" ? perfCard
                            : modelData === "wallpaper" ? wallpaperCard
                            : modelData === "messages" ? messagesCard
                            : modelData === "widgetmanager" ? widgetManagerCard
                            : modelData === "sliders" ? slidersCard
                            : modelData === "toggles" ? togglesCard
                            : modelData === "capture" ? captureCard
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
    Component { id: userCard; UserCard { } }
    Component { id: perfCard; PerfCard { } }
    Component { id: wallpaperCard; WallpaperCard { } }
    Component { id: messagesCard; MessagesCard { } }
    Component { id: widgetManagerCard; WidgetManagerCard { } }
    Component { id: slidersCard; SlidersCard { } }
    Component { id: togglesCard; TogglesCard { } }
    Component { id: captureCard; CaptureCard { } }
}

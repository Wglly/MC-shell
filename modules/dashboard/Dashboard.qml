import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.widgets
import qs.services

// Dashboard — the macOS-dashboard style widget wall, opened from the dock or
// with `mc-shell ipc call shell dashboard`.
PanelWindow {
    id: root

    visible: ShellState.overlay === "dashboard" && Settings.get("dashboard.enabled", true) === true
    color: "transparent"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    Rectangle {
        anchors.fill: parent
        color: "#05070a"
        opacity: 0.6
        MouseArea {
            anchors.fill: parent
            onClicked: ShellState.closeOverlay()
        }
    }

    McPanel {
        liquid: true
        id: panel
        anchors.centerIn: parent
        width: Math.min(1000, parent.width - 80)
        height: Math.min(520, parent.height - 100)
        background: Theme.panel
        texture: Theme.texturePath(Settings.get("theme.panelTexture", "dirt"))
        textureOpacity: 0.2

        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            Item {
                width: parent.width
                height: 34

                PixelText {
                    anchors.left: parent.left
                    anchors.leftMargin: 6
                    anchors.verticalCenter: parent.verticalCenter
                    text: I18n.t("dashboard.title")
                    font.pixelSize: Theme.fontTitle
                    color: Theme.textOnPanel
                    styleColor: Theme.panelTextShadow
                }
                PixelText {
                    anchors.right: closeBtn.left
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    text: I18n.t("dashboard.hint")
                    font.pixelSize: Theme.raw(9)
                    color: Theme.textHints
                    styleColor: Theme.panelTextShadow
                }
                McButton {
                    id: closeBtn
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 34
                    height: 26
                    label: "X"
                    onClicked: ShellState.closeOverlay()
                }
            }

            Grid {
                id: grid
                width: parent.width
                columns: 3
                spacing: 10

                readonly property int cellW: Math.floor((width - 20) / 3)
                readonly property int cellH: 210

                ClockCard { width: grid.cellW; height: grid.cellH }
                WeatherCard { width: grid.cellW; height: grid.cellH }
                MusicCard { width: grid.cellW; height: grid.cellH }
                VisualizerCard { width: grid.cellW; height: grid.cellH }
                CalendarCard { width: grid.cellW; height: grid.cellH }
                UserCard { width: grid.cellW; height: grid.cellH }
            }
        }
    }

    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                ShellState.closeOverlay();
                event.accepted = true;
            }
        }
    }
}

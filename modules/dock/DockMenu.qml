import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// DockMenu — the little right-click menu of a dock slot (pin / unpin).
PanelWindow {
    id: menu

    required property var targetScreen

    readonly property var state: ShellState.dockMenu
    readonly property bool opened: state.visible === true

    screen: targetScreen
    visible: opened
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    MouseArea {
        anchors.fill: parent
        onClicked: ShellState.closeDockMenu()
    }

    McPanel {
        width: 250
        height: 146
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 150
        background: Theme.panel
        texture: Theme.texturePath(Theme.panelTexture)
        textureOpacity: 0.35

        Column {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 6

            PixelText {
                width: parent.width
                elide: Text.ElideRight
                text: menu.state.name !== "" ? menu.state.name : I18n.t("dock.menu.title")
                font.pixelSize: Theme.fontSmall
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }

            McButton {
                width: parent.width
                height: 26
                visible: menu.state.canPin === true
                label: menu.state.pinned ? I18n.t("dock.menu.unpin") : I18n.t("dock.menu.pin")
                onClicked: ShellState.toggleDockPin(menu.state.path)
            }

            McButton {
                width: parent.width
                height: 26
                label: I18n.t("dock.menu.basket")
                onClicked: {
                    ShellState.closeDockMenu();
                    ShellState.leftBasket = !ShellState.leftBasket;
                }
            }

            McButton {
                width: parent.width
                height: 26
                label: I18n.t("common.cancel")
                onClicked: ShellState.closeDockMenu()
            }
        }
    }
}

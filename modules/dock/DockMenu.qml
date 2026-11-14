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

    function applyPin() {
        var id = ("" + menu.state.path).split("/").pop();
        if (id === "")
            return;
        var list = Settings.get("dock.pinned", []).slice();
        var i = list.indexOf(id);
        var pinned = i < 0;
        if (pinned)
            list.push(id);
        else
            list.splice(i, 1);
        Settings.set("dock.pinned", list);
        Notifs.toast(pinned ? I18n.t("dock.toast.pinned") : I18n.t("dock.toast.unpinned"),
                     menu.state.name);
        ShellState.closeDockMenu();
    }

    MouseArea {
        anchors.fill: parent
        onClicked: ShellState.closeDockMenu()
    }

    McPanel {
        width: 250
        height: 108
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
                onClicked: menu.applyPin()
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

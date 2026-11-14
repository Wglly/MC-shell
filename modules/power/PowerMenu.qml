import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// PowerMenu — the title screen: choose how to leave this world.
PanelWindow {
    id: root

    visible: ShellState.overlay === "power"
    color: "transparent"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    // ------------------------------------------------------------- background
    Image {
        anchors.fill: parent
        source: Qt.resolvedUrl("../../assets/textures/dirt.png")
        fillMode: Image.Tile
        smooth: false
        mipmap: false
    }
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.55
    }

    Column {
        anchors.centerIn: parent
        spacing: 10

        Image {
            x: Math.round((parent.width - width) / 2)
            width: 72
            height: 72
            source: Qt.resolvedUrl("../../assets/icon.png")
            smooth: false
            mipmap: false
        }

        PixelText {
            x: Math.round((parent.width - width) / 2)
            text: I18n.t("power.title")
            font.pixelSize: 44
            color: Theme.text
        }

        PixelText {
            x: Math.round((parent.width - width) / 2)
            text: I18n.t("power.subtitle")
            font.pixelSize: Theme.fontSmall
            color: Theme.gold
        }

        Item { width: 1; height: 14 }

        Repeater {
            model: [
                { key: "lock", action: () => System.lockSession() },
                { key: "sleep", action: () => System.suspend() },
                { key: "logout", action: () => System.quitCompositor() },
                { key: "reboot", action: () => System.reboot() },
                { key: "off", action: () => System.powerOff() },
                { key: "cancel", action: () => ShellState.closeOverlay() }
            ]

            delegate: McButton {
                width: 340
                height: 44
                x: Math.round((parent.width - width) / 2)
                label: I18n.t("power." + modelData.key)
                accentColor: modelData.key === "off" ? "#b02a20" : Theme.textOnPanel
                onClicked: modelData.action()
            }
        }

        Item { width: 1; height: 8 }

        PixelText {
            x: Math.round((parent.width - width) / 2)
            text: I18n.t("power.hint")
            font.pixelSize: 10
            color: Theme.textDim
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

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.bar
import qs.services

// Bar — one PanelWindow per monitor.  Contents are data-driven: every widget
// lives in one of three sections (left / centre / right) chosen in Settings.
PanelWindow {
    id: root

    required property var modelData
    screen: modelData

    readonly property string pos: Settings.get("bar.position", "top")
    readonly property bool vertical: pos === "left" || pos === "right"
    readonly property int thickness: Math.max(36, Settings.get("bar.thickness", 40))
    readonly property bool barVisible: Settings.get("bar.visible", true)
    readonly property bool autoHide: Settings.get("bar.autoHide", false) === true
    property bool hovered: false
    readonly property bool collapsed: root.autoHide && !root.hovered
    readonly property int visibleThickness: root.collapsed ? 6 : root.thickness

    readonly property var sections: Settings.get("bar.sections", null)
    readonly property var leftItems: root.sections && root.sections.left ? root.sections.left : []
    readonly property var centerItems: root.sections && root.sections.center ? root.sections.center : []
    readonly property var rightItems: root.sections && root.sections.right ? root.sections.right : []

    function itemEnabled(key) {
        return Settings.get("bar.items." + key, true) === true;
    }

    function inSection(section, key) {
        var list = root.sections ? root.sections[section] : null;
        return !!list && list.indexOf(key) >= 0;
    }

    // Anchor to a single edge and size explicitly: stretching between two anchors lets
    // compositor exclusive zones (baskets, dock) push the bar inward.
    readonly property var scr: root.modelData
    anchors.left: root.vertical ? root.pos === "left" : true
    anchors.right: root.vertical ? root.pos === "right" : false
    anchors.top: root.vertical ? true : root.pos === "top"
    anchors.bottom: !root.vertical && root.pos === "bottom"
    implicitWidth: root.vertical ? root.visibleThickness : (root.scr ? root.scr.width : 1920)
    implicitHeight: root.vertical ? (root.scr ? root.scr.height : 1080) : root.visibleThickness
    color: "transparent"
    visible: root.barVisible
    exclusiveZone: 0
    exclusionMode: ExclusionMode.Normal

    IdleInhibitor {
        window: root
        enabled: ShellState.keepAwake
    }

    Timer {
        id: hideTimer
        interval: 320
        repeat: false
        onTriggered: root.hovered = false
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
        onEntered: {
            hideTimer.stop();
            root.hovered = true;
        }
        onExited: if (root.autoHide) hideTimer.restart()
    }

    McPanel {
        anchors.fill: parent
        bevel: Theme.bevelSize
        background: Theme.barBg
        texture: Theme.texturePath(Settings.get("theme.barTexture", "deepslate"))
        textureOpacity: Theme.barTextureOpacity
        textureFillMode: Theme.barTextureStretch ? Image.Stretch : Image.Tile
    }

    // ------------------------------------------------------------ horizontal
    Item {
        visible: !root.vertical && !root.collapsed
        anchors.fill: parent
        anchors.margins: 4

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            DockStrip {
                anchors.verticalCenter: parent.verticalCenter
                visible: Settings.get("dock.mode", "standalone") === "bar"
            }
            BarItem {
                kind: "launcher"
                visible: root.itemEnabled("launcher") && root.inSection("left", "launcher")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "workspaces"
                visible: root.itemEnabled("workspaces") && root.inSection("left", "workspaces")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "title"
                visible: root.itemEnabled("title") && root.inSection("left", "title")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "clock"
                visible: root.itemEnabled("clock") && root.inSection("left", "clock")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "media"
                visible: root.itemEnabled("media") && root.inSection("left", "media")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "stats"
                visible: root.itemEnabled("stats") && root.inSection("left", "stats")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "net"
                visible: root.itemEnabled("net") && root.inSection("left", "net")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "volume"
                visible: root.itemEnabled("volume") && root.inSection("left", "volume")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "battery"
                visible: root.itemEnabled("battery") && root.inSection("left", "battery")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "tray"
                visible: root.itemEnabled("tray") && root.inSection("left", "tray")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "user"
                visible: root.itemEnabled("user") && root.inSection("left", "user")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "basketLeft"
                visible: root.itemEnabled("basketLeft") && root.inSection("left", "basketLeft")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "basketRight"
                visible: root.itemEnabled("basketRight") && root.inSection("left", "basketRight")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "overview"
                visible: root.itemEnabled("overview") && root.inSection("left", "overview")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "dashboard"
                visible: root.itemEnabled("dashboard") && root.inSection("left", "dashboard")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "settings"
                visible: root.itemEnabled("settings") && root.inSection("left", "settings")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "power"
                visible: root.itemEnabled("power") && root.inSection("left", "power")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6
            BarItem {
                kind: "launcher"
                visible: root.itemEnabled("launcher") && root.inSection("center", "launcher")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "workspaces"
                visible: root.itemEnabled("workspaces") && root.inSection("center", "workspaces")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "title"
                visible: root.itemEnabled("title") && root.inSection("center", "title")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "clock"
                visible: root.itemEnabled("clock") && root.inSection("center", "clock")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "media"
                visible: root.itemEnabled("media") && root.inSection("center", "media")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "stats"
                visible: root.itemEnabled("stats") && root.inSection("center", "stats")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "net"
                visible: root.itemEnabled("net") && root.inSection("center", "net")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "volume"
                visible: root.itemEnabled("volume") && root.inSection("center", "volume")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "battery"
                visible: root.itemEnabled("battery") && root.inSection("center", "battery")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "tray"
                visible: root.itemEnabled("tray") && root.inSection("center", "tray")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "user"
                visible: root.itemEnabled("user") && root.inSection("center", "user")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "basketLeft"
                visible: root.itemEnabled("basketLeft") && root.inSection("center", "basketLeft")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "basketRight"
                visible: root.itemEnabled("basketRight") && root.inSection("center", "basketRight")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "overview"
                visible: root.itemEnabled("overview") && root.inSection("center", "overview")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "dashboard"
                visible: root.itemEnabled("dashboard") && root.inSection("center", "dashboard")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "settings"
                visible: root.itemEnabled("settings") && root.inSection("center", "settings")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "power"
                visible: root.itemEnabled("power") && root.inSection("center", "power")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6
            BarItem {
                kind: "launcher"
                visible: root.itemEnabled("launcher") && root.inSection("right", "launcher")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "workspaces"
                visible: root.itemEnabled("workspaces") && root.inSection("right", "workspaces")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "title"
                visible: root.itemEnabled("title") && root.inSection("right", "title")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "clock"
                visible: root.itemEnabled("clock") && root.inSection("right", "clock")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "media"
                visible: root.itemEnabled("media") && root.inSection("right", "media")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "stats"
                visible: root.itemEnabled("stats") && root.inSection("right", "stats")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "net"
                visible: root.itemEnabled("net") && root.inSection("right", "net")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "volume"
                visible: root.itemEnabled("volume") && root.inSection("right", "volume")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "battery"
                visible: root.itemEnabled("battery") && root.inSection("right", "battery")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "tray"
                visible: root.itemEnabled("tray") && root.inSection("right", "tray")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "user"
                visible: root.itemEnabled("user") && root.inSection("right", "user")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "basketLeft"
                visible: root.itemEnabled("basketLeft") && root.inSection("right", "basketLeft")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "basketRight"
                visible: root.itemEnabled("basketRight") && root.inSection("right", "basketRight")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "overview"
                visible: root.itemEnabled("overview") && root.inSection("right", "overview")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "dashboard"
                visible: root.itemEnabled("dashboard") && root.inSection("right", "dashboard")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "settings"
                visible: root.itemEnabled("settings") && root.inSection("right", "settings")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "power"
                visible: root.itemEnabled("power") && root.inSection("right", "power")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
        }
    }

    // -------------------------------------------------------------- vertical
    Item {
        visible: root.vertical && !root.collapsed
        anchors.fill: parent
        anchors.margins: 4

        Column {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            DockStrip {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: Settings.get("dock.mode", "standalone") === "bar"
            }
            BarItem {
                kind: "launcher"
                visible: root.itemEnabled("launcher") && root.inSection("left", "launcher")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "workspaces"
                visible: root.itemEnabled("workspaces") && root.inSection("left", "workspaces")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "title"
                visible: root.itemEnabled("title") && root.inSection("left", "title")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "clock"
                visible: root.itemEnabled("clock") && root.inSection("left", "clock")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "media"
                visible: root.itemEnabled("media") && root.inSection("left", "media")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "stats"
                visible: root.itemEnabled("stats") && root.inSection("left", "stats")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "net"
                visible: root.itemEnabled("net") && root.inSection("left", "net")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "volume"
                visible: root.itemEnabled("volume") && root.inSection("left", "volume")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "battery"
                visible: root.itemEnabled("battery") && root.inSection("left", "battery")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "tray"
                visible: root.itemEnabled("tray") && root.inSection("left", "tray")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "user"
                visible: root.itemEnabled("user") && root.inSection("left", "user")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "basketLeft"
                visible: root.itemEnabled("basketLeft") && root.inSection("left", "basketLeft")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "basketRight"
                visible: root.itemEnabled("basketRight") && root.inSection("left", "basketRight")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "overview"
                visible: root.itemEnabled("overview") && root.inSection("left", "overview")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "dashboard"
                visible: root.itemEnabled("dashboard") && root.inSection("left", "dashboard")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "settings"
                visible: root.itemEnabled("settings") && root.inSection("left", "settings")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "power"
                visible: root.itemEnabled("power") && root.inSection("left", "power")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6
            BarItem {
                kind: "launcher"
                visible: root.itemEnabled("launcher") && root.inSection("center", "launcher")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "workspaces"
                visible: root.itemEnabled("workspaces") && root.inSection("center", "workspaces")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "title"
                visible: root.itemEnabled("title") && root.inSection("center", "title")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "clock"
                visible: root.itemEnabled("clock") && root.inSection("center", "clock")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "media"
                visible: root.itemEnabled("media") && root.inSection("center", "media")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "stats"
                visible: root.itemEnabled("stats") && root.inSection("center", "stats")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "net"
                visible: root.itemEnabled("net") && root.inSection("center", "net")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "volume"
                visible: root.itemEnabled("volume") && root.inSection("center", "volume")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "battery"
                visible: root.itemEnabled("battery") && root.inSection("center", "battery")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "tray"
                visible: root.itemEnabled("tray") && root.inSection("center", "tray")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "user"
                visible: root.itemEnabled("user") && root.inSection("center", "user")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "basketLeft"
                visible: root.itemEnabled("basketLeft") && root.inSection("center", "basketLeft")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "basketRight"
                visible: root.itemEnabled("basketRight") && root.inSection("center", "basketRight")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "overview"
                visible: root.itemEnabled("overview") && root.inSection("center", "overview")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "dashboard"
                visible: root.itemEnabled("dashboard") && root.inSection("center", "dashboard")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "settings"
                visible: root.itemEnabled("settings") && root.inSection("center", "settings")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "power"
                visible: root.itemEnabled("power") && root.inSection("center", "power")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
        }

        Column {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6
            BarItem {
                kind: "launcher"
                visible: root.itemEnabled("launcher") && root.inSection("right", "launcher")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "workspaces"
                visible: root.itemEnabled("workspaces") && root.inSection("right", "workspaces")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "title"
                visible: root.itemEnabled("title") && root.inSection("right", "title")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "clock"
                visible: root.itemEnabled("clock") && root.inSection("right", "clock")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "media"
                visible: root.itemEnabled("media") && root.inSection("right", "media")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "stats"
                visible: root.itemEnabled("stats") && root.inSection("right", "stats")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "net"
                visible: root.itemEnabled("net") && root.inSection("right", "net")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "volume"
                visible: root.itemEnabled("volume") && root.inSection("right", "volume")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "battery"
                visible: root.itemEnabled("battery") && root.inSection("right", "battery")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "tray"
                visible: root.itemEnabled("tray") && root.inSection("right", "tray")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "user"
                visible: root.itemEnabled("user") && root.inSection("right", "user")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "basketLeft"
                visible: root.itemEnabled("basketLeft") && root.inSection("right", "basketLeft")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "basketRight"
                visible: root.itemEnabled("basketRight") && root.inSection("right", "basketRight")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "overview"
                visible: root.itemEnabled("overview") && root.inSection("right", "overview")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "dashboard"
                visible: root.itemEnabled("dashboard") && root.inSection("right", "dashboard")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "settings"
                visible: root.itemEnabled("settings") && root.inSection("right", "settings")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "power"
                visible: root.itemEnabled("power") && root.inSection("right", "power")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
        }
    }
}

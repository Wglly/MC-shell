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

    readonly property var sections: Settings.get("bar.sections", null)
    readonly property var leftItems: root.sections && root.sections.left ? root.sections.left : []
    readonly property var centerItems: root.sections && root.sections.center ? root.sections.center : []
    readonly property var rightItems: root.sections && root.sections.right ? root.sections.right : []

    function inSection(section, key) {
        var list = root.sections ? root.sections[section] : null;
        return !!list && list.indexOf(key) >= 0;
    }

    anchors {
        left: root.vertical ? root.pos === "left" : true
        right: root.vertical ? root.pos === "right" : true
        top: root.vertical ? true : root.pos === "top"
        bottom: root.vertical ? true : root.pos === "bottom"
    }
    implicitWidth: root.vertical ? root.thickness : 0
    implicitHeight: root.vertical ? 0 : root.thickness
    color: "transparent"
    visible: root.barVisible
    exclusiveZone: root.barVisible ? root.thickness : 0
    exclusionMode: ExclusionMode.Normal

    McPanel {
        anchors.fill: parent
        bevel: 2
        background: Theme.barBg
        texture: Theme.texturePath(Settings.get("theme.barTexture", "deepslate"))
        textureOpacity: Theme.barTextureOpacity
        textureFillMode: Theme.barTextureStretch ? Image.Stretch : Image.Tile
    }

    // ------------------------------------------------------------ horizontal
    Item {
        visible: !root.vertical
        anchors.fill: parent
        anchors.margins: 4

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6
            BarItem {
                kind: "launcher"
                visible: root.inSection("left", "launcher")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "workspaces"
                visible: root.inSection("left", "workspaces")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "title"
                visible: root.inSection("left", "title")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "clock"
                visible: root.inSection("left", "clock")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "media"
                visible: root.inSection("left", "media")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "stats"
                visible: root.inSection("left", "stats")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "net"
                visible: root.inSection("left", "net")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "volume"
                visible: root.inSection("left", "volume")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "battery"
                visible: root.inSection("left", "battery")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "tray"
                visible: root.inSection("left", "tray")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "user"
                visible: root.inSection("left", "user")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "basketLeft"
                visible: root.inSection("left", "basketLeft")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "basketRight"
                visible: root.inSection("left", "basketRight")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "overview"
                visible: root.inSection("left", "overview")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "dashboard"
                visible: root.inSection("left", "dashboard")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "settings"
                visible: root.inSection("left", "settings")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "power"
                visible: root.inSection("left", "power")
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
                visible: root.inSection("center", "launcher")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "workspaces"
                visible: root.inSection("center", "workspaces")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "title"
                visible: root.inSection("center", "title")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "clock"
                visible: root.inSection("center", "clock")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "media"
                visible: root.inSection("center", "media")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "stats"
                visible: root.inSection("center", "stats")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "net"
                visible: root.inSection("center", "net")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "volume"
                visible: root.inSection("center", "volume")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "battery"
                visible: root.inSection("center", "battery")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "tray"
                visible: root.inSection("center", "tray")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "user"
                visible: root.inSection("center", "user")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "basketLeft"
                visible: root.inSection("center", "basketLeft")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "basketRight"
                visible: root.inSection("center", "basketRight")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "overview"
                visible: root.inSection("center", "overview")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "dashboard"
                visible: root.inSection("center", "dashboard")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "settings"
                visible: root.inSection("center", "settings")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "power"
                visible: root.inSection("center", "power")
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
                visible: root.inSection("right", "launcher")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "workspaces"
                visible: root.inSection("right", "workspaces")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "title"
                visible: root.inSection("right", "title")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "clock"
                visible: root.inSection("right", "clock")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "media"
                visible: root.inSection("right", "media")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "stats"
                visible: root.inSection("right", "stats")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "net"
                visible: root.inSection("right", "net")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "volume"
                visible: root.inSection("right", "volume")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "battery"
                visible: root.inSection("right", "battery")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "tray"
                visible: root.inSection("right", "tray")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "user"
                visible: root.inSection("right", "user")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "basketLeft"
                visible: root.inSection("right", "basketLeft")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "basketRight"
                visible: root.inSection("right", "basketRight")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "overview"
                visible: root.inSection("right", "overview")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "dashboard"
                visible: root.inSection("right", "dashboard")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "settings"
                visible: root.inSection("right", "settings")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
            BarItem {
                kind: "power"
                visible: root.inSection("right", "power")
                active: visible
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                vertical: false
            }
        }
    }

    // -------------------------------------------------------------- vertical
    Item {
        visible: root.vertical
        anchors.fill: parent
        anchors.margins: 4

        Column {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6
            BarItem {
                kind: "launcher"
                visible: root.inSection("left", "launcher")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "workspaces"
                visible: root.inSection("left", "workspaces")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "title"
                visible: root.inSection("left", "title")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "clock"
                visible: root.inSection("left", "clock")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "media"
                visible: root.inSection("left", "media")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "stats"
                visible: root.inSection("left", "stats")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "net"
                visible: root.inSection("left", "net")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "volume"
                visible: root.inSection("left", "volume")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "battery"
                visible: root.inSection("left", "battery")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "tray"
                visible: root.inSection("left", "tray")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "user"
                visible: root.inSection("left", "user")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "basketLeft"
                visible: root.inSection("left", "basketLeft")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "basketRight"
                visible: root.inSection("left", "basketRight")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "overview"
                visible: root.inSection("left", "overview")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "dashboard"
                visible: root.inSection("left", "dashboard")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "settings"
                visible: root.inSection("left", "settings")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "power"
                visible: root.inSection("left", "power")
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
                visible: root.inSection("center", "launcher")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "workspaces"
                visible: root.inSection("center", "workspaces")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "title"
                visible: root.inSection("center", "title")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "clock"
                visible: root.inSection("center", "clock")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "media"
                visible: root.inSection("center", "media")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "stats"
                visible: root.inSection("center", "stats")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "net"
                visible: root.inSection("center", "net")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "volume"
                visible: root.inSection("center", "volume")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "battery"
                visible: root.inSection("center", "battery")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "tray"
                visible: root.inSection("center", "tray")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "user"
                visible: root.inSection("center", "user")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "basketLeft"
                visible: root.inSection("center", "basketLeft")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "basketRight"
                visible: root.inSection("center", "basketRight")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "overview"
                visible: root.inSection("center", "overview")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "dashboard"
                visible: root.inSection("center", "dashboard")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "settings"
                visible: root.inSection("center", "settings")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "power"
                visible: root.inSection("center", "power")
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
                visible: root.inSection("right", "launcher")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "workspaces"
                visible: root.inSection("right", "workspaces")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "title"
                visible: root.inSection("right", "title")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "clock"
                visible: root.inSection("right", "clock")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "media"
                visible: root.inSection("right", "media")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "stats"
                visible: root.inSection("right", "stats")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "net"
                visible: root.inSection("right", "net")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "volume"
                visible: root.inSection("right", "volume")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "battery"
                visible: root.inSection("right", "battery")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "tray"
                visible: root.inSection("right", "tray")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "user"
                visible: root.inSection("right", "user")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "basketLeft"
                visible: root.inSection("right", "basketLeft")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "basketRight"
                visible: root.inSection("right", "basketRight")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "overview"
                visible: root.inSection("right", "overview")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "dashboard"
                visible: root.inSection("right", "dashboard")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "settings"
                visible: root.inSection("right", "settings")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
            BarItem {
                kind: "power"
                visible: root.inSection("right", "power")
                active: visible
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                vertical: true
            }
        }
    }
}

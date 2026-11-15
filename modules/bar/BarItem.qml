import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.bar
import qs.services

// BarItem — instantiates one status-bar component by its settings key.
Loader {
    id: root

    required property string kind
    property bool vertical: false

    sourceComponent: root.kind === "launcher" ? compLauncher
        : root.kind === "workspaces" ? compWorkspaces
        : root.kind === "title" ? compTitle
        : root.kind === "clock" ? compClock
        : root.kind === "media" ? compMedia
        : root.kind === "stats" ? compStats
        : root.kind === "net" ? compNet
        : root.kind === "volume" ? compVolume
        : root.kind === "battery" ? compBattery
        : root.kind === "tray" ? compTray
        : root.kind === "user" ? compUser
        : root.kind === "basketLeft" ? compBasketLeft
        : root.kind === "basketRight" ? compBasketRight
        : root.kind === "overview" ? compOverview
        : root.kind === "dashboard" ? compDashboard
        : root.kind === "settings" ? compSettings
        : root.kind === "power" ? compPower
        : root.kind === "dockstrip" ? null
        : null

    Component {
        id: compLauncher
        Slot {
            width: 30; height: 30
            icon: Qt.resolvedUrl("../../assets/textures/grass_block_top.png")
            onClicked: ShellState.toggleOverlay("launcher")
        }
    }

    Component {
        id: compWorkspaces
        Workspaces { vertical: root.vertical }
    }

    Component {
        id: compTitle
        WindowTitle {}
    }

    Component {
        id: compClock
        Clock {
            compact: root.vertical
            onClicked: ShellState.toggleBarPopup("calendar")
        }
    }

    Component {
        id: compMedia
        MediaBar {}
    }

    Component {
        id: compStats
        StatsHud { vertical: root.vertical }
    }

    Component {
        id: compNet
        NetChip { compact: root.vertical }
    }

    Component {
        id: compVolume
        VolChip { compact: root.vertical }
    }

    Component {
        id: compBattery
        BatChip { compact: root.vertical }
    }

    Component {
        id: compTray
        TrayRow { vertical: root.vertical }
    }

    Component {
        id: compUser
        UserChip {}
    }

    Component {
        id: compBasketLeft
        Slot {
            width: 30; height: 30
            icon: Qt.resolvedUrl("../../assets/textures/icon_basket_left.png")
            active: ShellState.leftBasket
            onClicked: ShellState.toggleBasket("left")
        }
    }

    Component {
        id: compBasketRight
        Slot {
            width: 30; height: 30
            icon: Qt.resolvedUrl("../../assets/textures/icon_basket_right.png")
            active: ShellState.rightBasket
            onClicked: ShellState.toggleBasket("right")
        }
    }

    Component {
        id: compOverview
        Slot {
            width: 30; height: 30
            icon: Qt.resolvedUrl("../../assets/textures/icon_overview.png")
            onClicked: ShellState.toggleOverlay("overview")
        }
    }

    Component {
        id: compDashboard
        Slot {
            width: 30; height: 30
            icon: Qt.resolvedUrl("../../assets/textures/icon_dashboard.png")
            onClicked: ShellState.toggleOverlay("dashboard")
        }
    }

    Component {
        id: compSettings
        Slot {
            width: 30; height: 30
            icon: Qt.resolvedUrl("../../assets/textures/icon_gear.png")
            onClicked: ShellState.toggleOverlay("settings")
        }
    }

    Component {
        id: compDockStrip
        DockStrip { visible: Settings.get("dock.mode", "standalone") === "bar" }
    }

    Component {
        id: compPower
        Slot {
            width: 30; height: 30
            icon: Qt.resolvedUrl("../../assets/textures/icon_power.png")
            onClicked: ShellState.toggleOverlay("power")
        }
    }
}

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// Dock — the player inventory, plus a mini media player and a dashboard button.
PanelWindow {
    id: root

    required property var targetScreen

    readonly property string pos: Settings.get("dock.position", "bottom")
    readonly property bool vertical: pos === "left" || pos === "right"
    readonly property bool enabled: Settings.get("dock.visible", true) === true
    readonly property bool autoHide: Settings.get("dock.autoHide", false) === true
    readonly property int iconSize: Math.max(28, Math.min(64, Settings.get("dock.iconSize", 42)))
    readonly property int slotPad: 3
    // Free grid: rows/columns come straight from Settings.
    readonly property int columns: Math.max(1, Math.min(12, Settings.get("dock.columns", 9)))
    readonly property int rows: Math.max(1, Math.min(6, Settings.get("dock.rows", 3)))

    readonly property int gridCols: root.vertical ? root.rows : root.columns
    readonly property int gridRows: root.vertical ? root.columns : root.rows
    readonly property int panelW: root.gridCols * (root.iconSize + root.slotPad) + 14
    readonly property int panelH: root.gridRows * (root.iconSize + root.slotPad) + 14

    readonly property bool showMedia: Settings.get("dock.showMedia", true) === true
    readonly property int mediaH: (!root.vertical && root.showMedia) ? 38 : 0
    readonly property int dashH: root.vertical ? 34 : 0
    readonly property int extraH: (root.mediaH > 0 ? root.mediaH + 4 : 0) + (root.dashH > 0 ? root.dashH + 4 : 0)
    readonly property int fullH: root.panelH + root.extraH

    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    property bool hovered: false
    property bool expanded: root.hovered || ShellState.dockMenu.visible === true
        || (!root.autoHide && !root.shouldAvoid)

    // Leaving the dock waits a moment before collapsing, so an accidental 1px
    // exit does not make the dock flicker.
    Timer {
        id: hideTimer
        interval: 260
        repeat: false
        onTriggered: root.hovered = false
    }

    screen: targetScreen
    color: "transparent"
    visible: enabled
    // When apps are open the dock tucks itself away (a 4px strip stays at the
    // edge, hovering it brings the dock back), so it never covers a window.
    function boolSetting(key, def) {
        var v = Settings.get(key, def);
        return v === true || v === "true" || v === 1;
    }
    readonly property bool avoidWindows: root.boolSetting("dock.avoidWindows", true)
    readonly property int hoverZone: Math.max(6, Math.min(48, Settings.get("dock.hoverZone", 12)))
    readonly property bool shouldAvoid: root.avoidWindows && Compositor.activeWindowCount > 0
    exclusionMode: ExclusionMode.Ignore
    // Tell the transparent spacer window how much room the dock needs; the spacer
    // reserves it on the Background layer so windows are pushed out of the way.
    Binding {
        target: ShellState
        property: "dockReserve"
        value: root.expanded && root.enabled ? (root.vertical ? root.fullH : root.fullH + 8) : 0
    }
    WlrLayershell.layer: WlrLayer.Top

    // PanelWindow only offers edge anchors, so centring is done with margins.
    anchors.left: root.vertical ? root.pos === "left" : true
    anchors.right: root.vertical ? root.pos === "right" : false
    anchors.top: root.vertical ? true : root.pos === "top"
    anchors.bottom: root.vertical ? false : root.pos === "bottom"

    implicitWidth: root.vertical ? (expanded ? panelW : root.hoverZone) : panelW
    implicitHeight: root.vertical ? (expanded ? root.fullH : root.hoverZone)
                                  : (expanded ? root.fullH : root.hoverZone)

    readonly property real scrW: root.screen ? root.screen.width : 1920
    readonly property real scrH: root.screen ? root.screen.height : 1080

    // keep clear of the bar when it shares the same edge
    readonly property int barThickness: Settings.get("bar.thickness", 40)
    readonly property string barPos: Settings.get("bar.position", "top")
    readonly property bool barVisible: Settings.get("bar.visible", true) === true

    margins.top: root.vertical
        ? Math.round((root.scrH - root.fullH) / 2)
        : (root.pos === "top" ? 4 + (root.barVisible && root.barPos === "top" ? root.barThickness : 0) : 0)
    margins.bottom: root.vertical
        ? 0
        : (root.pos === "bottom" ? 4 + (root.barVisible && root.barPos === "bottom" ? root.barThickness : 0) : 0)
    margins.left: root.vertical
        ? 4 + (root.barVisible && root.barPos === "left" ? root.barThickness : 0)
        : Math.round((root.scrW - root.panelW) / 2)
    margins.right: 0

    // Hover handling for auto-hide: a thin strip stays on screen.
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            hideTimer.stop();
            root.hovered = true;
        }
        onExited: if (root.autoHide || root.shouldAvoid) hideTimer.restart()
    }

    // small handle so the collapsed strip is discoverable
    Rectangle {
        visible: !root.expanded
        width: root.vertical ? 3 : 46
        height: root.vertical ? 46 : 3
        anchors.horizontalCenter: root.vertical ? undefined : parent.horizontalCenter
        anchors.verticalCenter: root.vertical ? parent.verticalCenter : undefined
        x: root.vertical ? (root.pos === "left" ? 2 : parent.width - 5) : 0
        y: root.vertical ? 0 : (root.pos === "top" ? 2 : parent.height - 5)
        color: Theme.outline
        opacity: 0.65
    }

    // --------------------------------------------------------------- contents
    Column {
        anchors.fill: parent
        spacing: 4
        visible: root.expanded

        // dashboard-only row for vertical docks
        McPanel {
            visible: root.vertical
            width: parent.width
            height: 30
            background: Theme.dockBg
            texture: Theme.texturePath(Theme.dockTexture)
            textureOpacity: 0.9

            Slot {
                anchors.centerIn: parent
                width: 24
                height: 24
                icon: Qt.resolvedUrl("../../assets/textures/icon_dashboard.png")
                onClicked: ShellState.toggleOverlay("dashboard")
            }
        }

        // mini media player + dashboard button
        McPanel {
            visible: !root.vertical && root.showMedia
            width: parent.width
            height: root.mediaH
            background: Theme.dockBg
            texture: Theme.texturePath(Theme.dockTexture)
            textureOpacity: 0.9

            Row {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 6
                spacing: 6

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.max(80, parent.width - 210)
                    spacing: 1

                    PixelText {
                        width: parent.width
                        elide: Text.ElideRight
                        text: root.player
                            ? (root.player.trackTitle || I18n.t("control.nothingPlaying"))
                            : I18n.t("control.nothingPlaying")
                        font.pixelSize: 10
                        color: Theme.text
                    }
                    PixelText {
                        width: parent.width
                        elide: Text.ElideRight
                        visible: root.player !== null
                        text: root.player ? (root.player.trackArtist || "") : ""
                        font.pixelSize: 9
                        color: Theme.textDim
                    }
                }

                McButton {
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: 40
                    implicitHeight: 26
                    visible: root.player !== null
                    label: "|◀"
                    enabledButton: root.player && root.player.canGoPrevious
                    onClicked: if (root.player) root.player.previous()
                }
                McButton {
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: 44
                    implicitHeight: 26
                    visible: root.player !== null
                    label: root.player && root.player.isPlaying ? "||" : "▶"
                    onClicked: if (root.player) root.player.togglePlaying()
                }
                McButton {
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: 40
                    implicitHeight: 26
                    visible: root.player !== null
                    label: "▶|"
                    enabledButton: root.player && root.player.canGoNext
                    onClicked: if (root.player) root.player.next()
                }
                Slot {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 26
                    height: 26
                    icon: Qt.resolvedUrl("../../assets/textures/icon_dashboard.png")
                    onClicked: ShellState.toggleOverlay("dashboard")
                }
            }
        }

        // inventory
        McPanel {
            width: parent.width
            height: root.panelH
            background: Theme.dockBg
            texture: Theme.texturePath(Theme.dockTexture)
            textureOpacity: 0.95
            bevel: 3

            Grid {
                id: grid
                anchors.centerIn: parent
                columns: root.gridCols
                rows: root.gridRows
                spacing: root.slotPad

                Repeater {
                    model: root.columns * root.rows

                    delegate: Slot {
                        readonly property var app: index < root.dockApps.length ? root.dockApps[index] : null

                        width: root.iconSize
                        height: root.iconSize
                        icon: app && app.icon !== "" ? Quickshell.iconPath(app.icon, "") : ""
                        label: app ? app.name.charAt(0) : ""

                        Rectangle {
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: 2
                            width: 5
                            height: 5
                            visible: app !== null && app.running === true
                            color: Theme.grass
                            border.width: 1
                            border.color: Theme.outline
                        }

                        // pinned marker (gold, top-left)
                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.margins: 2
                            width: 4
                            height: 4
                            visible: app !== null && app.pinned === true
                            color: Theme.gold
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: app !== null
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (!app)
                                    return;
                                if (mouse.button === Qt.RightButton)
                                    ShellState.openDockMenu(app);
                                else if (app.windowId && app.windowId !== "")
                                    Compositor.focusWindow(app.windowId);
                                else
                                    Apps.launch(app);
                            }
                        }
                    }
                }
            }
        }
    }

    // ------------------------------------------------------------- app mapping
    readonly property var runningApps: {
        var out = [];
        var seen = {};
        var ws = Compositor.focusedId;
        var list = Compositor.windows;
        for (var i = 0; i < list.length; i++) {
            var w = list[i];
            if (w.workspaceId !== ws)
                continue;
            var cls = "" + (w.appId || w.title || "");
            var key = cls.toLowerCase();
            if (key === "" || seen[key])
                continue;
            seen[key] = true;
            var app = Apps.findByClass(cls);
            out.push({
                name: app ? app.name : (cls.charAt(0).toUpperCase() + cls.slice(1)),
                icon: app ? app.icon : "",
                path: app ? app.path : "",
                windowId: w.id,
                running: true,
                pinned: false
            });
        }
        return out;
    }

    readonly property var dockApps: {
        var pinned = Settings.get("dock.pinned", []);
        var all = Apps.apps;
        var out = [];
        for (var i = 0; i < pinned.length; i++) {
            var id = pinned[i];
            for (var j = 0; j < all.length; j++) {
                if (all[j].path.endsWith("/" + id)) {
                    out.push({ name: all[j].name, icon: all[j].icon, path: all[j].path,
                               windowId: "", running: false, pinned: true });
                    break;
                }
            }
        }
        var run = root.runningApps;
        for (var r = 0; r < run.length; r++) {
            var ra = run[r];
            var dup = -1;
            for (var k = 0; k < out.length; k++) {
                var a = out[k];
                if (a.path !== "" && ra.path !== "" ? a.path === ra.path : a.name === ra.name) {
                    dup = k;
                    break;
                }
            }
            if (dup >= 0) {
                out[dup] = { name: out[dup].name, icon: out[dup].icon, path: out[dup].path,
                             windowId: ra.windowId, running: true, pinned: out[dup].pinned };
            } else {
                out.push(ra);
            }
        }
        if (out.length === 0) {
            for (var f = 0; f < all.length && out.length < 12; f++)
                out.push({ name: all[f].name, icon: all[f].icon, path: all[f].path,
                           windowId: "", running: false, pinned: false });
        }
        return out.slice(0, root.columns * root.rows);
    }

    function togglePin(app) { // kept for the settings page
        var id = app.path !== "" ? app.path.split("/").pop() : "";
        if (id === "")
            return;
        var list = Settings.get("dock.pinned", []).slice();
        var i = list.indexOf(id);
        if (i >= 0)
            list.splice(i, 1);
        else
            list.push(id);
        Settings.set("dock.pinned", list);
    }
}

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// Overview — every desktop as a card; drag a window card onto another desktop
// to move it there.  Works on Hyprland (exact window address) and niri
// (focus the window, then move it to the target workspace).
PanelWindow {
    id: root

    visible: ShellState.overlay === "overview" && Settings.get("overview.enabled", true) === true
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

    readonly property int deskCount: Math.max(1, Math.min(12, Settings.get("overview.desktops", 6)))
    readonly property int gridCols: Math.max(1, Math.min(6, Settings.get("overview.columns", 3)))
    readonly property real backdrop: Settings.get("overview.backdrop", 0.85)
    readonly property int spacing: 10

    // refresh window positions while the overview is open
    property int tick: 0
    Timer {
        interval: 500
        running: root.visible
        repeat: true
        onTriggered: root.tick++
    }

    readonly property var winList: {
        var t = root.tick;
        return Compositor.windows;
    }

    function windowsFor(deskId) {
        var out = [];
        for (var i = 0; i < root.winList.length; i++) {
            if (root.winList[i].workspaceId === deskId)
                out.push(root.winList[i]);
        }
        return out;
    }

    // ------------------------------------------------------------ drag state
    property var dragWin: null
    property bool dragActive: false
    property point dragPos: Qt.point(0, 0)
    property point dragStart: Qt.point(0, 0)

    function desktopAt(px, py) {
        for (var i = 0; i < cards.count; i++) {
            var it = cards.itemAt(i);
            if (!it)
                continue;
            var p = it.mapFromItem(rootItem, px, py);
            if (p.x >= 0 && p.y >= 0 && p.x <= it.width && p.y <= it.height)
                return it.deskId;
        }
        return -1;
    }

    function finishDrag() {
        if (root.dragActive && root.dragWin !== null) {
            var target = root.desktopAt(root.dragPos.x, root.dragPos.y);
            if (target > 0 && target !== root.dragWin.workspaceId)
                Compositor.moveWindow(root.dragWin.id, target);
        }
        root.dragWin = null;
        root.dragActive = false;
    }

    // ------------------------------------------------------------------ view
    Item {
        id: rootItem
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: "#05070a"
            opacity: root.backdrop
            MouseArea {
                anchors.fill: parent
                onClicked: ShellState.closeOverlay()
            }
        }

        Column {
            id: content
            anchors.fill: parent
            anchors.leftMargin: 22
            anchors.rightMargin: 22
            anchors.bottomMargin: 18
            anchors.topMargin: 0
            spacing: 10

            Item {
                width: parent.width
                height: Math.max(40, Settings.get("bar.thickness", 40))

                Rectangle {
                    anchors.fill: parent
                    color: "#0b0f0a"
                    opacity: 1.0
                    border.width: 2
                    border.color: "#000000"
                }

                PixelText {
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    text: I18n.t("overview.title")
                    font.pixelSize: Theme.fontLarge
                    color: Theme.text
                }

                McButton {
                    id: closeBtn
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    width: 34
                    height: 26
                    label: "X"
                    onClicked: ShellState.closeOverlay()
                }

                PixelText {
                    anchors.right: closeBtn.left
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.min(560, parent.width - 260)
                    horizontalAlignment: Text.AlignRight
                    elide: Text.ElideRight
                    text: I18n.t("overview.hint")
                    font.pixelSize: 9
                    color: Theme.textDim
                }
            }

            Grid {
                id: grid
                width: parent.width
                columns: root.gridCols
                spacing: root.spacing

                readonly property int gridRows: Math.max(1, Math.ceil(root.deskCount / root.gridCols))
                readonly property real cardW: Math.floor((width - (root.gridCols - 1) * root.spacing) / root.gridCols)
                readonly property real cardH: Math.min(360, Math.floor((content.height - 60 - (gridRows - 1) * root.spacing) / gridRows))

                Repeater {
                    id: cards
                    model: root.deskCount

                    delegate: Item {
                        id: card

                        readonly property int deskId: index + 1
                        readonly property bool isCurrent: Compositor.focusedId === card.deskId
                        readonly property var wins: root.windowsFor(card.deskId)

                        width: grid.cardW
                        height: grid.cardH

                        McPanel {
                            liquid: true
                            anchors.fill: parent
                            background: card.isCurrent ? "#27301b" : Theme.cardBg
                            texture: Theme.texturePath(card.isCurrent ? "grass_block_top" : "deepslate")
                            textureOpacity: card.isCurrent ? 0.18 : 0.5
                        }

                        // clicking the card itself focuses that desktop
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Compositor.focusWorkspace(card.deskId)
                        }

                        Column {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 5

                            Row {
                                width: parent.width
                                spacing: 6

                                PixelText {
                                    text: I18n.t("overview.desktop") + " " + card.deskId
                                    font.pixelSize: Theme.fontSmall
                                    color: card.isCurrent ? Theme.gold : Theme.text
                                }
                                Item { width: parent.width - 150; height: 1 }
                                PixelText {
                                    visible: card.isCurrent
                                    text: I18n.t("overview.current")
                                    font.pixelSize: 9
                                    color: Theme.grass
                                }
                                PixelText {
                                    text: card.wins.length
                                    font.pixelSize: 9
                                    color: Theme.textDim
                                }
                            }

                            Repeater {
                                model: card.wins.slice(0, 5)

                                delegate: McPanel {
                                    liquid: true
                                    width: parent.width
                                    height: 30
                                    background: Theme.panelDark
                                    texture: Theme.texturePath("stone")
                                    textureOpacity: 0.35

                                    Row {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 8
                                        anchors.right: parent.right
                                        anchors.rightMargin: 8
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 6

                                        Image {
                                            width: 14
                                            height: 14
                                            anchors.verticalCenter: parent.verticalCenter
                                            visible: modelData.appId !== ""
                                            source: modelData.appId !== ""
                                                ? Quickshell.iconPath(modelData.appId, "") : ""
                                            smooth: false
                                            mipmap: false
                                        }

                                        PixelText {
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: parent.width - 22
                                            elide: Text.ElideRight
                                            text: Settings.get("overview.titles", true)
                                                ? modelData.title : (modelData.appId || modelData.title)
                                            font.pixelSize: 10
                                            color: Theme.text
                                        }
                                    }

                                    MouseArea {
                                        id: winArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: root.dragActive ? Qt.ClosedHandCursor : Qt.OpenHandCursor

                                        onPressed: mouse => {
                                            root.dragWin = modelData;
                                            root.dragStart = winArea.mapToItem(rootItem, mouse.x, mouse.y);
                                            root.dragPos = root.dragStart;
                                            root.dragActive = false;
                                        }
                                        onPositionChanged: mouse => {
                                            if (!pressed)
                                                return;
                                            var p = winArea.mapToItem(rootItem, mouse.x, mouse.y);
                                            if (Math.abs(p.x - root.dragStart.x) + Math.abs(p.y - root.dragStart.y) > 8)
                                                root.dragActive = true;
                                            root.dragPos = p;
                                        }
                                        onReleased: {
                                            if (root.dragActive) {
                                                root.finishDrag();
                                            } else {
                                                Compositor.focusWorkspace(card.deskId);
                                                Compositor.focusWindow(modelData.id);
                                                ShellState.closeOverlay();
                                            }
                                        }
                                    }
                                }
                            }

                            PixelText {
                                visible: card.wins.length === 0
                                text: I18n.t("overview.empty")
                                font.pixelSize: 10
                                color: Theme.textDim
                            }
                            PixelText {
                                visible: card.wins.length > 5
                                text: "+" + (card.wins.length - 5) + " " + I18n.t("overview.more")
                                font.pixelSize: 9
                                color: Theme.textDim
                            }
                        }
                    }
                }
            }
        }

        // floating drag ghost
        McPanel {
            liquid: true
            visible: root.dragActive && root.dragWin !== null
            x: root.dragPos.x + 10
            y: root.dragPos.y + 6
            width: 230
            height: 34
            background: "#3a3a3a"
            texture: Theme.texturePath("stone")
            textureOpacity: 0.4
            opacity: 0.92

            PixelText {
                anchors.fill: parent
                anchors.margins: 8
                elide: Text.ElideRight
                text: root.dragWin ? root.dragWin.title : ""
                font.pixelSize: 10
                color: Theme.gold
            }
        }
    }

    // Esc / release safety
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

    onVisibleChanged: {
        if (!visible) {
            root.dragWin = null;
            root.dragActive = false;
        }
    }
}

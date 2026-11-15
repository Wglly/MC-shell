import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// Launcher — the "inventory": a grid of apps you can search and click.
PanelWindow {
    id: root

    visible: ShellState.overlay === "launcher"
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

    property int selected: 0
    property string query: ""

    readonly property var filtered: {
        var q = root.query.toLowerCase().trim();
        var all = Apps.apps;
        var out = [];
        for (var i = 0; i < all.length; i++) {
            if (q === "" || all[i].search.indexOf(q) >= 0)
                out.push(all[i]);
        }
        return out;
    }

    function moveSelection(delta) {
        var n = root.filtered.length;
        if (n === 0)
            return;
        root.selected = (root.selected + delta + n) % n;
    }

    function launchSelected() {
        if (root.selected >= 0 && root.selected < root.filtered.length)
            Apps.launch(root.filtered[root.selected]);
    }

    // close + reset when shown
    onVisibleChanged: {
        if (visible) {
            root.query = "";
            root.selected = 0;
            input.forceActiveFocus();
        }
    }

    // ------------------------------------------------------------ dim backdrop
    Rectangle {
        anchors.fill: parent
        color: "#05070a"
        opacity: 0.55
        MouseArea {
            anchors.fill: parent
            onClicked: ShellState.closeOverlay()
        }
    }

    // ------------------------------------------------------------------- panel
    McPanel {
        liquid: true
        id: panel
        anchors.centerIn: parent
        width: Math.min(760, parent.width - 80)
        height: Math.min(560, parent.height - 120)
        background: Theme.panel
        texture: Qt.resolvedUrl("../../assets/textures/dirt.png")
        textureOpacity: 0.20
        bevel: 2

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8

            // header
            Row {
                width: parent.width
                spacing: 8

                PixelText {
                    text: I18n.t("launcher.title")
                    font.pixelSize: Theme.fontLarge
                    color: Theme.textOnPanel
                    styleColor: Theme.panelTextShadow
                }
                PixelText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.filtered.length + " " + I18n.t("launcher.count")
                    font.pixelSize: Theme.fontSmall
                    color: Theme.textHints
                    styleColor: Theme.panelTextShadow
                }
            }

            // search box
            Item {
                width: parent.width
                height: 34

                Rectangle {
                    anchors.fill: parent
                    color: "#1e1e1e"
                    border.width: 2
                    border.color: "#000000"
                }
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1
                    color: "transparent"
                    border.width: 1
                    border.color: "#8b8b8b"
                }

                TextInput {
                    id: input
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    verticalAlignment: TextInput.AlignVCenter
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontNormal
                    renderType: Text.NativeRendering
                    selectByMouse: true
                    cursorVisible: true
                    onTextChanged: {
                        root.query = text;
                        root.selected = 0;
                        grid.positionViewAtBeginning();
                    }

                    PixelText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: I18n.t("launcher.search")
                        color: "#7a7a7a"
                        font.pixelSize: Theme.fontNormal
                        visible: input.text.length === 0
                        z: -1
                    }

                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Escape) {
                            ShellState.closeOverlay();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Down) {
                            root.moveSelection(6);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Up) {
                            root.moveSelection(-6);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Right) {
                            root.moveSelection(1);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Left) {
                            root.moveSelection(-1);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.launchSelected();
                            event.accepted = true;
                        }
                    }
                }
            }

            // app grid
            GridView {
                id: grid
                width: parent.width
                height: parent.height - 34 - 8 - 34 - 8 - 20
                clip: true
                cellWidth: Math.floor(width / 6)
                cellHeight: 76
                model: root.filtered
                boundsBehavior: Flickable.StopAtBounds
                interactive: true

                delegate: Item {
                    width: grid.cellWidth
                    height: grid.cellHeight

                    Column {
                        anchors.centerIn: parent
                        spacing: 4

                        Slot {
                            width: 44
                            height: 44
                            active: index === root.selected
                            icon: modelData.icon !== "" ? Quickshell.iconPath(modelData.icon, "") : ""

                            Image {
                                anchors.centerIn: parent
                                width: 26
                                height: 26
                                visible: parent.icon === ""
                                source: Qt.resolvedUrl("../../assets/textures/grass_block_top.png")
                                smooth: false
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onContainsMouseChanged: if (containsMouse) root.selected = index
                                onClicked: Apps.launch(modelData)
                            }
                        }

                        PixelText {
                            width: grid.cellWidth - 8
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                            font.pixelSize: 11
                            color: index === root.selected ? Theme.textOnPanel : Theme.textOnPanel
                            styleColor: Theme.panelTextShadow
                            text: modelData.name
                        }
                    }
                }

                onCurrentIndexChanged: positionViewAtIndex(currentIndex, GridView.Contain)
            }

            // footer
            PixelText {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 11
                color: Theme.textHints
                styleColor: Theme.panelTextShadow
                text: I18n.t("launcher.hint")
            }
        }
    }

    // keep the highlighted item in view
    Connections {
        target: root
        function onSelectedChanged() {
            grid.positionViewAtIndex(root.selected, GridView.Contain);
        }
    }

    onWidthChanged: input.forceActiveFocus()
}

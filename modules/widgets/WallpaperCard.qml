import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// WallpaperCard — the wallpaper picker: three built-in pixel scenes plus any
// image in the chosen folder.
McPanel {
    id: root

    implicitWidth: 250
    implicitHeight: 320
    background: Theme.cardBg
    texture: Theme.texturePath(Settings.get("theme.cardTexture", "oak_planks"))
    textureOpacity: 0.26

    readonly property string folder: {
        var configured = Settings.get("wallpaper.folder", "");
        if (configured !== "")
            return configured;
        return (Quickshell.env("HOME") || "") + "/Pictures";
    }
    readonly property string current: Settings.get("wallpaper.path", "")

    property var folderImages: []
    onFolderChanged: root.refresh()

    function pick(path) {
        Settings.set("wallpaper.path", path);
        Settings.set("wallpaper.enabled", true);
    }

    property bool pendingRefresh: false
    property string listingFolder: ""

    function refresh() {
        root.listingFolder = root.folder;
        if (lister.running) {
            root.pendingRefresh = true;
            return;
        }
        lister.running = true;
    }

    Process {
        id: lister
        command: ["sh", "-c", "ls -1 '" + root.folder + "' 2>/dev/null | head -40"]
        stdout: StdioCollector {
            onStreamFinished: {
                var out = [];
                var lines = (text || "").split("\n");
                for (var i = 0; i < lines.length; i++) {
                    var n = lines[i].trim();
                    if (!n)
                        continue;
                    if (!/\.(png|jpe?g|webp)$/i.test(n))
                        continue;
                    out.push("file://" + root.listingFolder + "/" + n);
                }
                root.folderImages = out;
            }
        }
        onExited: {
            if (root.pendingRefresh) {
                root.pendingRefresh = false;
                root.refresh();
            }
        }
        Component.onCompleted: initialTimer.restart()
    }

    property Timer initialTimer: Timer {
        interval: 700
        onTriggered: root.refresh()
    }

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6

        Row {
            width: parent.width

            PixelText {
                text: I18n.t("widget.wallpaper")
                font.pixelSize: Theme.fontSmall
                color: Theme.cardTitle
            }
            Item { width: parent.width - 190; height: 1 }
            McButton {
                width: 52
                height: 24
                label: I18n.t("widget.wallpaper.pick")
                onClicked: if (!picker.running) picker.running = true
            }
            McButton {
                width: 46
                height: 24
                label: I18n.t("widget.wallpaper.refresh")
                onClicked: root.refresh()
            }
            McButton {
                width: 52
                height: 24
                label: I18n.t("widget.wallpaper.off")
                accentColor: Theme.red
                onClicked: Settings.set("wallpaper.enabled", false)
            }
        }

        // built-in wallpapers
        Grid {
            columns: 2
            spacing: 5

            Repeater {
                model: [
                    { name: "SUNSET", src: Qt.resolvedUrl("../../assets/wallpapers/sunset.png") },
                    { name: "CAVE", src: Qt.resolvedUrl("../../assets/wallpapers/cave.png") },
                    { name: "SNOW", src: Qt.resolvedUrl("../../assets/wallpapers/snow.png") }
                ]

                delegate: Item {
                    width: 112
                    height: 68

                    Rectangle {
                        anchors.fill: parent
                        color: Theme.panelDark
                        border.width: 2
                        border.color: root.current === modelData.src ? Theme.gold : Theme.outline
                    }
                    Image {
                        anchors.fill: parent
                        anchors.margins: 2
                        source: modelData.src
                        fillMode: Image.PreserveAspectCrop
                        smooth: false
                    }
                    PixelText {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.margins: 3
                        text: modelData.name
                        font.pixelSize: 8
                        color: "#ffffff"
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.pick(modelData.src)
                    }
                }
            }
        }

        PixelText {
            width: parent.width
            elide: Text.ElideRight
            text: I18n.t("widget.wallpaper.folder") + ": " + root.folder
            font.pixelSize: 8
            color: Theme.cardTextDim
        }

        Flickable {
            width: parent.width
            height: parent.height - 190
            clip: true
            contentHeight: folderGrid.height
            boundsBehavior: Flickable.StopAtBounds

            Grid {
                id: folderGrid
                columns: 2
                spacing: 5
                width: parent.width

                Repeater {
                    model: root.folderImages
                    delegate: Item {
                        width: 112
                        height: 62

                        Rectangle {
                            anchors.fill: parent
                            color: Theme.panelDark
                            border.width: 2
                            border.color: root.current === modelData ? Theme.gold : Theme.outline
                        }
                        Image {
                            anchors.fill: parent
                            anchors.margins: 2
                            source: modelData
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.pick(modelData)
                        }
                    }
                }
            }
        }
    }
}

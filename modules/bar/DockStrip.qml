import QtQuick
import Quickshell
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// DockStrip — compact app strip shown in the bar when dock.mode === "bar".
Row {
    id: root

    spacing: 4

    readonly property var pinned: Settings.get("dock.pinned", [])
    readonly property var apps: Apps.apps
    readonly property var runs: {
        var out = [];
        var seen = {};
        var list = Compositor.windows;
        var ws = Compositor.focusedId;
        for (var i = 0; i < list.length; i++) {
            var w = list[i];
            if (w.workspaceId !== ws)
                continue;
            var cls = "" + (w.appId || w.title || "");
            if (cls === "" || seen[cls.toLowerCase()])
                continue;
            seen[cls.toLowerCase()] = true;
            out.push({ cls: cls, windowId: w.id });
        }
        return out;
    }

    readonly property var entries: {
        var out = [];
        for (var i = 0; i < root.pinned.length && out.length < 8; i++) {
            var id = root.pinned[i];
            for (var j = 0; j < root.apps.length; j++) {
                if (root.apps[j].path.endsWith("/" + id)) {
                    out.push({ name: root.apps[j].name, icon: root.apps[j].icon,
                               path: root.apps[j].path, exec: root.apps[j].exec,
                               windowId: "", pinned: true, running: false });
                    break;
                }
            }
        }
        for (var r = 0; r < root.runs.length && out.length < 8; r++) {
            var cls = root.runs[r].cls;
            var app = Apps.findByClass(cls);
            var found = -1;
            for (var k = 0; k < out.length; k++)
                if (out[k].name === (app ? app.name : cls))
                    found = k;
            if (found >= 0) {
                out[found].windowId = root.runs[r].windowId;
                out[found].running = true;
            } else {
                out.push({ name: app ? app.name : cls, icon: app ? app.icon : "",
                           path: app ? app.path : "", exec: app ? app.exec : "",
                           windowId: root.runs[r].windowId, pinned: false, running: true });
            }
        }
        return out;
    }

    Repeater {
        model: root.entries

        delegate: Slot {
            width: 26
            height: 26
            icon: modelData.icon !== "" ? Quickshell.iconPath(modelData.icon, "") : ""
            label: modelData.name.charAt(0)

            Rectangle {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 1
                width: 4
                height: 4
                visible: modelData.running === true
                color: Theme.grass
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton) {
                        ShellState.openDockMenu(modelData);
                        return;
                    }
                    if (modelData.windowId && modelData.windowId !== "")
                        Compositor.focusWindow(modelData.windowId);
                    else
                        Apps.launch(modelData);
                }
            }
        }
    }

    Slot {
        width: 26
        height: 26
        icon: Qt.resolvedUrl("../../assets/textures/icon_launcher.png")
        onClicked: ShellState.toggleOverlay("launcher")
    }
}

pragma Singleton
import QtQuick
import Quickshell

// Wallpapers.qml — the built-in pixel-art wallpapers shipped with the shell.
QtObject {
    id: root

    readonly property var list: [
        { id: "loading", label: "LOADING" }
    ]

    function path(id) {
        var safe = ("" + id).replace(/[^a-z0-9_]/g, "");
        return "file://" + Quickshell.shellPath("assets/wallpapers/" + safe + ".png");
    }

    function has(id) {
        for (var i = 0; i < root.list.length; i++)
            if (root.list[i].id === id)
                return true;
        return false;
    }
}

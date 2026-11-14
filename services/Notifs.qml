pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// Notifs.qml — notification toasts + history, for the messages card.
QtObject {
    id: root

    property var items: []
    property var history: []       // kept for the messages widget (max 40)
    property bool dnd: false
    property int nextKey: 1

    property NotificationServer server: NotificationServer {
        keepOnReload: true
        onNotification: notif => {
            notif.tracked = true;
            root.push(notif);
        }
    }

    function push(notif) {
        var entry = {
            key: root.nextKey++,
            at: Date.now(),
            app: notif.appName || "System",
            summary: notif.summary || "",
            body: notif.body || "",
            icon: notif.appIcon || "",
            node: notif
        };

        var hist = root.history.slice();
        hist.unshift(entry);
        root.history = hist.slice(0, 40);

        if (root.dnd)
            return;

        var list = root.items.slice();
        list.push(entry);
        root.items = list;
    }

    // Simple self-made toast (no NotificationServer involved).
    function toast(title, body) {
        var entry = {
            key: root.nextKey++,
            at: Date.now(),
            app: "MC-shell",
            summary: title || "",
            body: body || "",
            icon: "",
            node: null
        };
        var hist = root.history.slice();
        hist.unshift(entry);
        root.history = hist.slice(0, 40);
        if (root.dnd)
            return;
        var list = root.items.slice();
        list.push(entry);
        root.items = list;
    }

    function dismiss(key) {
        var list = [];
        for (var i = 0; i < root.items.length; i++) {
            if (root.items[i].key === key) {
                try { root.items[i].node.dismiss(); } catch (e) { /* already gone */ }
            } else {
                list.push(root.items[i]);
            }
        }
        root.items = list;
    }

    function clearAll() {
        root.items = [];
    }

    function clearHistory() {
        root.history = [];
    }

    property Timer pruner: Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (root.items.length === 0)
                return;
            var now = Date.now();
            var keep = [];
            for (var i = 0; i < root.items.length; i++) {
                if (now - root.items[i].at < 7000)
                    keep.push(root.items[i]);
            }
            if (keep.length !== root.items.length)
                root.items = keep;
        }
    }
}

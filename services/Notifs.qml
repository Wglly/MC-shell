pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// Notifs.qml — notification toasts, styled as Minecraft chat/advancement boxes.
QtObject {
    id: root

    property var items: []
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
            node: notif,
            app: notif.appName || "System",
            summary: notif.summary || "",
            body: notif.body || "",
            icon: notif.appIcon || ""
        };
        var list = root.items.slice();
        list.push(entry);
        root.items = list;
        // Minecraft chat lines linger, but not forever.
        expireTimer.interval = 6000;
        expireTimer.notifKey = entry.key;
        expireTimer.restart();
    }

    function dismiss(key) {
        var list = [];
        for (var i = 0; i < root.items.length; i++) {
            var it = root.items[i];
            if (it.key === key) {
                try { it.node.dismiss(); } catch (e) { /* already gone */ }
            } else {
                list.push(it);
            }
        }
        root.items = list;
    }

    function clearAll() {
        for (var i = 0; i < root.items.length; i++) {
            try { root.items[i].node.dismiss(); } catch (e) { }
        }
        root.items = [];
    }

    property Timer expireTimer: Timer {
        property int notifKey: -1
        interval: 6000
        onTriggered: if (notifKey >= 0) root.dismiss(notifKey)
    }
}

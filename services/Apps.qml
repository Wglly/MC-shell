pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common

// Apps.qml — the launcher's app list.
//
// Quickshell's DesktopEntries singleton relies on the platform's desktop-entry
// scanner; to stay independent of it (and of XDG quirks) we parse the .desktop
// files ourselves: name, exec line and icon are all we need.
QtObject {
    id: root

    property var apps: []
    property bool loading: false

    readonly property string scanScript: `
for d in /usr/share/applications /usr/local/share/applications "$HOME/.local/share/applications"; do
  [ -d "$d" ] || continue
  for f in "$d"/*.desktop; do
    [ -f "$f" ] || continue
    name=$(sed -n 's/^Name=//p' "$f" | head -n 1)
    exec=$(sed -n 's/^Exec=//p' "$f" | head -n 1)
    icon=$(sed -n 's/^Icon=//p' "$f" | head -n 1)
    nod=$(grep -c '^NoDisplay=true' "$f" 2>/dev/null)
    [ -n "$name" ] && [ -n "$exec" ] && printf '%s\t%s\t%s\t%s\t%s\n' "$f" "$name" "$exec" "$icon" "$nod"
  done
done
`

    function parse(raw) {
        var seen = {};
        var out = [];
        var lines = (raw || "").split("\n");
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i];
            if (!line)
                continue;
            var parts = line.split("\t");
            if (parts.length < 5)
                continue;
            var name = parts[1].replace(/\s+$/, "");
            var exec = parts[2].replace(/\s+$/, "");
            if (!name || !exec)
                continue;
            if (parts[4].replace(/\s+$/, "") === "1")
                continue; // NoDisplay
            var key = name.toLowerCase();
            if (seen[key])
                continue;
            seen[key] = true;
            out.push({
                path: parts[0],
                name: name,
                exec: exec,
                icon: parts[3].replace(/\s+$/, ""),
                search: (name + " " + parts[0]).toLowerCase()
            });
        }
        out.sort(function (a, b) { return a.name.localeCompare(b.name); });
        root.apps = out;
        root.loading = false;
    }

    function refresh() {
        if (scan.running)
            return;
        root.loading = true;
        scan.running = true;
    }

    function launch(app) {
        if (!app || !app.exec)
            return;
        var cmd = app.exec.replace(/%[fFuUdDnNickvm]/g, "").replace(/\s+/g, " ").trim();
        if (cmd === "")
            return;
        Quickshell.execDetached(["/bin/sh", "-c", cmd]);
        ShellState.closeOverlay();
    }

    property Process scan: Process {
        command: ["sh", "-c", root.scanScript]
        stdout: StdioCollector {
            onStreamFinished: root.parse(text)
        }
        onExited: root.loading = false
    }

    Component.onCompleted: root.refresh()
}

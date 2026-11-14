pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Visualizer.qml — real audio spectrum via cava's raw stdout mode.
//
// cava is optional.  When it is missing or cannot open the audio device the
// widget shows a flat idle row instead of inventing movement.
QtObject {
    id: root

    property var bars: []
    property bool available: false
    property bool running: false
    property int barCount: 32

    readonly property string confPath: (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/mc-shell-cava.conf"

    readonly property string confText: [
        "[general]",
        "framerate = 60",
        "[input]",
        "method = pipewire",
        "source = auto",
        "[output]",
        "method = raw",
        "raw_target = /dev/stdout",
        "data_format = ascii",
        "ascii_max_range = 100",
        "bar_delimiter = 59",
        "frame_delimiter = 10",
        ""
    ].join("\n")

    function parseFrame(line) {
        if (!line || line.length === 0)
            return;
        var parts = line.split(";");
        var vals = [];
        for (var i = 0; i < parts.length; i++) {
            var v = parseInt(parts[i], 10);
            if (!isNaN(v))
                vals.push(Math.max(0, Math.min(1, v / 100)));
        }
        if (vals.length > 0)
            root.bars = vals;
    }

    property FileView conf: FileView {
        path: root.confPath
        onSaved: root.startCava()
        Component.onCompleted: setText(root.confText)
    }

    function startCava() {
        if (cava.running)
            return;
        cava.running = true;
    }

    property Process cava: Process {
        command: ["cava", "-p", root.confPath]
        stdout: SplitParser {
            onRead: line => root.parseFrame(line)
        }
        onStarted: {
            root.available = true;
            root.running = true;
        }
        onExited: {
            root.running = false;
            if (root.available)
                restartTimer.restart();
        }
    }

    property Timer restartTimer: Timer {
        interval: 3000
        onTriggered: root.startCava()
    }
}

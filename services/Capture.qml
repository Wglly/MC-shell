pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common

// Capture — screenshots (grim + slurp) and screen recording (wf-recorder).
QtObject {
    id: root

    readonly property string home: Quickshell.env("HOME") || ""
    readonly property string shotDir: root.home + "/Pictures/Screenshots"
    readonly property string videoDir: root.home + "/Videos/Recordings"

    property bool recording: false
    property string lastShot: ""
    property string lastVideo: ""

    signal shotDone(string path, bool ok)
    signal recordDone(string path, bool ok)

    function stamp() {
        return Qt.formatDateTime(new Date(), "yyyy-MM-dd_HH-mm-ss");
    }

    function screenshot() {
        if (slurper.running)
            return;
        root.pendingShot = root.shotDir + "/shot-" + root.stamp() + ".png";
        slurper.running = true;
    }

    property string pendingShot: ""

    function grab(geometry) {
        var dir = root.shotDir;
        var file = root.pendingShot;
        if (file === "")
            return;
        root.lastShot = file;
        var cmd = "mkdir -p \"$1\"; ";
        if (geometry !== "")
            cmd += "grim -g \"$2\" \"$3\"";
        else
            cmd += "grim \"$3\"";
        shotter.command = ["sh", "-c", cmd, "sh", dir, geometry, file];
        shotter.running = true;
    }

    property string geometry: ""

    property Process slurper: Process {
        command: ["slurp"]
        stdout: StdioCollector {
            onStreamFinished: root.geometry = ("" + text).trim()
        }
        onExited: exitCode => {
            if (exitCode === 0) {
                root.grab(root.geometry);
            } else {
                root.geometry = "";
                root.shotDone("", false);
            }
        }
    }

    function toggleRecording() {
        if (root.recording) {
            stopper.running = true;
            return;
        }
        var dir = root.videoDir;
        var file = dir + "/rec-" + root.stamp() + ".mp4";
        root.lastVideo = file;
        starter.command = ["sh", "-c",
            "mkdir -p \"$1\"; wf-recorder -f \"$2\" >/dev/null 2>&1 & echo $! > /tmp/mc-shell-rec.pid",
            "sh", dir, file];
        starter.running = true;
        root.recording = true;
        root.recordDone(file, true);
    }

    property Process shotter: Process {
        onExited: exitCode => root.shotDone(root.lastShot, exitCode === 0)
    }

    property Process starter: Process {
        onExited: exitCode => {
            if (exitCode !== 0) {
                root.recording = false;
                root.recordDone(root.lastVideo, false);
            }
        }
    }

    property Process stopper: Process {
        command: ["sh", "-c",
            "p=$(cat /tmp/mc-shell-rec.pid 2>/dev/null); if [ -n \"$p\" ]; then kill -INT $p 2>/dev/null; sleep 0.6; kill -TERM $p 2>/dev/null; fi; rm -f /tmp/mc-shell-rec.pid"]
        onExited: exitCode => {
            root.recording = false;
            root.recordDone(root.lastVideo, true);
        }
    }
}

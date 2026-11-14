pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// System.qml — brightness and session actions, the few things that need shell
// commands.  Everything is guarded: a missing tool just disables a control.
QtObject {
    id: root

    property real brightness: 0.5
    property bool brightnessAvailable: false

    // -------------------------------------------------------------- brightness
    function setBrightness(v) {
        root.brightness = Math.max(0.01, Math.min(1, v));
        if (!root.brightnessAvailable)
            return;
        setter.command = ["brightnessctl", "-q", "set", Math.round(root.brightness * 100) + "%"];
        setter.running = true;
    }

    property Process setter: Process {
        command: ["brightnessctl", "-q", "set", "50%"]
    }

    property Process brightnessQuery: Process {
        command: ["bash", "-lc", "command -v brightnessctl >/dev/null && brightnessctl -m"]
        stdout: StdioCollector {
            onStreamFinished: {
                var text = (this.text || "").trim();
                root.brightnessAvailable = text.indexOf(",") > 0 || text.length > 0;
                var pct = /(\d+)%/.exec(text);
                if (pct)
                    root.brightness = parseInt(pct[1], 10) / 100;
            }
        }
    }

    property Timer brightnessPoll: Timer {
        interval: 15000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: if (!brightnessQuery.running) brightnessQuery.running = true
    }

    // ------------------------------------------------------------------ actions
    function run(cmd) {
        Quickshell.execDetached(["/bin/sh", "-c", cmd]);
        ShellState.closeOverlay();
    }

    function lockSession() {
        run("loginctl lock-session");
    }
    function suspend() {
        run("systemctl suspend");
    }
    function reboot() {
        run("systemctl reboot");
    }
    function powerOff() {
        run("systemctl poweroff");
    }
    // Quits the compositor (logs the user out of the Wayland session).
    function quitCompositor() {
        if (Compositor.backend === "hyprland")
            run("hyprctl dispatch exit");
        else if (Compositor.backend === "niri")
            run("niri msg action quit");
    }

    function uptimeText() {
        var s = Math.floor(Stats.uptime);
        var h = Math.floor(s / 3600);
        var m = Math.floor((s % 3600) / 60);
        return h + "h " + (m < 10 ? "0" + m : m) + "m";
    }
}

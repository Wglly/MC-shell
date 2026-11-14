pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Stats.qml — CPU / memory usage for the HUD hearts.
QtObject {
    id: root

    property real cpu: 0            // 0..1
    property real mem: 0            // 0..1
    property real memUsed: 0        // GiB
    property real memTotal: 0       // GiB
    property real uptime: 0         // seconds
    property real load1: 0
    property real load5: 0
    property real load15: 0
    property real swapUsed: 0        // GiB
    property real swapTotal: 0       // GiB
    property int processes: 0
    property var top: []             // [{ name, cpu, mem }]
    property bool ready: false

    property var prevTotal: -1
    property var prevIdle: -1

    function parse(raw) {
        var parts = (raw || "").split("@@");
        if (parts.length < 2)
            return;

        // --- /proc/stat
        var line = (parts[0] || "").trim().split("\n")[0];
        var f = line.split(/\s+/);
        if (f.length > 4) {
            var total = 0;
            for (var i = 1; i < f.length; i++)
                total += parseInt(f[i], 10) || 0;
            var idle = (parseInt(f[4], 10) || 0) + (parseInt(f[5], 10) || 0);
            if (root.prevTotal >= 0 && total > root.prevTotal) {
                var dTotal = total - root.prevTotal;
                var dIdle = idle - root.prevIdle;
                root.cpu = Math.max(0, Math.min(1, (dTotal - dIdle) / dTotal));
            }
            root.prevTotal = total;
            root.prevIdle = idle;
        }

        // --- /proc/meminfo
        var m = parts[1] || "";
        var totalKb = /MemTotal:\s+(\d+)/.exec(m);
        var availKb = /MemAvailable:\s+(\d+)/.exec(m);
        if (totalKb && availKb) {
            var t = parseInt(totalKb[1], 10);
            var a = parseInt(availKb[1], 10);
            root.memTotal = t / 1048576;
            root.memUsed = (t - a) / 1048576;
            root.mem = t > 0 ? (t - a) / t : 0;
        }
        var swapTotalKb = /SwapTotal:\s+(\d+)/.exec(m);
        var swapFreeKb = /SwapFree:\s+(\d+)/.exec(m);
        if (swapTotalKb) {
            var st = parseInt(swapTotalKb[1], 10);
            var sf = swapFreeKb ? parseInt(swapFreeKb[1], 10) : 0;
            root.swapTotal = st / 1048576;
            root.swapUsed = (st - sf) / 1048576;
        }

        // --- /proc/uptime
        var up = /(\d+\.\d+)/.exec(parts[2] || "");
        if (up)
            root.uptime = parseFloat(up[1]);

        // --- /proc/loadavg
        if (parts.length > 3) {
            var la = (parts[3] || "").trim().split(/\s+/);
            if (la.length >= 2) {
                root.load1 = parseFloat(la[0]) || 0;
                root.load5 = parseFloat(la[1]) || 0;
                root.load15 = parseFloat(la[2]) || 0;
                var procs = /(\d+)\/(\d+)/.exec(la[3] || "");
                root.processes = procs ? parseInt(procs[2], 10) : (parseInt(la[3], 10) || 0);
            }
        }

        if (parts.length > 4) {
            var rows = (parts[4] || "").trim().split("\n");
            var list = [];
            for (var r = 0; r < rows.length && list.length < 5; r++) {
                var cols = rows[r].trim().split(/\s+/);
                if (cols.length >= 3)
                    list.push({ name: cols[0], cpu: parseFloat(cols[1]) || 0, mem: parseFloat(cols[2]) || 0 });
            }
            root.top = list;
        }

        root.ready = true;
    }

    property Process sampler: Process {
        command: ["sh", "-c", "cat /proc/stat; echo @@; cat /proc/meminfo; echo @@; cat /proc/uptime; echo @@; cat /proc/loadavg; echo @@; ps -eo comm,%cpu,%mem --no-headers --sort=-%cpu | head -5"]
        stdout: StdioCollector {
            onStreamFinished: root.parse(text)
        }
    }

    property Timer poller: Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: if (!sampler.running) sampler.running = true
    }
}

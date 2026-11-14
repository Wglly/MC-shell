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
    property real diskUsed: 0        // GiB
    property real diskTotal: 0       // GiB
    property real diskRatio: 0
    property var disks: []           // [{ mount, used, total, ratio }]
    property var nets: []            // [{ name, rx, tx }]
    property var prevIfaces: ({})
    property real netRx: 0           // bytes / second
    property real netTx: 0
    property var prevRx: -1
    property var prevTx: -1
    property var prevNetTime: -1

    function diskText(used, total) {
        if (total < 1)
            return Math.round(used * 1024) + "/" + Math.round(total * 1024) + "M";
        return used.toFixed(0) + "/" + total.toFixed(0) + "G";
    }

    function rateText(bps) {
        if (bps < 1024)
            return Math.round(bps) + " B/s";
        if (bps < 1048576)
            return (bps / 1024).toFixed(1) + " KB/s";
        if (bps < 1073741824)
            return (bps / 1048576).toFixed(1) + " MB/s";
        return (bps / 1073741824).toFixed(2) + " GB/s";
    }
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

        // --- disk (df)
        if (parts.length > 5) {
            var df = (parts[5] || "").trim().split(/\s+/);
            if (df.length >= 4) {
                var total = parseFloat(df[1]) || 0;
                var used = parseFloat(df[2]) || 0;
                root.diskTotal = total / 1073741824;
                root.diskUsed = used / 1073741824;
                root.diskRatio = total > 0 ? used / total : 0;
            }
        }

        // --- partitions (df)
        if (parts.length > 7) {
            var dlines = (parts[7] || "").trim().split("\n");
            var dlist = [];
            var dseen = {};
            for (var di = 0; di < dlines.length; di++) {
                var dc = dlines[di].trim().split(/\s+/);
                if (dc.length < 4)
                    continue;
                var src = dc[0].split("[")[0];
                if (src.indexOf("/dev/") !== 0)
                    continue;   // only real block devices
                if (dseen[src])
                    continue;   // one row per device (skip bind mounts)
                if (dc[1].indexOf("/run") === 0 || dc[1].indexOf("/etc/") === 0
                    || dc[1].indexOf("/var/lib/docker") === 0 || dc[1].indexOf("/snap") === 0)
                    continue;
                dseen[src] = true;
                var dtotal = parseFloat(dc[2]) || 0;
                var dused = parseFloat(dc[3]) || 0;
                if (dtotal <= 0)
                    continue;
                dlist.push({ mount: dc[1], used: dused / 1073741824,
                             total: dtotal / 1073741824, ratio: dused / dtotal });
            }
            root.disks = dlist;
        }

        // --- network (/proc/net/dev)
        if (parts.length > 6) {
            var lines = (parts[6] || "").split("\n");
            var now = Date.now();
            var dt = root.prevNetTime > 0 ? Math.max(0.001, (now - root.prevNetTime) / 1000) : 0;
            var rxTotal = 0, txTotal = 0;
            var nlist = [];
            var prev = {};
            for (var n = 0; n < lines.length; n++) {
                var mm = lines[n].match(/^\s*([^:]+):\s*(.*)$/);
                if (!mm || mm[1].trim() === "lo")
                    continue;
                var fld = mm[2].trim().split(/\s+/);
                if (fld.length < 9)
                    continue;
                var name = mm[1].trim();
                var rx = parseInt(fld[0], 10) || 0;
                var tx = parseInt(fld[8], 10) || 0;
                var last = root.prevIfaces[name] || null;
                var rxRate = (last && dt > 0) ? Math.max(0, (rx - last.rx) / dt) : 0;
                var txRate = (last && dt > 0) ? Math.max(0, (tx - last.tx) / dt) : 0;
                prev[name] = { rx: rx, tx: tx };
                nlist.push({ name: name, rx: rxRate, tx: txRate });
                rxTotal += rx;
                txTotal += tx;
            }
            root.nets = nlist;
            root.prevIfaces = prev;
            if (dt > 0 && root.prevNetTime > 0) {
                root.netRx = Math.max(0, (rxTotal - root.prevRx) / dt);
                root.netTx = Math.max(0, (txTotal - root.prevTx) / dt);
            }
            root.prevRx = rxTotal;
            root.prevTx = txTotal;
            root.prevNetTime = now;
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
        command: ["sh", "-c", "cat /proc/stat; echo @@; cat /proc/meminfo; echo @@; cat /proc/uptime; echo @@; cat /proc/loadavg; echo @@; ps -eo comm,%cpu,%mem --no-headers --sort=-%cpu | head -5; echo @@; df -B1 / | tail -1; echo @@; cat /proc/net/dev; echo @@; df -B1 --output=source,target,size,used -x tmpfs -x devtmpfs -x overlay -x efivarfs 2>/dev/null | tail -n +2"]
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

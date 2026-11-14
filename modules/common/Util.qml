pragma Singleton
import QtQuick
import Quickshell

// Util.qml — small formatting helpers used all over the shell.
QtObject {
    id: util

    function pad2(n) {
        return n < 10 ? "0" + n : "" + n;
    }

    function clockText(date) {
        return pad2(date.getHours()) + ":" + pad2(date.getMinutes());
    }

    // Minecraft counts days from world creation; we use days since 2026-01-01
    // so the bar reads like "Day 12" without pretending to be a real epoch.
    function dayNumber(date) {
        var start = new Date(2026, 0, 1);
        var ms = date.getTime() - start.getTime();
        return Math.floor(ms / 86400000) + 1;
    }

    function weekday(date) {
        return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][date.getDay()];
    }

    function truncate(text, max) {
        if (!text)
            return "";
        if (text.length <= max)
            return text;
        return text.substring(0, Math.max(1, max - 1)) + "…";
    }

    function percent(value) {
        return Math.round(Math.max(0, Math.min(1, value)) * 100);
    }

    function clamp(v, lo, hi) {
        return Math.max(lo, Math.min(hi, v));
    }

    function basename(p) {
        if (!p)
            return "";
        var i = p.lastIndexOf("/");
        return i >= 0 ? p.substring(i + 1) : p;
    }

    // Executable guess for a desktop entry, used for the launcher fallback icon.
    function execBinary(execString) {
        if (!execString)
            return "";
        var s = execString.replace(/%.$/g, "").trim();
        var parts = s.split(/\s+/);
        return parts.length > 0 ? parts[0] : "";
    }
}

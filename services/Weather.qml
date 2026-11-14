pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common

// Weather.qml — current conditions from wttr.in (no API key needed).
QtObject {
    id: root

    property string city: ""
    property real tempC: 0
    property real feelsC: 0
    property int humidity: 0
    property int windKmph: 0
    property string condition: ""
    property string location: ""
    property int code: 0
    property int maxC: 0
    property int minC: 0
    property bool ok: false
    property bool loading: false

    readonly property string iconName: {
        if (!root.ok)
            return "icon_cloud";
        var c = root.code;
        if (c === 113)
            return "icon_sun";
        if (c === 116 || c === 119 || c === 122)
            return "icon_cloud";
        if ((c >= 200 && c < 300) || c >= 386)
            return "icon_storm";
        if ((c >= 227 && c <= 230) || (c >= 323 && c <= 338) || (c >= 368 && c <= 377))
            return "icon_snow";
        return "icon_rain";
    }

    function parse(raw) {
        var d = null;
        try {
            d = JSON.parse(raw);
        } catch (e) {
            root.ok = false;
            return;
        }
        if (!d || !d.current_condition || d.current_condition.length === 0) {
            root.ok = false;
            return;
        }
        var cur = d.current_condition[0];
        root.tempC = parseInt(cur.temp_C, 10);
        root.feelsC = parseInt(cur.FeelsLikeC, 10);
        root.humidity = parseInt(cur.humidity, 10);
        root.windKmph = parseInt(cur.windspeedKmph, 10);
        root.code = parseInt(cur.weatherCode, 10);
        root.condition = (cur.weatherDesc && cur.weatherDesc.length > 0) ? cur.weatherDesc[0].value : "";
        root.location = d.nearest_area && d.nearest_area.length > 0 ? d.nearest_area[0].areaName[0].value : "";
        if (d.weather && d.weather.length > 0) {
            root.maxC = parseInt(d.weather[0].maxtempC, 10);
            root.minC = parseInt(d.weather[0].mintempC, 10);
        }
        root.ok = true;
    }

    function refresh() {
        if (fetch.running)
            return;
        root.loading = true;
        fetch.running = true;
    }

    property Process fetch: Process {
        command: ["curl", "-sS", "-m", "12",
            "https://wttr.in/" + (root.city !== "" ? encodeURIComponent(root.city) : "") + "?format=j1"]
        stdout: StdioCollector {
            onStreamFinished: root.parse(text)
        }
        onExited: root.loading = false
    }

    property Timer poll: Timer {
        interval: 30 * 60 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}

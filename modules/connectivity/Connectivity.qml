import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// Connectivity — nearby Wi-Fi networks and Bluetooth devices, with password auth.
PanelWindow {
    id: root

    required property var targetScreen

    property var wifi: []
    property var bt: []
    property string targetSsid: ""
    property string error: ""

    screen: targetScreen
    visible: ShellState.overlay === "connectivity"
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    anchors.top: true; anchors.bottom: true; anchors.left: true; anchors.right: true

    function refreshWifi() { if (!wifiScan.running) wifiScan.running = true }
    function refreshBt() { if (!btScan.running) btScan.running = true }

    function connectWifi(ssid, security) {
        if (security !== "" && security !== "--" ) {
            root.targetSsid = ssid;
            pwField.text = "";
            return;
        }
        runner.command = ["nmcli", "device", "wifi", "connect", ssid];
        runner.running = true;
    }

    function submitPassword() {
        if (root.targetSsid === "" || pwField.text === "")
            return;
        runner.command = ["nmcli", "device", "wifi", "connect", root.targetSsid, "password", pwField.text];
        runner.running = true;
        root.targetSsid = "";
    }

    Process {
        id: wifiScan
        command: ["sh", "-c", "nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list --rescan yes 2>/dev/null"]
        stdout: StdioCollector { onStreamFinished: {
            var out = [];
            var lines = ("" + text).split("\n");
            for (var i = 0; i < lines.length; i++) {
                var f = lines[i].split(":");
                if (f.length < 4) continue;
                out.push({ active: f[0] === "*", ssid: f[1], signal: f[2], security: f[3] });
            }
            root.wifi = out;
        } }
    }

    Process {
        id: btScan
        command: ["sh", "-c", "bluetoothctl devices 2>/dev/null | sed 's/^Device //'"]
        stdout: StdioCollector { onStreamFinished: {
            var out = [];
            var lines = ("" + text).split("\n");
            for (var i = 0; i < lines.length; i++) {
                var f = lines[i].split(" ");
                if (f.length < 2) continue;
                out.push({ mac: f[0], name: lines[i].substring(lines[i].indexOf(" ") + 1) });
            }
            root.bt = out;
        } }
    }

    Process {
        id: runner
        onExited: exitCode => { root.refreshWifi(); root.error = exitCode === 0 ? "" : I18n.t("connectivity.failed"); }
    }

    Timer { interval: 12000; running: root.visible; repeat: true; onTriggered: { root.refreshWifi(); root.refreshBt() } }
    onVisibleChanged: if (visible) { root.refreshWifi(); root.refreshBt() }

    MouseArea { anchors.fill: parent; onClicked: ShellState.closeOverlay() }

    McPanel {
        liquid: true
        width: 720; height: 540
        anchors.centerIn: parent
        background: Theme.panel
        texture: Theme.texturePath(Theme.panelTexture)

        MouseArea { anchors.fill: parent }

        Column {
            anchors.fill: parent; anchors.margins: 12; spacing: 8

            Row {
                width: parent.width
                PixelText { text: I18n.t("connectivity.title"); font.pixelSize: Theme.raw(18); color: Theme.gold; styleColor: Theme.panelTextShadow }
                Item { width: parent.width - 200; height: 1 }
                McButton { width: 90; height: 26; label: I18n.t("common.close"); onClicked: ShellState.closeOverlay() }
            }

            PixelText { text: I18n.t("connectivity.wifi") + "  (" + root.wifi.length + ")"; font.pixelSize: Theme.raw(12); color: Theme.textOnPanel; styleColor: Theme.panelTextShadow }

            Flickable {
                width: parent.width; height: 200; clip: true
                contentHeight: wifiGrid.height
                Grid {
                    id: wifiGrid; width: parent.width; columns: 2; spacing: 4
                    Repeater {
                        model: root.wifi
                        delegate: McButton {
                            width: (wifiGrid.width - 4) / 2; height: 26
                            label: modelData.ssid + "  " + modelData.signal + "%" + (modelData.security !== "" && modelData.security !== "--" ? " 🔒" : "")
                            checked: modelData.active
                            onClicked: root.connectWifi(modelData.ssid, modelData.security)
                        }
                    }
                }
            }

            Row {
                width: parent.width; spacing: 6
                visible: root.targetSsid !== ""
                PixelText { text: I18n.t("connectivity.password") + " " + root.targetSsid; width: 240; font.pixelSize: Theme.raw(12); color: Theme.textOnPanel; styleColor: Theme.panelTextShadow }
                McTextField { id: pwField; width: 220; height: 26; placeholder: I18n.t("connectivity.password") }
                McButton { width: 80; height: 26; label: I18n.t("connectivity.connect"); onClicked: root.submitPassword() }
            }

            PixelText { width: parent.width; text: root.error; font.pixelSize: Theme.raw(11); color: Theme.red; styleColor: Theme.panelTextShadow }

            PixelText { text: I18n.t("connectivity.bt") + "  (" + root.bt.length + ")"; font.pixelSize: Theme.raw(12); color: Theme.textOnPanel; styleColor: Theme.panelTextShadow }
            Flickable {
                width: parent.width; height: 140; clip: true
                contentHeight: btGrid.height
                Grid {
                    id: btGrid; width: parent.width; columns: 2; spacing: 4
                    Repeater {
                        model: root.bt
                        delegate: McButton {
                            width: (btGrid.width - 4) / 2; height: 26
                            label: modelData.name
                            onClicked: {
                                runner.command = ["bluetoothctl", "connect", modelData.mac];
                                runner.running = true;
                            }
                        }
                    }
                }
            }
        }
    }
}

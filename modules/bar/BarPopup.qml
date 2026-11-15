import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Mpris
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// BarPopup — dropdowns anchored under the bar: the calendar and the media player.
PanelWindow {
    id: root

    required property var targetScreen

    readonly property string mode: ShellState.barPopup
    readonly property bool opened: mode !== ""
    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    readonly property string userName: Quickshell.env("USER") || "player"
    readonly property string avatarPath: "file://" + (Quickshell.env("HOME") || "") + "/.face"
    property bool hasAvatar: false
    property string hostName: ""

    Process {
        command: ["hostname"]
        stdout: StdioCollector {
            onStreamFinished: menuHost.text = text.trim()
        }
    }

    // calendar state
    property int viewYear: new Date().getFullYear()
    property int viewMonth: new Date().getMonth()
    readonly property var today: new Date()

    function shiftMonth(delta) {
        var m = root.viewMonth + delta;
        var y = root.viewYear;
        while (m < 0) { m += 12; y -= 1; }
        while (m > 11) { m -= 12; y += 1; }
        root.viewYear = y;
        root.viewMonth = m;
    }

    function daysInMonth(y, m) {
        return new Date(y, m + 1, 0).getDate();
    }

    function firstWeekday(y, m) {
        return new Date(y, m, 1).getDay();
    }

    screen: targetScreen
    visible: opened
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay

    anchors.top: true
    anchors.left: true
    anchors.right: true
    anchors.bottom: true

    // click outside closes
    MouseArea {
        anchors.fill: parent
        onClicked: ShellState.closeBarPopup()
    }

    McPanel {
        width: root.mode === "stats" ? 400 : (root.mode === "calendar" ? 360 : (root.mode === "media" ? 400 : 320))
        height: root.mode === "stats"
            ? Math.min(parent.height - Theme.barHeight - 24, statsCol.implicitHeight + 24) : (root.mode === "calendar" ? 330 : (root.mode === "media" ? 244 : 268))
        x: (root.mode === "user" || root.mode === "stats")
            ? (ShellState.barPopupX >= 0
                ? Math.round(Math.max(8, Math.min(parent.width - width - 8, ShellState.barPopupX - width / 2)))
                : parent.width - width - 96)
            : Math.round((parent.width - width) / 2)
        anchors.top: parent.top
        anchors.topMargin: Theme.barHeight + 6
        liquid: true
        background: Theme.panel
        texture: Theme.texturePath(Theme.panelTexture)
        textureOpacity: 0.35

        MouseArea { anchors.fill: parent } // swallow clicks

        // ------------------------------------------------------------- calendar
        Column {
            visible: root.mode === "calendar"
            anchors.fill: parent
            anchors.margins: 10
            spacing: 6

            Row {
                width: parent.width
                spacing: 6

                McButton {
                    width: 30; height: 26
                    label: "◀"
                    onClicked: root.shiftMonth(-1)
                }

                PixelText {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 150
                    horizontalAlignment: Text.AlignHCenter
                    text: root.viewYear + " · " + Util.pad2(root.viewMonth + 1)
                    font.pixelSize: Theme.fontLarge
                    color: Theme.textOnPanel
                    styleColor: Theme.panelTextShadow
                }

                McButton {
                    width: 30; height: 26
                    label: "▶"
                    onClicked: root.shiftMonth(1)
                }

                McButton {
                    width: 62; height: 26
                    label: I18n.t("calendar.today")
                    onClicked: {
                        var d = new Date();
                        root.viewYear = d.getFullYear();
                        root.viewMonth = d.getMonth();
                    }
                }
            }

            PixelText {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: I18n.t("calendar.weekdays")
                font.pixelSize: 10
                color: Theme.textHints
                styleColor: Theme.panelTextShadow
            }

            Grid {
                id: dayGrid
                width: parent.width
                columns: 7
                spacing: 2
                property int firstDay: root.firstWeekday(root.viewYear, root.viewMonth)
                property int total: root.daysInMonth(root.viewYear, root.viewMonth)

                Repeater {
                    model: dayGrid.firstDay + dayGrid.total

                    delegate: Rectangle {
                        readonly property int day: index - dayGrid.firstDay + 1
                        readonly property bool inMonth: day >= 1 && day <= dayGrid.total
                        readonly property bool isToday: inMonth
                            && root.today.getDate() === day
                            && root.today.getMonth() === root.viewMonth
                            && root.today.getFullYear() === root.viewYear

                        width: Math.floor((dayGrid.width - 6 * 2) / 7)
                        height: 30
                        color: isToday ? Theme.gold : "transparent"
                        border.width: 1
                        border.color: Theme.bevelDark

                        PixelText {
                            anchors.centerIn: parent
                            text: inMonth ? day : ""
                            font.pixelSize: 11
                            color: isToday ? "#1a1a1a" : Theme.textOnPanel
                            styleColor: Theme.panelTextShadow
                        }
                    }
                }
            }
        }

        // ----------------------------------------------------------------- user
        Column {
            visible: root.mode === "user"
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            Row {
                width: parent.width
                spacing: 10

                Item {
                    width: 64
                    height: 64

                    Rectangle {
                        anchors.fill: parent
                        color: Theme.panelDark
                        border.width: 2
                        border.color: Theme.outline
                    }

                    Image {
                        anchors.fill: parent
                        anchors.margins: 2
                        source: root.avatarPath
                        fillMode: Image.PreserveAspectCrop
                        smooth: false
                        visible: root.hasAvatar
                        onStatusChanged: root.hasAvatar = (status === Image.Ready)
                    }
                }

                Column {
                    width: parent.width - 74
                    spacing: 3

                    PixelText {
                        width: parent.width
                        elide: Text.ElideRight
                        text: root.userName
                        font.pixelSize: Theme.fontLarge
                        color: Theme.textOnPanel
                        styleColor: Theme.panelTextShadow
                    }
                    PixelText {
                        id: menuHost
                        width: parent.width
                        elide: Text.ElideRight
                        font.pixelSize: 10
                        color: Theme.textOnPanel
                        styleColor: Theme.panelTextShadow
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.bevelDark }

            PixelText {
                width: parent.width
                text: I18n.t("user.uptime") + "  "
                    + Math.floor(Stats.uptime / 3600) + "h "
                    + Math.floor((Stats.uptime % 3600) / 60) + "m"
                font.pixelSize: 10
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
            PixelText {
                width: parent.width
                text: I18n.t("user.session") + "  " + Compositor.backend + " · MC-shell"
                font.pixelSize: 10
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }

            McButton {
                width: parent.width
                height: 26
                label: ShellState.keepAwake ? I18n.t("user.awakeOn") : I18n.t("user.keepAwake")
                checked: ShellState.keepAwake
                onClicked: ShellState.keepAwake = !ShellState.keepAwake
            }

            McButton {
                width: parent.width
                height: 26
                label: I18n.t("common.close")
                onClicked: ShellState.closeBarPopup()
            }
        }

        // ---------------------------------------------------------------- stats
        Column {
            id: statsCol
            visible: root.mode === "stats"
            anchors.fill: parent
            anchors.margins: 12
            spacing: 6

            PixelText {
                width: parent.width
                text: I18n.t("widget.stats")
                font.pixelSize: Theme.fontLarge
                color: Theme.gold
                styleColor: Theme.panelTextShadow
            }

            // cpu
            Row {
                width: parent.width
                spacing: 8
                PixelText {
                    width: 54
                    text: "CPU"
                    font.pixelSize: 10
                    color: Theme.textOnPanel
                    styleColor: Theme.panelTextShadow
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 130
                    height: 12
                    color: Theme.panelDark
                    border.width: 1
                    border.color: Theme.outline
                    Rectangle {
                        height: parent.height - 2
                        y: 1; x: 1
                        width: Math.max(0, (parent.width - 2) * Stats.cpu)
                        color: Stats.cpu > 0.8 ? Theme.red : (Stats.cpu > 0.5 ? Theme.gold : Theme.grass)
                    }
                }
                PixelText {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 48
                    text: Math.round(Stats.cpu * 100) + "%"
                    font.pixelSize: 10
                    color: Theme.textOnPanel
                    styleColor: Theme.panelTextShadow
                }
            }

            // memory
            Row {
                width: parent.width
                spacing: 8
                PixelText {
                    width: 54
                    text: "MEM"
                    font.pixelSize: 10
                    color: Theme.textOnPanel
                    styleColor: Theme.panelTextShadow
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 130
                    height: 12
                    color: Theme.panelDark
                    border.width: 1
                    border.color: Theme.outline
                    Rectangle {
                        height: parent.height - 2
                        y: 1; x: 1
                        width: Math.max(0, (parent.width - 2) * Stats.mem)
                        color: Theme.xp
                    }
                }
                PixelText {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 60
                    text: Stats.memUsed.toFixed(1) + "/" + Stats.memTotal.toFixed(0) + "G"
                    font.pixelSize: 10
                    color: Theme.textOnPanel
                    styleColor: Theme.panelTextShadow
                }
            }

            // swap (only when present)
            Row {
                width: parent.width
                spacing: 8
                visible: Stats.swapTotal > 0.05
                PixelText {
                    width: 54
                    text: "SWAP"
                    font.pixelSize: 10
                    color: Theme.textOnPanel
                    styleColor: Theme.panelTextShadow
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 130
                    height: 10
                    color: Theme.panelDark
                    border.width: 1
                    border.color: Theme.outline
                    Rectangle {
                        height: parent.height - 2
                        y: 1; x: 1
                        width: Math.max(0, (parent.width - 2) * (Stats.swapTotal > 0 ? Stats.swapUsed / Stats.swapTotal : 0))
                        color: Theme.gold
                    }
                }
                PixelText {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 60
                    text: Stats.swapUsed.toFixed(1) + "G"
                    font.pixelSize: 10
                    color: Theme.textOnPanel
                    styleColor: Theme.panelTextShadow
                }
            }

            // per-partition disk usage
            Repeater {
                model: Stats.disks

                delegate: Row {
                    width: parent.width
                    spacing: 8

                    PixelText {
                        width: 74
                        elide: Text.ElideRight
                        text: modelData.mount
                        font.pixelSize: 9
                        color: Theme.textOnPanel
                        styleColor: Theme.panelTextShadow
                    }
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 150
                        height: 10
                        color: Theme.panelDark
                        border.width: 1
                        border.color: Theme.outline
                        Rectangle {
                            height: parent.height - 2
                            y: 1; x: 1
                            width: Math.max(0, (parent.width - 2) * modelData.ratio)
                            color: modelData.ratio > 0.85 ? Theme.red : Theme.gold
                        }
                    }
                    PixelText {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 62
                        horizontalAlignment: Text.AlignRight
                        text: Stats.diskText(modelData.used, modelData.total)
                        font.pixelSize: 9
                        color: Theme.textOnPanel
                        styleColor: Theme.panelTextShadow
                    }
                }
            }

            // per-interface network rate
            Repeater {
                model: Stats.nets

                delegate: Row {
                    width: parent.width
                    spacing: 6

                    PixelText {
                        width: 74
                        elide: Text.ElideRight
                        text: modelData.name
                        font.pixelSize: 9
                        color: Theme.textOnPanel
                        styleColor: Theme.panelTextShadow
                    }
                    PixelText {
                        width: parent.width - 80
                        text: "↓ " + Stats.rateText(modelData.rx) + "    ↑ " + Stats.rateText(modelData.tx)
                        font.pixelSize: 9
                        color: Theme.textOnPanel
                        styleColor: Theme.panelTextShadow
                    }
                }
            }

            PixelText {
                width: parent.width
                text: I18n.t("stats.load") + "  " + Stats.load1.toFixed(2) + " / "
                    + Stats.load5.toFixed(2) + " / " + Stats.load15.toFixed(2)
                font.pixelSize: 10
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }
            PixelText {
                width: parent.width
                text: I18n.t("stats.uptime") + "  " + Math.floor(Stats.uptime / 3600) + "h "
                    + Math.floor((Stats.uptime % 3600) / 60) + "m   ·   "
                    + I18n.t("stats.processes") + " " + Stats.processes
                font.pixelSize: 10
                color: Theme.textOnPanel
                styleColor: Theme.panelTextShadow
            }

            Rectangle { width: parent.width; height: 1; color: Theme.bevelDark }

            PixelText {
                width: parent.width
                text: I18n.t("stats.top")
                font.pixelSize: 9
                color: Theme.textHints
                styleColor: Theme.panelTextShadow
            }

            Repeater {
                model: Stats.top

                delegate: Row {
                    width: parent.width
                    spacing: 6

                    PixelText {
                        width: parent.width - 96
                        elide: Text.ElideRight
                        text: modelData.name
                        font.pixelSize: 9
                        color: Theme.textOnPanel
                        styleColor: Theme.panelTextShadow
                    }
                    PixelText {
                        width: 44
                        horizontalAlignment: Text.AlignRight
                        text: modelData.cpu.toFixed(1) + "%"
                        font.pixelSize: 9
                        color: Theme.textOnPanel
                        styleColor: Theme.panelTextShadow
                    }
                    PixelText {
                        width: 40
                        horizontalAlignment: Text.AlignRight
                        text: modelData.mem.toFixed(1) + "%"
                        font.pixelSize: 9
                        color: Theme.textHints
                        styleColor: Theme.panelTextShadow
                    }
                }
            }
        }

        // ---------------------------------------------------------------- media
        Column {
            visible: root.mode === "media"
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8

            Row {
                width: parent.width
                spacing: 10

                Image {
                    width: 92
                    height: 92
                    fillMode: Image.PreserveAspectCrop
                    smooth: false
                    visible: root.player !== null && root.player.trackArtUrl !== ""
                    source: root.player ? (root.player.trackArtUrl || "") : ""
                }

                Column {
                    width: parent.width - 102
                    spacing: 3

                    PixelText {
                        width: parent.width
                        elide: Text.ElideRight
                        text: root.player ? (root.player.trackTitle || "?") : I18n.t("control.nothingPlaying")
                        font.pixelSize: Theme.fontNormal
                        color: Theme.textOnPanel
                        styleColor: Theme.panelTextShadow
                    }
                    PixelText {
                        width: parent.width
                        elide: Text.ElideRight
                        text: root.player ? (root.player.trackArtist || "") : ""
                        font.pixelSize: Theme.fontSmall
                        color: Theme.textOnPanel
                        styleColor: Theme.panelTextShadow
                    }
                    PixelText {
                        width: parent.width
                        elide: Text.ElideRight
                        text: root.player ? (root.player.trackAlbum || "") : ""
                        font.pixelSize: 9
                        color: Theme.textHints
                        styleColor: Theme.panelTextShadow
                    }
                }
            }

            // progress
            Rectangle {
                width: parent.width
                height: 10
                color: Theme.panelDark
                border.width: 1
                border.color: Theme.outline

                Rectangle {
                    height: parent.height - 2
                    y: 1
                    x: 1
                    width: Math.max(0, (parent.width - 2) * (root.player && root.player.length > 0
                        ? Math.min(1, root.player.position / root.player.length) : 0))
                    color: Theme.grass
                }
            }

            // time-synced lyrics (lrclib)
            Column {
                width: parent.width
                spacing: 2

                PixelText {
                    width: parent.width
                    elide: Text.ElideRight
                    text: Lyrics.loading ? I18n.t("music.lyrics.loading")
                        : (Lyrics.current !== "" ? Lyrics.current : I18n.t("music.lyrics.none"))
                    font.pixelSize: Theme.fontNormal
                    color: Lyrics.current !== "" ? Theme.gold : Theme.textHints
                    styleColor: Theme.panelTextShadow
                }
                PixelText {
                    width: parent.width
                    elide: Text.ElideRight
                    visible: Lyrics.next !== ""
                    text: Lyrics.next
                    font.pixelSize: Theme.fontSmall
                    color: Theme.textOnPanel
                    styleColor: Theme.panelTextShadow
                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                McButton {
                    width: 44; height: 28
                    label: "|◀"
                    enabledButton: root.player && root.player.canGoPrevious
                    onClicked: if (root.player) root.player.previous()
                }
                McButton {
                    width: 56; height: 28
                    label: root.player && root.player.isPlaying ? "||" : "▶"
                    onClicked: if (root.player) root.player.togglePlaying()
                }
                McButton {
                    width: 44; height: 28
                    label: "▶|"
                    enabledButton: root.player && root.player.canGoNext
                    onClicked: if (root.player) root.player.next()
                }
            }
        }
    }
}

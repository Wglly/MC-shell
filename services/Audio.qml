pragma Singleton
import QtQuick
import Quickshell.Services.Pipewire
import qs.modules.common

// Audio.qml — the default sink, wrapped so every surface agrees on volume,
// mute state and the OSD feedback.
QtObject {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink ? sink.audio : null
    readonly property real volume: audio ? audio.volume : 0
    readonly property bool muted: audio ? audio.muted : false
    readonly property string label: audio
        ? (audio.muted ? "MUTE" : Math.round(audio.volume * 100) + "%")
        : "--"

    function setVolume(v) {
        if (!root.audio)
            return;
        root.audio.volume = Math.max(0, Math.min(1, v));
        if (root.audio.muted)
            root.audio.muted = false;
        ShellState.flashOsd("volume", root.audio.volume);
    }

    function step(delta) {
        root.setVolume(root.volume + delta * 0.05);
    }

    function toggleMute() {
        if (!root.audio)
            return;
        root.audio.muted = !root.audio.muted;
        ShellState.flashOsd("volume", root.audio.muted ? 0 : root.audio.volume);
    }
}

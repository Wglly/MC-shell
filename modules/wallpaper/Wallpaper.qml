import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.services

// Wallpaper — MC-shell's own background layer.
//
// Drawing it ourselves means the same config works on Hyprland and niri; users
// who already run hyprpaper/swaybg can simply leave it disabled.
PanelWindow {
    id: root

    required property var targetScreen

    readonly property bool enabled: Settings.get("wallpaper.enabled", false) === true
    readonly property string imagePath: Settings.get("wallpaper.path", "")
    readonly property string mode: Settings.get("wallpaper.fillMode", "fill")

    screen: targetScreen
    visible: enabled
    color: Settings.get("wallpaper.color", "#101418")
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Background

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    Image {
        anchors.fill: parent
        visible: root.imagePath !== ""
        source: root.imagePath !== "" ? (root.imagePath.indexOf("file://") === 0
            ? root.imagePath : "file://" + root.imagePath) : ""
        fillMode: root.mode === "fit" ? Image.PreserveAspectFit
            : root.mode === "tile" ? Image.Tile
            : Image.PreserveAspectCrop
        smooth: true
        asynchronous: true
    }

    // subtle vignette so the pixel HUD stays readable
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#40000000" }
            GradientStop { position: 0.35; color: "#00000000" }
            GradientStop { position: 1.0; color: "#60000000" }
        }
    }
}

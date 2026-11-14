pragma Singleton
import QtQuick

// Theme.qml — the single source of truth for MC-shell's look.
//
// Everything is deliberately "blocky": no corner radii, 2px bevels, a pixel
// font and Minecraft's GUI palette.  If you want to re-skin the shell, this is
// the only file you should need to touch.
QtObject {
    id: theme

    // ---------------------------------------------------------------- fonts
    // Overwritten by the FontLoader in shell.qml once Monocraft is ready.
    property string fontFamily: "Monocraft"
    readonly property int fontSmall: 12
    readonly property int fontNormal: 14
    readonly property int fontLarge: 18
    readonly property int fontTitle: 22

    // ------------------------------------------------------------- palette
    readonly property color outline: "#1a1a1a"
    readonly property color bevelLight: "#ffffff"
    readonly property color bevelDark: "#4a4a4a"

    readonly property color panel: "#c6c6c6"        // classic GUI gray
    readonly property color panelDark: "#8b8b8b"
    readonly property color slot: "#8b8b8b"
    readonly property color slotDark: "#373737"

    readonly property color text: "#f4f4f4"
    readonly property color textShadow: "#3a3a3a"
    readonly property color textDim: "#b9b9b9"
    readonly property color textOnPanel: "#3f3f3f"

    // Writable so shell.qml can bind them to Settings.theme.* without the
    // common module having to import services (avoids a cyclic import).
    property color grass: "#5fbf4f"
    property color gold: "#ffcc4d"
    readonly property color red: "#e04a3f"
    readonly property color diamond: "#4fd6d6"
    readonly property color lapis: "#3f6fd0"
    readonly property color xp: "#7ef03a"
    readonly property color xpDark: "#2f7a12"

    // -------------------------------------------------------------- sizing
    readonly property int barHeight: 40
    readonly property int slotSize: 34
    readonly property int gap: 6
    readonly property int pad: 10

    // ------------------------------------------------------------- helpers
    // Texture names live in assets/textures/<name>.png
    function texturePath(name) {
        var n = ("" + (name || "deepslate")).replace(/[^a-z_]/g, "");
        return Qt.resolvedUrl("../../assets/textures/" + n + ".png");
    }
}

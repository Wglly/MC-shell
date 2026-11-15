import QtQuick
import qs.modules.common

// McPanel — a Minecraft GUI frame: black outline, 2px bevel, optional tiled
// texture.  The classic inventory window look, reusable for every surface.
Item {
    id: root

    property color background: Theme.panel
    property color outlineColor: Theme.outline
    property string texture: ""
    property real textureOpacity: 0.55
    // Tile keeps pixel textures crisp; Stretch is used for long gradient bars.
    property int textureFillMode: Image.Tile
    property int bevel: Theme.bevelSize
    // 0 = flat frame, 1 = classic inset GUI look
    property bool inset: false

    property bool liquid: false
    readonly property real radius: Theme.cornerRadius > 0 && root.liquid ? Theme.cornerRadius + 6 : Theme.cornerRadius
    readonly property bool glass: Theme.cornerRadius > 0

    default property alias content: contentItem.data

    implicitWidth: 200
    implicitHeight: 120

    // 1. frame
    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.glass ? Theme.glassBorder : root.outlineColor
    }

    // 2. base fill
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: Math.max(0, root.radius - 1)
        color: root.glass
            ? Qt.rgba(root.background.r, root.background.g, root.background.b,
                      Math.min(1, Theme.glassOpacity * (root.liquid ? 0.66 : 1.0)))
            : root.background
    }

    // glass sheen
    Rectangle {
        visible: root.glass
        anchors.fill: parent
        anchors.margins: 2
        radius: Math.max(0, root.radius - 2)
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.liquid ? "#5cffffff" : "#38ffffff" }
            GradientStop { position: 0.45; color: "#00ffffff" }
            GradientStop { position: 1.0; color: root.liquid ? "#1f000000" : "#12000000" }
        }
    }

    // 3. tiled pixel texture
    Image {
        anchors.fill: parent
        anchors.margins: 1
        source: root.texture
        fillMode: root.textureFillMode
        opacity: root.textureOpacity
        visible: root.texture !== "" && !root.glass
        smooth: false
        mipmap: false
    }

    // 4. bevel: light on top/left, dark on bottom/right
    Rectangle {
        visible: !root.glass
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 1 }
        height: root.bevel
        color: Theme.bevelLight
        opacity: root.inset ? 0.55 : 1.0
    }
    Rectangle {
        visible: !root.glass
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom; margins: 1 }
        width: root.bevel
        color: Theme.bevelLight
        opacity: root.inset ? 0.55 : 1.0
    }
    Rectangle {
        visible: !root.glass
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 1 }
        height: root.bevel
        color: Theme.bevelDark
    }
    Rectangle {
        visible: !root.glass
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom; margins: 1 }
        width: root.bevel
        color: Theme.bevelDark
    }

    // 5. content
    Item {
        id: contentItem
        anchors.fill: parent
        anchors.margins: root.bevel + 2
    }
}

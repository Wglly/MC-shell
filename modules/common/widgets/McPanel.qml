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
    property int bevel: 2
    // 0 = flat frame, 1 = classic inset GUI look
    property bool inset: false

    default property alias content: contentItem.data

    implicitWidth: 200
    implicitHeight: 120

    // 1. hard black outline
    Rectangle {
        anchors.fill: parent
        color: root.outlineColor
    }

    // 2. base fill
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: root.background
    }

    // 3. tiled pixel texture
    Image {
        anchors.fill: parent
        anchors.margins: 1
        source: root.texture
        fillMode: root.textureFillMode
        opacity: root.textureOpacity
        visible: root.texture !== ""
        smooth: false
        mipmap: false
    }

    // 4. bevel: light on top/left, dark on bottom/right
    Rectangle {
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 1 }
        height: root.bevel
        color: Theme.bevelLight
        opacity: root.inset ? 0.55 : 1.0
    }
    Rectangle {
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom; margins: 1 }
        width: root.bevel
        color: Theme.bevelLight
        opacity: root.inset ? 0.55 : 1.0
    }
    Rectangle {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 1 }
        height: root.bevel
        color: Theme.bevelDark
    }
    Rectangle {
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

import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// CaptureCard — screenshot / screen recording buttons.
McPanel {
    id: root

    implicitWidth: 260
    implicitHeight: 150
    background: Theme.cardBg
    texture: Theme.texturePath("bedrock")
    textureOpacity: 0.3

    readonly property bool shotEnabled: Settings.get("capture.screenshot", true) === true
    readonly property bool recEnabled: Settings.get("capture.record", true) === true

    Connections {
        target: Capture
        function onShotDone(path, ok) {
            Notifs.toast(ok ? I18n.t("capture.shotSaved") : I18n.t("capture.failed"),
                         path.split("/").pop());
        }
        function onRecordDone(path, ok) {
            if (!root.recEnabled)
                return;
            Notifs.toast(ok ? (Capture.recording ? I18n.t("capture.recording") : I18n.t("capture.recSaved"))
                            : I18n.t("capture.failed"),
                         path.split("/").pop());
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        PixelText {
            width: parent.width
            text: I18n.t("widget.capture")
            font.pixelSize: Theme.fs(Theme.fontSmall)
            color: Theme.cardTitle
        }

        McButton {
            width: parent.width
            height: 28
            visible: root.shotEnabled
            label: I18n.t("capture.shot")
            onClicked: Capture.screenshot()
        }

        McButton {
            width: parent.width
            height: 28
            visible: root.recEnabled
            label: Capture.recording ? I18n.t("capture.stop") : I18n.t("capture.record")
            checked: Capture.recording
            onClicked: Capture.toggleRecording()
        }

        PixelText {
            width: parent.width
            elide: Text.ElideRight
            text: Capture.recording ? I18n.t("capture.recording")
                : (Capture.lastShot !== "" ? Capture.lastShot.split("/").pop() : I18n.t("capture.hint"))
            font.pixelSize: Theme.fs(9)
            color: Theme.cardTextDim
        }
    }
}

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets
import qs.services

// SettingsWindow — the options screen with one tab per feature group.
PanelWindow {
    id: root

    visible: ShellState.overlay === "settings"
    color: "transparent"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    property int tab: ShellState.settingsTab

    readonly property var tabs: [
        { key: "general", page: "pages/GeneralPage.qml" },
        { key: "wallpaper", page: "pages/WallpaperPage.qml" },
        { key: "bar", page: "pages/BarPage.qml" },
        { key: "theme", page: "pages/ThemePage.qml" },
        { key: "dock", page: "pages/DockPage.qml" },
        { key: "widgets", page: "pages/WidgetsPage.qml" },
        { key: "sidebars", page: "pages/SidebarsPage.qml" },
        { key: "overview", page: "pages/OverviewPage.qml" }
    ]

    Rectangle {
        anchors.fill: parent
        color: "#05070a"
        opacity: 0.5
        MouseArea {
            anchors.fill: parent
            onClicked: ShellState.closeOverlay()
        }
    }

    McPanel {
        id: panel
        anchors.centerIn: parent
        width: Math.min(980, parent.width - 80)
        height: Math.min(660, parent.height - 100)
        background: Theme.panel
        texture: Theme.texturePath(Settings.get("theme.panelTexture", "dirt"))
        textureOpacity: 0.22

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            RowLayout {
                Layout.fillWidth: true

                PixelText {
                    text: I18n.t("settings.title")
                    font.pixelSize: Theme.fontTitle
                    color: Theme.textOnPanel
                    styleColor: "#ffffff"
                }
                Item { Layout.fillWidth: true }
                PixelText {
                    text: I18n.languageLabel
                    font.pixelSize: 10
                    color: "#6a6a6a"
                    styleColor: "#ffffff"
                }
                McButton {
                    implicitWidth: 38
                    label: "X"
                    onClicked: ShellState.closeOverlay()
                }
            }

            Rectangle { Layout.fillWidth: true; height: 2; color: "#8a8a8a" }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                // ------------------------------------------------------- tabs
                Column {
                    Layout.preferredWidth: 150
                    Layout.alignment: Qt.AlignTop
                    spacing: 4

                    Repeater {
                        model: root.tabs

                        delegate: McButton {
                            width: 146
                            label: I18n.t("settings.tab." + modelData.key)
                            checked: root.tab === index
                            onClicked: ShellState.settingsTab = index
                        }
                    }
                }

                Rectangle { Layout.preferredWidth: 2; Layout.fillHeight: true; color: "#9a9a9a" }

                // ---------------------------------------------------- content
                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignTop
                    clip: true
                    contentWidth: width
                    contentHeight: pageLoader.implicitHeight
                    boundsBehavior: Flickable.StopAtBounds

                    Loader {
                        id: pageLoader
                        width: parent.width - 12
                        source: root.tabs[root.tab].page
                    }
                }
            }
        }
    }

    // Esc closes; clicks outside the panel already do.
    Item {
        anchors.fill: parent
        focus: root.visible
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                ShellState.closeOverlay();
                event.accepted = true;
            }
        }
    }

    onVisibleChanged: if (visible) ShellState.settingsTab = 0
}

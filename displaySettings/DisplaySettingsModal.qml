import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import qs.Common
import qs.Modals.Common
import qs.Services
import qs.Widgets

DankModal {
    id: root

    layerNamespace: "dms:plugins:displaySettings"
    keepPopoutsOpen: true

    HyprlandFocusGrab {
        windows: [root.contentWindow]
        active: root.useHyprlandFocusGrab && root.shouldHaveFocus
    }

    property int selectedIndex: 0
    property int optionCount: DisplaySettingsService.displays.length
    property rect parentBounds: Qt.rect(0, 0, 0, 0)

    function openCentered() {
        parentBounds = Qt.rect(0, 0, 0, 0);
        backgroundOpacity = 0.5;
        open();
    }

    shouldBeVisible: false
    width: 320
    height: contentLoader.item ? contentLoader.item.implicitHeight : 300
    enableShadow: true
    positioning: parentBounds.width > 0 ? "custom" : "center"
    customPosition: {
        if (parentBounds.width > 0) {
            const centerX = parentBounds.x + (parentBounds.width - width) / 2;
            const centerY = parentBounds.y + (parentBounds.height - height) / 2;
            return Qt.point(centerX, centerY);
        }
        return Qt.point(0, 0);
    }
    onBackgroundClicked: () => {
        return close();
    }
    onOpened: () => {
        selectedIndex = 0;
        Qt.callLater(() => modalFocusScope.forceActiveFocus());
    }
    modalFocusScope.Keys.onPressed: event => {
        switch (event.key) {
        case Qt.Key_Up:
        case Qt.Key_Backtab:
            selectedIndex = (selectedIndex - 1 + optionCount) % optionCount;
            event.accepted = true;
            break;
        case Qt.Key_Down:
        case Qt.Key_Tab:
            selectedIndex = (selectedIndex + 1) % optionCount;
            event.accepted = true;
            break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
            DisplaySettingsService.toggleDisable(DisplaySettingsService.displays[selectedIndex]);
            event.accepted = true;
            break;
        case Qt.Key_N:
            if (event.modifiers & Qt.ControlModifier) {
                selectedIndex = (selectedIndex + 1) % optionCount;
                event.accepted = true;
            }
            break;
        case Qt.Key_P:
            if (event.modifiers & Qt.ControlModifier) {
                selectedIndex = (selectedIndex - 1 + optionCount) % optionCount;
                event.accepted = true;
            }
            break;
        case Qt.Key_J:
            if (event.modifiers & Qt.ControlModifier) {
                selectedIndex = (selectedIndex + 1) % optionCount;
                event.accepted = true;
            }
            break;
        case Qt.Key_K:
            if (event.modifiers & Qt.ControlModifier) {
                selectedIndex = (selectedIndex - 1 + optionCount) % optionCount;
                event.accepted = true;
            }
            break;
        }
    }

    content: Component {
        Item {
            anchors.fill: parent
            implicitHeight: mainColumn.implicitHeight + Theme.spacingL * 2

            Column {
                id: mainColumn
                anchors.fill: parent
                anchors.margins: Theme.spacingL
                spacing: Theme.spacingM

                Row {
                    width: parent.width

                    StyledText {
                        text: I18n.tr("Toggle Display")
                        font.pixelSize: Theme.fontSizeLarge
                        color: Theme.surfaceText
                        font.weight: Font.Medium
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item {
                        width: parent.width - 150
                        height: 1
                    }

                    DankActionButton {
                        iconName: "close"
                        iconSize: Theme.iconSize - 4
                        iconColor: Theme.surfaceText
                        onClicked: () => {
                            return close();
                        }
                    }
                }

                DankListView {
                    width: parent.width
                    spacing: Theme.spacingS
                    height: (50 * root.optionCount) + Theme.spacingS
                    model: ScriptModel {
                        values: [...DisplaySettingsService.displays]
                    }

                    delegate: Rectangle {
                        required property var modelData
                        required property int index

                        width: parent.width
                        height: 50
                        radius: Theme.cornerRadius

                        color: {
                            if (selectedIndex === index) {
                                return Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12);
                            } else if (hoverArea.containsMouse) {
                                return Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.08);
                            } else {
                                return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.08);
                            }
                        }
                        border.color: selectedIndex === index ? Theme.primary : "transparent"
                        border.width: selectedIndex === index ? 1 : 0

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: Theme.spacingM
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: Theme.spacingM

                            DankIcon {
                                name: "computer"
                                size: Theme.iconSize
                                color: Theme.surfaceText
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: I18n.tr(`Display: ${modelData.name}`)
                                font.pixelSize: Theme.fontSizeMedium
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: hoverArea

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: () => {
                                DisplaySettingsService.toggleDisabled(modelData);
                            }
                        }
                    }
                }
            }
        }
    }
}

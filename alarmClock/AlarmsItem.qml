pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.Common
import qs.Services
import qs.Widgets

DankButton {
    id: root

    required property AlarmService.Alarm modelData
    required property int index
    property bool isEnabled: modelData.enabled

    color: isEnabled ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1) : Theme.surfaceContainerHigh
    border.color: isEnabled ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.3) : "transparent"
    border.width: isEnabled ? 1 : 0

    radius: Theme.cornerRadius

    signal showDetails(index: int)

    onClicked: {
        showDetails(index);
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacingM
        anchors.rightMargin: Theme.spacingM
        spacing: Theme.spacingL

        StyledText {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: modelData.text()
            font.pixelSize: Theme.fontSizeXLarge
            color: isEnabled ? Theme.primary : Theme.surfaceText
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            visible: modelData.snoozedTime != null
            text: "snoozed"
            font.pixelSize: Theme.fontSizeXLarge
            font.italic: true
            color: isEnabled ? Theme.primary : Theme.surfaceText
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: modelData.name
            font.pixelSize: Theme.fontSizeXLarge
            color: isEnabled ? Theme.primary : Theme.surfaceText
            Layout.fillWidth: true
            maximumLineCount: 1
        }

        DankButton {
            visible: modelData.alarming
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            horizontalPadding: Theme.spacingL
            iconName: "stop_circle"
            text: "Stop sound"
            backgroundColor: Theme.error
            onClicked: {
                modelData.alarming = false;
                AlarmService.stopAlarm();
            }
        }

        DankToggle {
            id: toggle
            checked: modelData.enabled
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            onClicked: {
                modelData.setEnabled(!checked);
            }
        }

        DankButton {
            width: 30
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            horizontalPadding: Theme.spacingS
            iconName: "delete_forever"
            iconSize: Theme.iconSizeLarge
            textColor: Theme.error
            backgroundColor: "transparent"
            onClicked: {
                modelData.remove();
            }
        }
    }
}

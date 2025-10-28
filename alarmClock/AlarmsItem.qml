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
            Layout.fillWidth: true
        }

        DankButton {
            visible: modelData.alarming
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            horizontalPadding: Theme.spacingL
            text: "Stop sound"
            backgroundColor: Theme.error
            onClicked: {
                modelData.alarming = false;
                AlarmService.stopAlarm();
                console.info("aaa", modelData.enabled);
            }
        }

        DankToggle {
            id: toggle
            width: 30
            checked: modelData.enabled
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            onClicked: {
                modelData.enabled = checked;
            }
        }

        DankButton {
            width: 20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            horizontalPadding: Theme.spacingS
            iconName: "delete_forever"
            iconSize: Theme.iconSizeLarge
            textColor: Theme.error
            backgroundColor: "transparent"
            onClicked: {
                AlarmService.alarmList.splice(root.index, 1);
            }
        }
    }
}

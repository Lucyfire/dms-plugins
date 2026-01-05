import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    property var popoutService: null

    popoutWidth: 720
    popoutHeight: 450

    onPluginDataChanged: {
        AlarmService.alarmSound.source = Paths.toFileUrl(Paths.expandTilde(root.pluginData.soundFileLocation || Paths.strip(Qt.resolvedUrl("./alarm.wav"))));
        AlarmService.snoozedMinutes = Number(root.pluginData.snoozeMinutes) || 5;
        AlarmService.sendNotifications = root.pluginData.notifications == undefined ? true : root.pluginData.notifications;
        AlarmService.notificationsUrgency = root.pluginData.notificationUrgency || "normal";
    }

    popoutContent: Component {
        PopoutComponent {
            AlarmClockPopoutContent {
                width: popoutWidth
                height: popoutHeight - Theme.spacingS * 2
            }
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS

            DankIcon {
                name: AlarmService.widgetIcon
                color: Theme.primary
                size: root.iconSize
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                text: AlarmService.widgetInfoH
                visible: text != ""
                font.pixelSize: Theme.fontSizeXLarge
                color: Theme.primary
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            DankIcon {
                name: AlarmService.widgetIcon
                color: Theme.primary
                size: root.iconSize
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: AlarmService.widgetInfoV
                visible: text != ""
                font.pixelSize: Theme.fontSizeXLarge
                color: Theme.primary
            }
        }
    }
}

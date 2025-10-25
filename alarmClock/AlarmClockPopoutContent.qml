pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Modals.FileBrowser
import qs.Services
import qs.Widgets

Item {
    id: root

    required property var settingsData

    DankTabBar {
        id: alarmTabBar
        width: parent.width
        height: 45
        anchors.horizontalCenter: parent.horizontalCenter
        model: [
            {
                "text": "Alarms",
                "icon": "alarm"
            },
            {
                "text": "Stopwatch",
                "icon": "timer"
            },
            {
                "text": "Timer",
                "icon": "hourglass_top"
            }
        ]

        onTabClicked: index => {
            alarmTabBar.currentIndex = index;
        }

        AlarmsTab {
            visible: alarmTabBar.currentIndex == 0

            settingsData: root.settingsData
            width: parent.width
            height: parent.height - alarmTabBar.height - Theme.spaceS

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: alarmTabBar.bottom
            anchors.topMargin: Theme.spacingL
        }

        StopwatchTab {
            visible: alarmTabBar.currentIndex == 1

            settingsData: root.settingsData
            width: parent.width
            height: parent.height - alarmTabBar.height - Theme.spaceS

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: alarmTabBar.bottom
            anchors.topMargin: Theme.spacingL
        }
    }
}

pragma ComponentBehavior: Bound

import QtQuick
import qs.Common
import qs.Services
import qs.Widgets

Column {
    id: root

    required property var settingsData

    spacing: 0

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
    }

    AlarmsTab {
        visible: alarmTabBar.currentIndex == 0

        settingsData: root.settingsData
        width: parent.width
        height: parent.height - alarmTabBar.height - Theme.spacingS

        anchors.horizontalCenter: parent.horizontalCenter
    }

    StopwatchTab {
        visible: alarmTabBar.currentIndex == 1

        settingsData: root.settingsData
        width: parent.width
        height: parent.height - alarmTabBar.height - Theme.spacingS

        anchors.horizontalCenter: parent.horizontalCenter
    }
}

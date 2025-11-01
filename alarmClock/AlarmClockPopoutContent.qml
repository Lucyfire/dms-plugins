pragma ComponentBehavior: Bound

import QtQuick
import qs.Common
import qs.Services
import qs.Widgets

Column {
    id: root

    spacing: Theme.spacingL

    DankTabBar {
        id: alarmTabBar
        width: parent.width - Theme.spacingS * 2
        currentIndex: AlarmService.alarmTab
        model: [
            {
                "text": "Alarms",
                "icon": "alarm"
            },
            {
                "text": "Stopwatch",
                "icon": "timer"
            }
            // ,{
            //     "text": "Timer",
            //     "icon": "hourglass_top"
            // }
        ]

        onTabClicked: index => {
            AlarmService.alarmTab = index;
        }
    }

    AlarmsTab {
        visible: alarmTabBar.currentIndex == 0

        width: parent.width
        height: parent.height - alarmTabBar.height - Theme.spacingS

        anchors.horizontalCenter: parent.horizontalCenter
    }

    StopwatchTab {
        visible: alarmTabBar.currentIndex == 1

        width: parent.width
        height: parent.height - alarmTabBar.height - Theme.spacingS

        anchors.horizontalCenter: parent.horizontalCenter
    }

    // TimerTab {
    //     visible: alarmTabBar.currentIndex == 2
    //
    //     width: parent.width
    //     height: parent.height - alarmTabBar.height - Theme.spacingS
    //
    //     anchors.horizontalCenter: parent.horizontalCenter
    // }
}

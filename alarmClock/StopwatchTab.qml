pragma ComponentBehavior: Bound

import QtQuick
import qs.Common
import qs.Widgets

Item {
    id: root

    Column {
        anchors.centerIn: parent
        spacing: 20

        StyledText {
            text: AlarmService.stopwatchTime()
            color: Theme.primary
            font.pixelSize: 60
        }

        Row {
            spacing: 40
            anchors.horizontalCenter: parent.horizontalCenter

            DankButton {
                width: 100
                text: {
                    switch (AlarmService.stopwatchState) {
                    case AlarmService.StopwatchState.None:
                        return "Start";
                    case AlarmService.StopwatchState.Running:
                        return "Pause";
                    case AlarmService.StopwatchState.Paused:
                        return "Resume";
                    }
                }
                onClicked: {
                    switch (AlarmService.stopwatchState) {
                    case AlarmService.StopwatchState.None:
                        AlarmService.startStopwatch()
                        break;
                    case AlarmService.StopwatchState.Running:
                        AlarmService.pauseStopwatch()
                        break;
                    case AlarmService.StopwatchState.Paused:
                        AlarmService.unpauseStopwatch()
                        break;
                    }
                }
            }

            DankButton {
                text: "Stop"
                width: 100
                visible: AlarmService.stopwatchState != AlarmService.StopwatchState.None
                color: Theme.error
                onClicked: {
                    AlarmService.stopStopwatch()
                }
            }
        }
    }
}

pragma ComponentBehavior: Bound

import QtQuick
import qs.Common
import qs.Widgets

Item {
    id: root

    required property var settingsData

    property real elapsedTime: 0

    /**
     * enum does not work properly
    enum State {
        None = 0,
        Running = 1,
        Paused = 2
    }
    */
    property int state: 0
    property var startTime: 0

    Timer {
        id: timer
        interval: 10
        repeat: true
        running: running
        onTriggered: elapsedTime = new Date().getTime() - startTime
    }

    function formatTime(ms) {
        const totalSeconds = ms / 1000;
        const hours = Math.floor(totalSeconds / 3600);
        const minutes = Math.floor((totalSeconds % 3600) / 60);
        const seconds = Math.floor(totalSeconds % 60);
        const milliseconds = Math.floor(ms % 1000);

        return String(hours).padStart(2, "0") + ":" + String(minutes).padStart(2, '0') + ":" + String(seconds).padStart(2, '0') + "." + String(milliseconds).padStart(1, "0").substr(0, 1);
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        StyledText {
            text: formatTime(elapsedTime)
            color: Theme.primary
            font.pixelSize: 60
        }

        Row {
            spacing: 40
            anchors.horizontalCenter: parent.horizontalCenter

            DankButton {
                width: 100
                text: {
                    switch (root.state) {
                    case 0:
                        return "Start";
                    case 1:
                        return "Pause";
                    case 2:
                        return "Resume";
                    }
                }
                onClicked: {
                    switch (root.state) {
                    case 0:
                        // state = StopwatchTab.State.Running;
                        root.state = 1;
                        startTime = new Date().getTime();
                        timer.start();
                        break;
                    case 1:
                        // state = StopwatchTab.State.Paused;
                        root.state = 2;
                        timer.stop();
                        break;
                    case 2:
                        // state = StopwatchTab.State.Running;
                        root.state = 1;
                        startTime = new Date().getTime() - root.elapsedTime;
                        timer.start();
                        break;
                    }
                }
            }

            DankButton {
                text: "Stop"
                width: 100
                visible: root.state != 0
                color: Theme.error
                onClicked: {
                    // state = StopwatchTab.State.None;
                    root.state = 0;
                    root.elapsedTime = 0;
                    timer.stop();
                }
            }
        }
    }
}

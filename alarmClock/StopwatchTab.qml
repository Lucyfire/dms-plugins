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

    property real elapsedTime: 0
    property int state: StopwatchTab.State.None
    property var startTime: 0

    enum State {
        None,
        Running,
        Paused
    }

    // anchors.fill: parent

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

        Text {
            text: formatTime(elapsedTime)
            color: "white"
            font.pixelSize: 60
            font.family: "monospace"
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            spacing: 40
            anchors.horizontalCenter: parent.horizontalCenter

            DankButton {
                width: 100
                text: {
                    if (state == StopwatchTab.State.None) {
                        return "Start";
                    }
                    if (state == StopwatchTab.State.Running) {
                        return "Pause";
                    }
                    return "Resume";
                }
                onClicked: {
                    if (state == StopwatchTab.State.None) {
                        state = StopwatchTab.State.Running;
                        startTime = new Date().getTime();
                        timer.start();
                    } else if (state == StopwatchTab.State.Running) {
                        state = StopwatchTab.State.Paused;
                        timer.stop();
                    } else if (state == StopwatchTab.State.Paused) {
                        state = StopwatchTab.State.Running;
                        startTime = new Date().getTime() - elapsedTime;
                        timer.start();
                    }
                }
            }

            DankButton {
                text: "Lap"
                width: 100
                enabled: state == StopwatchTab.State.None
                onClicked: console.log("Lap:", formatTime(elapsedTime))
            }
        }
    }
}

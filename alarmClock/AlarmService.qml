pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Singleton {
    id: root

    property int alarmTab: 0
    property string widgetInfo: ""

    // Alarm Tab
    readonly property list<Alarm> list: []

    // Stopwatch Tab
    enum StopwatchState {
        None,
        Running,
        Paused
    }
    enum StopwatchAction {
        Start,
        Stop,
        Pause
    }
    property alias stopwatchTimer: stopwatchTimer
    property real elapsedTime: 0
    property real startTime: 0
    property int stopwatchState: AlarmService.StopwatchState.None

    onStopwatchStateChanged: {
        updateWidgetInfo()
    }

    Component.onCompleted: {
        for (let i = 0; i < 3; i++) {
            const alarm = alarmComp.createObject(root);
            alarm.setHour(i);
            root.list.push(alarm);
        }
        console.info("init alarm service");
    }

    function updateWidgetInfo() {
        if(root.stopwatchState == AlarmService.StopwatchState.Running) {
            root.widgetInfo = stopwatchTime(true)
            return
        }
        root.widgetInfo = ""
    }
    

    // Alarm Tab
    function addAlarm() {
        console.log("TODO: Should add alarm");
    }

    component Alarm: QtObject {
        id: alarm

        property date time: new Date()
        property int hour: 0
        property int minutes: 0

        property string name: ""
        property bool enabled: false

        function setHour(h: int) {
            if (h < 0) {
                h = 23;
            }
            if (h > 23) {
                h = 0;
            }
            hour = h;
        }
        function setMinutes(m: int) {
            if (m < 0) {
                m = 59;
            }
            if (m > 59) {
                m = 0;
            }
            minutes = m;
        }

        function text(): string {
            return String(alarm.hour).padStart(2, "0") + ":" + String(alarm.minutes).padStart(2, "0")
        }

        readonly property Timer timer: Timer {
            running: alarm.enabled
            interval: 1000
            onTriggered: {
                if (alarm.time.getTime() - new Date().getTime() < 0) {
                    alarm.enabled = false;
                    console.info("Alarm has passed");
                }
            }
        }
    }

    Component {
        id: alarmComp
        Alarm {}
    }

    // Stopwatch Tab
    function startStopwatch() {
        root.stopwatchState = AlarmService.StopwatchState.Running
        root.startTime =  new Date().getTime();
        root.stopwatchTimer.start()
    }

    function pauseStopwatch() {
        root.stopwatchState = AlarmService.StopwatchState.Paused
        root.stopwatchTimer.stop()
    }

    function unpauseStopwatch() {
        root.stopwatchState = AlarmService.StopwatchState.Running
        root.startTime =  new Date().getTime() - root.elapsedTime;
        root.stopwatchTimer.start()
    }

    function stopStopwatch() {
        root.stopwatchState = AlarmService.StopwatchState.None
        root.startTime =  0;
        root.elapsedTime =  0;
        root.stopwatchTimer.stop()
    }

    function stopwatchTime(small: bool): string {
        const totalSeconds = root.elapsedTime / 1000;
        const hours = Math.floor(totalSeconds / 3600);
        const minutes = Math.floor((totalSeconds % 3600) / 60);
        const seconds = Math.floor(totalSeconds % 60);
        const milliseconds = Math.floor(root.elapsedTime % 1000);

        if (small == undefined || small == false) {
            return String(hours).padStart(2, "0") + ":" + String(minutes).padStart(2, '0') + ":" + String(seconds).padStart(2, '0') + "." + String(milliseconds).padStart(1, "0").substr(0, 1);
        }
        let str = String(minutes).padStart(2, '0') + ":" + String(seconds).padStart(2, '0');
        if (hours > 0) {
            return String(hours).padStart(2, "0") + ":" + str
        }
        return str
    }

    Timer {
        id: stopwatchTimer
        interval: 10
        repeat: true
        running: running
        onTriggered: {
            root.elapsedTime = new Date().getTime() - root.startTime
            updateWidgetInfo()
        }
    }
}

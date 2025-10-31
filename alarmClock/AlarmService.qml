pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtMultimedia
import qs.Common

Singleton {
    id: root

    property int alarmTab: 0
    readonly property string metadataPath: Paths.cache + "/alarmClock.json"
    property string widgetIcon: "alarm"
    property string widgetInfo: ""
    property alias alarmSound: alarmSound

    signal alarming(Alarm alarm)

    // Alarm Tab
    readonly property list<Alarm> alarmList: []

    // Stopwatch Tab
    enum StopwatchState {
        None,
        Running,
        Paused
    }
    property alias stopwatchTimer: stopwatchTimer
    property real elapsedTime: 0
    property real startTime: 0
    property int stopwatchState: AlarmService.StopwatchState.None

    onStopwatchStateChanged: {
        updateWidget();
    }

    Component.onCompleted: {
        try {
            const metadata = JSON.parse(alarmsMetadata.text());
            for (const alarmData of metadata?.alarms) {
                const alarm = alarmComp.createObject(root);
                alarm.fromMetadata(alarmData);
                root.alarmList.push(alarm);
            }
        } catch (e) {}
        console.info("alarmClock:", "Alarm Service initiated");
    }

    function updateWidget() {
        if (root.stopwatchState == AlarmService.StopwatchState.Running) {
            root.widgetInfo = stopwatchTime(true);
            root.widgetIcon = "timer_play";
            return;
        }
        root.widgetInfo = "";
        root.widgetIcon = "alarm";
    }

    // Alarm Tab
    function addAlarm(): int {
        const alarm = alarmComp.createObject(root);
        root.alarmList.push(alarm);
        root.updateMetadata();
        return root.alarmList.length - 1;
    }

    function stopAlarm() {
        alarmSound.stop();
    }

    component Alarm: QtObject {
        id: alarm

        property int day: 0
        property int hour: 0
        property int minutes: 0

        property string name: ""
        property bool enabled: false
        property bool alarming: false

        property var repeats: {
            // Sunday
            0: false,
            // Monday
            1: false,
            2: false,
            3: false,
            4: false,
            5: false,
            6: false // Saturday
        }

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
        function setDay(d: int) {
            if (d < 0) {
                d = 6;
            }
            if (d > 6) {
                d = 0;
            }
            day = d;
        }
        function text(): string {
            return String(alarm.hour).padStart(2, "0") + ":" + String(alarm.minutes).padStart(2, "0");
        }

        function setEnabled(enabled: bool) {
            alarm.enabled = enabled;
            root.updateMetadata();
            if (!enabled) {
                return;
            }
            alarm.enabled = true;
            const currentDate = new Date();
            const minAlarmDate = new Date();
            minAlarmDate.setHours(alarm.hour);
            minAlarmDate.setMinutes(alarm.minutes);
            minAlarmDate.setSeconds(0);
            if (currentDate.getTime() >= minAlarmDate.getTime()) {
                alarm.setDay(currentDate.getDay() + 1);
                return;
            }
            alarm.setDay(currentDate.getDay());
        }

        function shouldAlarm(): bool {
            const currentDate = new Date();

            const isRepeating = alarm.repeats[0] || alarm.repeats[1] || alarm.repeats[2] || alarm.repeats[3] || alarm.repeats[4] || alarm.repeats[5] || alarm.repeats[6];
            if (isRepeating && !alarm.repeats[currentDate.getDay()]) {
                return false;
            }

            if (currentDate.getDay() != alarm.day) {
                return false;
            }

            if (currentDate.getHours() >= alarm.hour && currentDate.getMinutes() >= alarm.minutes) {
                return true;
            }
            return false;
        }

        function compact(): var {
            return {
                name,
                enabled,
                hour,
                minutes,
                repeats
            };
        }

        function fromMetadata(data: var) {
            alarm.name = data?.name || "";
            alarm.hour = data?.hour || 0;
            alarm.minutes = data?.minutes || 0;
            alarm.enabled = data?.enabled || false;
            if (data?.repeats) {
                alarm.repeats = data.repeats;
            }
        }

        readonly property Timer timer: Timer {
            running: alarm.enabled
            interval: 1000
            repeat: true
            onTriggered: {
                if (alarm.shouldAlarm()) {
                    const isRepeating = alarm.repeats[0] || alarm.repeats[1] || alarm.repeats[2] || alarm.repeats[3] || alarm.repeats[4] || alarm.repeats[5] || alarm.repeats[6];
                    if (!isRepeating) {
                        alarm.enabled = false;
                    } else {
                        alarm.setDay(alarm.day+1)
                    }
                    alarm.alarming = true;
                    alarmSound.play();
                    root.alarming(alarm);
                }
            }
        }
    }

    SoundEffect {
        id: alarmSound
        loops: SoundEffect.Infinite
    }

    Component {
        id: alarmComp
        Alarm {}
    }

    // Stopwatch Tab
    function startStopwatch() {
        root.stopwatchState = AlarmService.StopwatchState.Running;
        root.startTime = new Date().getTime();
        root.stopwatchTimer.start();
    }

    function pauseStopwatch() {
        root.stopwatchState = AlarmService.StopwatchState.Paused;
        root.stopwatchTimer.stop();
    }

    function unpauseStopwatch() {
        root.stopwatchState = AlarmService.StopwatchState.Running;
        root.startTime = new Date().getTime() - root.elapsedTime;
        root.stopwatchTimer.start();
    }

    function stopStopwatch() {
        root.stopwatchState = AlarmService.StopwatchState.None;
        root.startTime = 0;
        root.elapsedTime = 0;
        root.stopwatchTimer.stop();
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
            return String(hours).padStart(2, "0") + ":" + str;
        }
        return str;
    }

    Timer {
        id: stopwatchTimer
        interval: 10
        repeat: true
        running: running
        onTriggered: {
            root.elapsedTime = new Date().getTime() - root.startTime;
            updateWidget();
        }
    }

    FileView {
        id: alarmsMetadata
        path: root.metadataPath
        blockLoading: true
        blockWrites: true
        atomicWrites: true
    }

    function updateMetadata() {
        const metadata = {
            alarms: []
        };
        for (const alarm of root.alarmList) {
            metadata.alarms.push(alarm.compact());
        }
        alarmsMetadata.setText(JSON.stringify(metadata, null, 2));
    }
}

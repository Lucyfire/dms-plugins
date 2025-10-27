pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property list<Alarm> list: []

    Component.onCompleted: {
        for (let i = 0; i < 3; i++) {
            const alarm = alarmComp.createObject(root);
            alarm.setHour(i);
            root.list.push(alarm);
        }
        console.info("init alarm service");
    }

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
                return;
            }
            if (h > 23) {
                h = 0;
                return;
            }
            hour = h;
        }
        function setMinutes(m: int) {
            if (m < 0) {
                m = 59;
                return;
            }
            if (m > 59) {
                m = 0;
                return;
            }
            minutes = m;
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
}

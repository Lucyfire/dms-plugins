pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root

    required property var settingsData

    property bool showAlarmDetails: false
    property int selectedIndex: 0

    height: parent.height
    width: parent.width

    Connections {
        target: AlarmService

        function onAlarming() {
            alarmList.forceLayout();
        }
    }

    Column {
        width: parent.width - Theme.spacingS * 2
        height: parent.height
        spacing: Theme.spacingS

        AlarmItemEdit {
            width: parent.width
            height: parent.height
            visible: showAlarmDetails

            onVisibleChanged: {
                if (visible) {
                    alarmItem = AlarmService.alarmList[root.selectedIndex];
                }
            }

            onBack: root.showAlarmDetails = false
            onRemove: {
                root.showAlarmDetails = false;
                AlarmService.alarmList.splice(root.selectedIndex, 1);
            }
        }

        DankButton {
            id: createBtn
            visible: !showAlarmDetails
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Create new alarm"

            onClicked: {
                root.selectedIndex = AlarmService.addAlarm();
                root.showAlarmDetails = true;
            }
        }

        DankListView {
            id: alarmList

            clip: true
            visible: !showAlarmDetails
            spacing: Theme.spacingM

            width: parent.width * 0.9
            height: parent.height - createBtn.height - Theme.spacingS * 2

            anchors.horizontalCenter: parent.horizontalCenter

            model: ScriptModel {
                values: [...AlarmService.alarmList]
            }
            interactive: true
            flickDeceleration: 1500
            maximumFlickVelocity: 2000
            boundsBehavior: Flickable.DragAndOvershootBounds
            boundsMovement: Flickable.FollowBoundsBehavior
            pressDelay: 0
            flickableDirection: Flickable.VerticalFlick

            delegate: AlarmsItem {
                width: ListView.view.width
                height: 50

                onShowDetails: index => {
                    root.selectedIndex = index;
                    root.showAlarmDetails = true;
                }
            }
        }
    }
}

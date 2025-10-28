pragma ComponentBehavior: Bound

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

    Column {
        width: parent.width - Theme.spacingS * 2
        height: parent.height
        spacing: 0

        AlarmItemEdit {
            width: parent.width
            height: parent.height
            visible: showAlarmDetails

            onVisibleChanged: {
                if (visible) {
                    alarmItem = AlarmService.list[root.selectedIndex]
                }
            }

            onBack: root.showAlarmDetails = false
        }

        DankListView {
            id: alarmList

            visible: !showAlarmDetails
            spacing: Theme.spacingM

            width: parent.width * 0.9
            height: parent.height

            anchors.horizontalCenter: parent.horizontalCenter
            model: AlarmService.list
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
                    root.selectedIndex = index
                    root.showAlarmDetails = true
                }
            }
        }

    }

}

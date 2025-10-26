pragma ComponentBehavior: Bound

import QtQuick
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root

    height: {
        console.debug(parent.height);
        return parent.height;
    }
    required property var settingsData

    ListModel {
        id: alarmsModel
    }

    Component.onCompleted: {
        alarmsModel.append({
            "time": "11:00"
        });
        alarmsModel.append({
            "time": "12:00"
        });
        alarmsModel.append({
            "time": "13:00"
        });
    }

    DankListView {
        id: alarmList

        spacing: Theme.spacingM

        width: parent.width * 0.9
        height: parent.height

        anchors.horizontalCenter: parent.horizontalCenter
        model: alarmsModel
        interactive: true
        flickDeceleration: 1500
        maximumFlickVelocity: 2000
        boundsBehavior: Flickable.DragAndOvershootBounds
        boundsMovement: Flickable.FollowBoundsBehavior
        pressDelay: 0
        flickableDirection: Flickable.VerticalFlick

        delegate: StyledRect {
            required property var modelData
            required property int index

            width: alarmList.width
            height: 50

            border.width: 1
            border.color: Theme.primary
            radius: Theme.cornerRadius

            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                spacing: Theme.spacingM
                anchors.fill: parent
                anchors.verticalCenter: parent.verticalCenter

                StyledText {
                    text: `${index}: ${alarmList.count}`
                    // width: parent.width * 0.7

                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Theme.fontSizeLarge
                    font.weight: Font.Bold
                    color: Theme.surfaceText
                }

                DankToggle {
                    id: toggle
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        console.debug("Alarm Clock", toggle.checked);
                    }
                }
            }
        }
    }
}

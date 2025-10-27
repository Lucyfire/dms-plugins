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

    ListModel {
        id: alarmsModel
    }

    Column {

        width: parent.width
        height: parent.height
        spacing: 0

        AlarmItem {
            width: parent.width * 0.9
            height: parent.height
            visible: showAlarmDetails

            onVisibleChanged: {
                if (visible) {
                    alarmItem = AlarmService.list[root.selectedIndex]
                }
            }

            onBack: root.showAlarmDetails = false

            onSave: data => {
                console.info("TODO: update alarm")
            }
        }

        DankListView {
            id: alarmList

            visible: !showAlarmDetails
            spacing: Theme.spacingM

            width: parent.width * 0.9
            height: parent.height

            anchors.horizontalCenter: parent.horizontalCenter
            // model: alarmsModel
            model: AlarmService.list
            interactive: true
            flickDeceleration: 1500
            maximumFlickVelocity: 2000
            boundsBehavior: Flickable.DragAndOvershootBounds
            boundsMovement: Flickable.FollowBoundsBehavior
            pressDelay: 0
            flickableDirection: Flickable.VerticalFlick

            delegate: DankButton {
                required property AlarmService.Alarm modelData
                required property int index
                
                property bool isEnabled: modelData.enabled

                width: ListView.view.width
                height: 50

                color: isEnabled ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1) : Theme.surfaceContainerHigh
                border.color: isEnabled  ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.3) : "transparent"
                border.width: isEnabled ? 1 : 0

                radius: Theme.cornerRadius

                onClicked: {
                    root.selectedIndex = index
                    root.showAlarmDetails = true
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.spacingM
                    anchors.rightMargin: Theme.spacingM
                    spacing: Theme.spacingM

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        text: String(modelData.hour).padStart("0", 2) + ":" + String(modelData.minutes).padStart("0", 2)
                        font.pixelSize: Theme.fontSizeXLarge
                        color: isEnabled ? Theme.primary : Theme.surfaceText
                        Layout.fillWidth: true
                    }

                    DankToggle {
                        width: 30
                        id: toggle
                        checked: isEnabled
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        onClicked: {
                            alarmsModel.setProperty(index, "enabled", checked)
                        }
                    }

                    DankButton {
                        width: 20
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        horizontalPadding: Theme.spacingS
                        iconName: "delete_forever" 
                        iconSize: Theme.iconSizeLarge
                        textColor: Theme.error
                        backgroundColor: "transparent"
                        onClicked: alarmsModel.remove(index)
                    }

                }
            }
        }

    }

}

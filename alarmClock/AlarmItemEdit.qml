pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.Common
import qs.Services
import qs.Widgets

DankFlickable {
    id: root

    anchors.horizontalCenter: parent.horizontalCenter

    property AlarmService.Alarm alarmItem

    signal back
    signal remove

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        RowLayout {
            Layout.fillWidth: true

            DankButton {
                width: 30

                iconName: "arrow_back"
                horizontalPadding: Theme.spacingS
                iconSize: Theme.iconSizeLarge
                textColor: Theme.error
                buttonHeight: 32
                backgroundColor: "transparent"

                onClicked: root.back()
            }

            Item {
                Layout.fillWidth: true
            }

            DankButton {
                text: "Save"
                onClicked: {
                    alarmItem.setHour(hourText.text);
                    alarmItem.setMinutes(minuteText.text);
                    alarmItem.toggle();
                    root.back();
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            spacing: Theme.spacingL

            ColumnLayout {
                DankButton {
                    width: 95
                    text: "+"
                    onClicked: alarmItem.setHour(alarmItem.hour + 1)
                }
                DankTextField {
                    id: hourText
                    text: String(alarmItem.hour).padStart(2, "0")
                    width: 95
                    height: 60
                    font.pixelSize: Theme.fontSizeXLarge
                    Layout.alignment: Qt.AlignHCenter
                    validator: IntValidator {
                        bottom: 0
                        top: 23
                    }
                    onEditingFinished: {
                        alarmItem.setHour(text);
                    }

                    onAccepted: {
                        alarmItem.setHour(hourText.text);
                        alarmItem.setMinutes(minuteText.text);
                        alarmItem.toggle();
                        root.back();
                    }
                }
                DankButton {
                    width: 95
                    text: "−"
                    onClicked: alarmItem.setHour(alarmItem.hour - 1)
                }
            }

            StyledText {
                text: ":"
                font.pixelSize: 60
                verticalAlignment: Text.AlignVCenter
            }

            ColumnLayout {
                DankButton {
                    width: 95
                    text: "+"
                    onClicked: alarmItem.setMinutes(alarmItem.minutes + 1)
                }
                DankTextField {
                    id: minuteText
                    text: String(alarmItem.minutes).padStart(2, "0")
                    width: 95
                    height: 60
                    font.pixelSize: Theme.fontSizeXLarge
                    Layout.alignment: Qt.AlignHCenter
                    validator: IntValidator {
                        bottom: 0
                        top: 59
                    }
                    onEditingFinished: {
                        alarmItem.setMinutes(text);
                    }
                    onAccepted: {
                        alarmItem.setHour(hourText.text);
                        alarmItem.setMinutes(minuteText.text);
                        alarmItem.toggle();
                        root.back();
                    }
                }
                DankButton {
                    width: 95
                    text: "−"
                    onClicked: alarmItem.setMinutes(alarmItem.minutes - 1)
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingM
            StyledText {
                text: "Repeat"
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.surfaceText
            }

            RowLayout {
                spacing: Theme.spacingS
                Repeater {
                    model: [
                        {
                            text: "M",
                            id: 1
                        },
                        {
                            text: "T",
                            id: 2
                        },
                        {
                            text: "W",
                            id: 3
                        },
                        {
                            text: "T",
                            id: 4
                        },
                        {
                            text: "F",
                            id: 5
                        },
                        {
                            text: "S",
                            id: 6
                        },
                        {
                            text: "S",
                            id: 0
                        },
                    ]
                    delegate: DankButton {
                        required property var modelData
                        property bool checked: false
                        text: modelData.text
                        color: checked ? Theme.primary : Theme.primarySelected
                        onClicked: {
                            checked = !checked;
                            alarmItem.repeats[modelData.id] = checked;
                        }
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                    }
                }
            }
        }

        DankButton {
            text: "Remove Alarm"
            Layout.fillWidth: true
            color: Theme.error
            onClicked: root.remove()
        }
    }
}

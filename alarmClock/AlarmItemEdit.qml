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
                    root.back();
                }
            }
        }

        // Time selectors
        RowLayout {
            Layout.fillWidth: true
            // Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter
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
                }
                DankButton {
                    width: 95
                    text: "−"
                    onClicked: alarmItem.setMinutes(alarmItem.minutes - 1)
                }
            }
        }

        // Repeat section
        StyledRect {
            Layout.fillWidth: true
            radius: Theme.cornerRadius
            // padding: Theme.spacingM
            color: Theme.surfaceContainer

            ColumnLayout {
                spacing: Theme.spacingM
                StyledText {
                    text: "Repeat"
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.surfaceText
                }

                RowLayout {
                    spacing: Theme.spacingS
                    Repeater {
                        model: ["M", "T", "W", "T", "F", "S", "S"]
                        delegate: DankButton {
                            required property string modelData
                            property bool checked: false
                            text: modelData
                            color: checked ? Theme.primary : Theme.surfaceText
                            onClicked: checked = !checked
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32
                        }
                    }
                }
            }
        }

        // Name + durations
        // StyledRect {
        //     Layout.fillWidth: true
        //     radius: Theme.cornerRadius
        //     color: Theme.surfaceContainer
        //     // padding: Theme.spacingM
        //
        //     ColumnLayout {
        //         spacing: Theme.spacingS
        //
        //         RowLayout {
        //             Layout.fillWidth: true
        //             DankTextField {
        //                 text: "Name"
        //                 leftIconName: "edit"
        //                 Layout.fillWidth: true
        //             }
        //             // StyledText {}
        //             // DankIcon {
        //             //     name: "edit"
        //             // }
        //         }
        //
        //         RowLayout {
        //             Layout.fillWidth: true
        //             StyledText {
        //                 text: "Ring Duration"
        //                 Layout.fillWidth: true
        //             }
        //             // StyledComboBox {
        //             //     model: ["1 minute", "5 minutes", "10 minutes"]
        //             //     currentIndex: 1
        //             // }
        //         }
        //
        //         RowLayout {
        //             Layout.fillWidth: true
        //             StyledText {
        //                 text: "Snooze Duration"
        //                 Layout.fillWidth: true
        //             }
        //             // StyledComboBox {
        //             //     model: ["5 minutes", "10 minutes", "15 minutes"]
        //             //     currentIndex: 1
        //             // }
        //         }
        //     }
        // }

        // Remove button
        DankButton {
            text: "Remove Alarm"
            Layout.fillWidth: true
            color: Theme.error
            onClicked: console.info("Remove alarm clicked")
        }
    }

    // StyledRect {
    //     anchors.fill: parent
    //     color: Theme.surface
    //     radius: Theme.cornerRadius
    // }
}

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
    signal save(var data)

    StyledRect {
        anchors.fill: parent
        color: Theme.surface
        radius: Theme.cornerRadius
        // padding: Theme.spacingL

        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.spacingL

            // Header row
            RowLayout {
                Layout.fillWidth: true

                DankButton {
                    width: 30
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

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
                    onClicked: root.save(root.alarmItem)
                }
            }

            // Time selectors
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.spacingL

                ColumnLayout {
                    DankButton {
                        text: "+"
                        onClicked: {}
                    }
                    StyledText {
                        text: "11"
                        font.pixelSize: Theme.fontSizeMedium
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                    DankButton {
                        text: "−"
                        onClicked: console.info("Hour −")
                    }
                }

                StyledText {
                    text: ":"
                    font.pixelSize: Theme.fontSizeMedium
                    verticalAlignment: Text.AlignVCenter
                }

                ColumnLayout {
                    DankButton {
                        text: "+"
                        onClicked: console.info("Minute +")
                    }
                    StyledText {
                        text: "05"
                        font.pixelSize: Theme.fontSizeMedium
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                    DankButton {
                        text: "−"
                        onClicked: console.info("Minute −")
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
            StyledRect {
                Layout.fillWidth: true
                radius: Theme.cornerRadius
                color: Theme.surfaceContainer
                // padding: Theme.spacingM

                ColumnLayout {
                    spacing: Theme.spacingS

                    RowLayout {
                        Layout.fillWidth: true
                        StyledText {
                            text: "Name"
                            Layout.fillWidth: true
                        }
                        DankIcon {
                            name: "edit"
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        StyledText {
                            text: "Ring Duration"
                            Layout.fillWidth: true
                        }
                        // StyledComboBox {
                        //     model: ["1 minute", "5 minutes", "10 minutes"]
                        //     currentIndex: 1
                        // }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        StyledText {
                            text: "Snooze Duration"
                            Layout.fillWidth: true
                        }
                        // StyledComboBox {
                        //     model: ["5 minutes", "10 minutes", "15 minutes"]
                        //     currentIndex: 1
                        // }
                    }
                }
            }

            // Remove button
            DankButton {
                text: "Remove Alarm"
                Layout.fillWidth: true
                color: Theme.error
                // danger: true
                onClicked: console.info("Remove alarm clicked")
            }
        }
    }
}

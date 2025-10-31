pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.Common
import qs.Services
import qs.Widgets

DankFlickable {
    id: root

    anchors.horizontalCenter: parent.horizontalCenter

    property AlarmService.Alarm alarmItem: null

    property int h
    property int m
    property bool monday: false
    property bool tuesday: false
    property bool wednesday: false
    property bool thursday: false
    property bool friday: false
    property bool saturday: false
    property bool sunday: false

    signal back
    signal remove

    function getRepeat(id: int): bool {
        switch (id) {
            case 0: return root.sunday
            case 1: return root.monday
            case 2: return root.tuesday
            case 3: return root.wednesday
            case 4: return root.thursday
            case 5: return root.friday
            case 6: return root.saturday
        }
    }

    function setRepeat(id: string, value: bool) {
        switch (id) {
            case "0": root.sunday = value; return;
            case "1": root.monday = value; return;
            case "2": root.tuesday = value; return;
            case "3": root.wednesday = value; return;
            case "4": root.thursday = value; return;
            case "5": root.friday = value; return;
            case "6": root.saturday = value; return;
        }
    }

    function setAlarm(item: AlarmService.Alarm) {
        root.alarmItem = item
        root.sunday = item.repeats[0]
        root.monday = item.repeats[1]
        root.tuesday  = item.repeats[2]
        root.wednesday= item.repeats[3]
        root.thursday= item.repeats[4]
        root.friday= item.repeats[5]
        root.saturday= item.repeats[6]

        repeatsToggler.itemAt(0).checked = item.repeats[1];
        repeatsToggler.itemAt(1).checked = item.repeats[2];
        repeatsToggler.itemAt(2).checked = item.repeats[3];
        repeatsToggler.itemAt(3).checked = item.repeats[4];
        repeatsToggler.itemAt(4).checked = item.repeats[5];
        repeatsToggler.itemAt(5).checked = item.repeats[6];
        repeatsToggler.itemAt(6).checked = item.repeats[0];

        root.h = alarmItem.hour || 0;
        root.m = alarmItem.minutes || 0;
    }

    function save() {
        alarmItem.name = nameText.text;
        alarmItem.repeats[0] = root.sunday;
        alarmItem.repeats[1] = root.monday;
        alarmItem.repeats[2] = root.tuesday;
        alarmItem.repeats[3] = root.wednesday;
        alarmItem.repeats[4] = root.thursday;
        alarmItem.repeats[5] = root.friday;
        alarmItem.repeats[6] = root.saturday;

        alarmItem.setHour(hourText.text);
        alarmItem.setMinutes(minuteText.text);
        alarmItem.setEnabled(true);
        root.back();
    }

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

                onClicked: {
                    alarmItem.hour = root.h;
                    alarmItem.minutes = root.m;
                    root.back();
                }
            }

            Item {
                Layout.fillWidth: true
            }

            DankButton {
                text: "Save"
                onClicked: root.save()
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
                    text: String(alarmItem?.hour).padStart(2, "0")
                    width: 95
                    height: 60
                    font.pixelSize: Theme.fontSizeXLarge
                    Layout.alignment: Qt.AlignHCenter
                    validator: IntValidator {
                        bottom: 0
                        top: 23
                    }
                    onAccepted: root.save()
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
                    text: String(alarmItem?.minutes).padStart(2, "0")
                    width: 95
                    height: 60
                    font.pixelSize: Theme.fontSizeXLarge
                    Layout.alignment: Qt.AlignHCenter
                    validator: IntValidator {
                        bottom: 0
                        top: 59
                    }
                    onAccepted: root.save()
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
                    id: repeatsToggler
                    model: [
                        {
                            text: "M",
                            id: "1"
                        },
                        {
                            text: "T",
                            id: "2"
                        },
                        {
                            text: "W",
                            id: "3"
                        },
                        {
                            text: "T",
                            id: "4"
                        },
                        {
                            text: "F",
                            id: "5"
                        },
                        {
                            text: "S",
                            id: "6"
                        },
                        {
                            text: "S",
                            id: "0"
                        },
                    ]
                    delegate: DankButton {
                        required property var modelData
                        property bool checked: root.getRepeat(modelData.id)
                        text: modelData.text
                        color: checked ? Theme.primary : Theme.primarySelected
                        onClicked: {
                            checked = !checked;
                            root.setRepeat(modelData.id, checked)
                        }
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                    }
                }
            }

            DankTextField {
                id: nameText
                text: alarmItem?.name || ""
                placeholderText: "Name"
                font.pixelSize: Theme.fontSizeMedium
                onEditingFinished: {
                    alarmItem.name = text;
                }

                onAccepted: root.save()
                Layout.fillWidth: true
            }

            DankButton {
                text: "Remove Alarm"
                Layout.fillWidth: true
                color: Theme.error
                onClicked: root.remove()
            }
        }
    }
}

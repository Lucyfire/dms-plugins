pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.Common
import qs.Widgets

Item {
    id: root

    property int hour: 0
    property int minute: 0
    property bool selectingHour: true
    property int clockSize: 250
    property bool dragging: false

    signal hourSelected(int hour)
    signal minuteSelected(int minute)
    signal timeSelected(int hour, int minute)

    width: clockSize
    height: clockSize + 60

    function selectValue(mouseX: real, mouseY: real) {
        const centerX = clockFace.width / 2;
        const centerY = clockFace.height / 2;
        const dx = mouseX - centerX;
        const dy = mouseY - centerY;

        let angle = Math.atan2(dx, -dy) * 180 / Math.PI;
        if (angle < 0)
            angle += 360;

        if (root.selectingHour) {
            const radius = Math.sqrt(dx * dx + dy * dy);
            const outerRadius = clockFace.width / 2 - 20;
            const innerRadius = outerRadius - 40;
            const isInner = radius < (innerRadius + outerRadius) / 2;

            let hourVal = Math.round(angle / 30) % 12;
            if (isInner) {
                hourVal = hourVal === 0 ? 0 : hourVal + 12;
            } else {
                hourVal = hourVal === 0 ? 12 : hourVal;
            }
            if (hourVal === 24)
                hourVal = 0;
            root.hour = hourVal;
        } else {
            let minuteVal = Math.round(angle / 6) % 60;
            root.minute = minuteVal;
        }
    }

    function confirmSelection() {
        if (root.selectingHour) {
            root.hourSelected(root.hour);
        } else {
            root.minuteSelected(root.minute);
            root.timeSelected(root.hour, root.minute);
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.spacingM

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.spacingS

            Rectangle {
                width: 70
                height: 50
                radius: Theme.radius
                color: root.selectingHour ? Theme.primarySelected : "transparent"

                StyledText {
                    anchors.centerIn: parent
                    text: String(root.hour).padStart(2, "0")
                    font.pixelSize: 32
                    font.bold: root.selectingHour
                    color: root.selectingHour ? Theme.primary : Theme.surfaceText
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.selectingHour = true
                }
            }

            StyledText {
                text: ":"
                font.pixelSize: 32
                color: Theme.surfaceText
            }

            Rectangle {
                width: 70
                height: 50
                radius: Theme.radius
                color: !root.selectingHour ? Theme.primarySelected : "transparent"

                StyledText {
                    anchors.centerIn: parent
                    text: String(root.minute).padStart(2, "0")
                    font.pixelSize: 32
                    font.bold: !root.selectingHour
                    color: !root.selectingHour ? Theme.primary : Theme.surfaceText
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.selectingHour = false
                }
            }
        }

        Rectangle {
            id: clockFace
            Layout.alignment: Qt.AlignHCenter
            width: root.clockSize
            height: root.clockSize
            radius: width / 2
            color: Theme.surface

            Rectangle {
                id: centerDot
                width: 8
                height: 8
                radius: 4
                color: Theme.primary
                anchors.centerIn: parent
                z: 2
            }

            Rectangle {
                id: clockHand
                property real targetAngle: {
                    if (root.selectingHour) {
                        const h = root.hour % 12;
                        return h * 30;
                    }
                    return root.minute * 6;
                }
                property real handLength: {
                    let isOuterRing = true
                    if (root.selectingHour) {
                        isOuterRing = root.hour >= 1 && root.hour <= 12;
                    }
                    return isOuterRing ? (clockFace.width / 2 - 35) : (clockFace.width / 2 - 70);
                }

                width: 2
                height: handLength
                color: Theme.primary
                transformOrigin: Item.Bottom
                x: clockFace.width / 2 - 1
                y: clockFace.height / 2 - handLength
                rotation: targetAngle

                Behavior on rotation {
                    enabled: !root.dragging
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on height {
                    enabled: !root.dragging
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }

                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: Theme.primary
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: -18

                    StyledText {
                        visible: !root.selectingHour && (root.minute % 5 !== 0)
                        anchors.centerIn: parent
                        rotation: -clockHand.rotation
                        text: String(root.minute).padStart(2, "0")
                        font.pixelSize: 14
                        color: Theme.primaryText
                    }
                }
            }

            Repeater {
                model: root.selectingHour ? 12 : 12

                delegate: Item {
                    required property int index
                    property int displayValue: root.selectingHour ? (index === 0 ? 12 : index) : index * 5
                    property real angle: index * 30 - 90
                    property real radius: clockFace.width / 2 - 35

                    x: clockFace.width / 2 + radius * Math.cos(angle * Math.PI / 180) - width / 2
                    y: clockFace.height / 2 + radius * Math.sin(angle * Math.PI / 180) - height / 2
                    width: 30
                    height: 30

                    StyledText {
                        anchors.centerIn: parent
                        text: String(displayValue).padStart(root.selectingHour ? 1 : 2, "0")
                        font.pixelSize: 16
                        color: {
                            if (root.selectingHour) {
                                const isOuterRingSelected = root.hour >= 1 && root.hour <= 12;
                                const targetHour = parent.index === 0 ? 12 : parent.index;
                                const isSelected = isOuterRingSelected && root.hour === targetHour;
                                return isSelected ? Theme.primaryText : Theme.surfaceText;
                            } else {
                                return parent.displayValue === root.minute ? Theme.primaryText : Theme.surfaceText;
                            }
                        }
                    }
                }
            }

            Repeater {
                model: root.selectingHour ? 12 : 0

                delegate: Item {
                    required property int index
                    property int displayValue: index === 0 ? 0 : index + 12
                    property real angle: index * 30 - 90
                    property real radius: clockFace.width / 2 - 70

                    x: clockFace.width / 2 + radius * Math.cos(angle * Math.PI / 180) - width / 2
                    y: clockFace.height / 2 + radius * Math.sin(angle * Math.PI / 180) - height / 2
                    width: 30
                    height: 30

                    StyledText {
                        anchors.centerIn: parent
                        text: String(parent.displayValue)
                        font.pixelSize: 14
                        color: root.hour === parent.displayValue ? Theme.primaryText : Theme.surfaceText
                        opacity: root.hour === parent.displayValue ? 1 : 0.7
                    }
                }
            }

            MouseArea {
                anchors.fill: parent

                onPressed: function (mouse) {
                    root.dragging = true;
                    root.selectValue(mouse.x, mouse.y);
                }

                onPositionChanged: function (mouse) {
                    if (pressed) {
                        root.selectValue(mouse.x, mouse.y);
                    }
                }

                onReleased: {
                    root.dragging = false;
                    root.confirmSelection();
                }
            }
        }
    }
}

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

    property bool editting: false

    height: parent.height
    width: parent.width

    Column {
        width: parent.width - Theme.spacingS * 2
        height: parent.height
        spacing: Theme.spacingS

        DankButton {
            id: createBtn
            visible: !root.editting
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Set timer"

            onClicked: {}
        }
    }
}

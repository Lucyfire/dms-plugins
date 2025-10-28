import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    property var popoutService: null
    property string selectedPopout: pluginData.selectedPopout || "controlCenter"

    popoutWidth: 720
    popoutHeight: 450

    popoutContent: Component {
        PopoutComponent {
            AlarmClockPopoutContent {
                settingsData: root.pluginData
                width: popoutWidth
                height: popoutHeight - Theme.spacingS * 2
            }
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS

            DankIcon {
                name: "alarm"
                color: Theme.primary
                size: Theme.iconSize
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                text: AlarmService.widgetInfo
                visible: text != ""
                font.pixelSize: Theme.fontSizeXLarge
                color: Theme.primary 
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            DankIcon {
                name: "alarm"
                color: Theme.primary
                size: Theme.iconSize
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: AlarmService.widgetInfo
                visible: text != ""
                font.pixelSize: Theme.fontSizeXLarge
                color: Theme.primary 
            }
        }
    }
}

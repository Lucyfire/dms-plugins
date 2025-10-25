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
            WallpaperDiscoveryPopoutContent {
                settingsData: root.pluginData
                implicitWidth: popoutWidth
                implicitHeight: popoutHeight - Theme.spacingS * 2
            }
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS

            DankIcon {
                name: "wallpaper_slideshow"
                color: Theme.primary
                font.pixelSize: Theme.iconSize - 6
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            DankIcon {
                name: "wallpaper_slideshow"
                color: Theme.primary
                font.pixelSize: Theme.iconSize - 6
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}

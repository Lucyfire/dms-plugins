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

    pillClickAction: () => {
        wallpaperSlideout.toggle();
    }

    DankSlideout {
        id: wallpaperSlideout
        modelData: root.parentScreen || Screen
        title: I18n.tr("Wallpaper Discovery")
        slideoutWidth: 720
        expandable: false
        expandedWidthValue: 1200

        content: Component {
            WallpaperDiscoveryContent {
                pluginService: root.pluginService
                settingsData: root.pluginData
                implicitHeight: wallpaperSlideout.container.height > 0 ? wallpaperSlideout.container.height : 440
            }
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS

            DankIcon {
                name: "wallpaper_slideshow"
                color: Theme.primary
                size: Theme.iconSize
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
                size: Theme.iconSize
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}

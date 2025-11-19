import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "displaySettings"

    StyledText {
        anchors.verticalCenter: parent.verticalCenter
        text: "You can open/close the menu by running 'dms ipc call displaySettings [toggle|open|close]'"
        font.pixelSize: Theme.fontSizeLarge
        color: Theme.primary
        width: parent.width
    }
}

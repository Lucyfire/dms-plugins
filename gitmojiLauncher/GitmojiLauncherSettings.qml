import QtQuick
import QtQuick.Controls
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "gitmojiLauncher"

    ToggleSetting {
        id: triggerToggle
        settingKey: "noTrigger"
        label: "Always active"
        description: value ? "Items will always show in the launcher (no trigger needed)." : "Set the trigger text to activate this plugin. Type the trigger in the launcher to filter to gitmojis."
        defaultValue: false
    }

    StringSetting {
        visible: !triggerToggle.value
        settingKey: "trigger"
        label: "Trigger"
        defaultValue: "gm"
    }
}

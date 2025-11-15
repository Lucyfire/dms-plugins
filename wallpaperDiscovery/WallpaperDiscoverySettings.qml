import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "wallpaperDiscovery"

    StyledText {
        width: parent.width
        text: "Wallpaper Discovery"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: "⚠️⚠️⚠️ API keys are stored in plain text in the plugin settings. ⚠️⚠️⚠️"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StringSetting {
        settingKey: "downloadLocation"
        label: "Download location"
        description: "Each provider will be downloaded in its own directory."
        defaultValue: "~/Pictures/Wallpapers"
    }

    StringSetting {
        settingKey: "api_unsplash"
        label: "unsplash api key"
        description: "Get an api key from: https://unsplash.com/developers"
        defaultValue: ""
    }

    StringSetting {
        settingKey: "api_pexels"
        label: "pexels api key"
        description: "Get an api key from: https://www.pexels.com/api/key"
        defaultValue: ""
    }

    StringSetting {
        settingKey: "api_wallhavencc"
        label: "wallhaven.cc api key"
        description: "Wallhaven can be used without an api key for just SFW wallpapers.\nYou can get an api key from: https://wallhaven.cc/settings/account"
        defaultValue: ""
    }
}

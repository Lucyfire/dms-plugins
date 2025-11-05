import QtQuick
import Quickshell.Io
import qs.Modules.Plugins

PluginComponent {
    id: root

    property var popoutService: null

    DisplaySettingsModal {
        id: modal
    }

    IpcHandler {
        function open(): string {
            modal.shouldBeVisible = true;
            modal.openCentered();
            DisplaySettingsService.setDisplays();
            return "DISPLAY_SETTINGS_OPEN_SUCCESS";
        }

        function close(): string {
            modal.shouldBeVisible = false;
            modal.close();
            return "DISPLAY_SETTINGS_CLOSE_SUCCESS";
        }

        function toggle(): string {
            if (modal.shouldBeVisible) {
                modal.shouldBeVisible = false;
                modal.close();
                return "DISPLAY_SETTINGS_CLOSE_SUCCESS";
            }

            modal.shouldBeVisible = true;
            modal.openCentered();
            return "DISPLAY_SETTINGS_OPEN_SUCCESS";
        }

        target: "displaySettings"
    }
}

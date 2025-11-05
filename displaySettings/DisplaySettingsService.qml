pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import qs.Common
import Quickshell.Hyprland

Singleton {
    id: root

    property var displays: []

    function setDisplays() {
        Proc.runCommand("displaySettings:setDisplays", ["hyprctl", "monitors", "all", "-j"], (output, exitCode) => {
            if (exitCode != 0) {
                return;
            }
            root.displays = JSON.parse(output);
        });
    }

    Component.onCompleted: {
        setDisplays();
    }

    function toggleDisable(display: var): void {
        Proc.runCommand("displaySettings:toggleDisplay", ["hyprctl", "keyword", `monitorv2[${display.name}]:disabled ${display.disabled ? "0" : "1"}`], (output, exitCode) => {
            if (exitCode != 0) {
                return;
            }
            setDisplays();
        });
    }
}

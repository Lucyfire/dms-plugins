import QtQuick
import QtMultimedia
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "alarmClock"

    StringSetting {
        id: audioLocation
        settingKey: "soundFileLocation"
        label: "Path to alarm audio file"
        description: "The audiofile must be in wav format"
        defaultValue: Paths.shortenHome(Paths.strip(Qt.resolvedUrl("./alarm.wav")))
    }

    DankButton {
        iconName: testSound.playing ? "pause" : "play_arrow"
        text: testSound.playing ? "Stop" : "Test Sound"
        backgroundColor: testSound.playing ? Theme.error : Theme.primary
        onClicked: {
            if (testSound.playing) {
                testSound.stop();
            } else {
                testSound.play();
            }
        }
    }

    SoundEffect {
        id: testSound
        source: Paths.toFileUrl(Paths.expandTilde(audioLocation.value))
        loops: 0
    }
}

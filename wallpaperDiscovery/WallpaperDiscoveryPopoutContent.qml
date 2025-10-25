pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Modals.FileBrowser
import qs.Services
import qs.Widgets

Item {
    id: root

    required property var settingsData

    property string wallpaperDir: ""
    property var wallpapers: {}

    property string wallpaperSource: "unsplash"
    property list<string> wallpaperSources: ["unsplash",]
    property string wallpaperQuery: ""

    function getCommand() {
        const source = root.wallpaperSource;
        const query = root.wallpaperQuery;
        switch (source) {
        case "unsplash":
            return ["curl", `https://api.unsplash.com/search/photos?per_page=50&query=${query}`, "-H", `authorization: Client-ID ${settingsData?.api_unsplash}`,];
        }
        return [""];
    }

    function download(id: string, url: string) {
        const source = root.wallpaperSource;
        const dir = settingsData?.downloadLocation == "undefined" ? "" : settingsData.downloadLocation;
        if (dir == "") {
            if (typeof ToastService !== "undefined") {
                ToastService.showError("download location is not defined");
            }
            return;
        }
        switch (source) {
        case "unsplash":
            Quickshell.execDetached(["sh", "-c", `mkdir -p ${dir}/unsplash`]);
            Quickshell.execDetached(["sh", "-c", `curl '${url}' --output ${dir}/unsplash/${id}.jpeg`]);
        }
        if (typeof ToastService !== "undefined") {
            ToastService.showInfo("Wallpaper saved");
        }
    }

    property int gridIndex: 0
    property bool enableAnimation: false

    Column {
        anchors.fill: parent
        spacing: Theme.spacingS

        Row {
            id: options
            property string value: "unsplash"

            spacing: Theme.spacingS
            width: parent.width - Theme.spacingS * 4
            height: 50

            DankDropdown {
                width: parent.width * 0.2
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                currentValue: root.wallpaperSource
                options: root.wallpaperSources
                onValueChanged: newValue => {
                    root.wallpaperSource = newValue;
                }
            }

            DankTextField {
                id: wallpaperQuery
                width: parent.width * 0.7
                height: parent.height
                placeholderText: "Search for photos"
                Keys.onReturnPressed: {
                    wallpaperFetcher.running = true;
                }

                Keys.onEnterPressed: {
                    wallpaperFetcher.running = true;
                }
                onTextEdited: {
                    root.wallpaperQuery = text.trim();
                }
            }

            DankButton {
                width: parent.width * 0.1
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                iconName: "search"
                iconSize: Theme.iconSizeLarge
                onClicked: {
                    wallpaperFetcher.running = true;
                }
            }
        }

        Item {
            width: parent.width - Theme.spacingS * 2
            height: parent.height - options.height

            DankGridView {
                id: wallpaperGrid
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                cellWidth: width / 2
                cellHeight: height / 2
                clip: true
                enabled: root.active
                interactive: root.active
                boundsBehavior: Flickable.StopAtBounds
                keyNavigationEnabled: false
                activeFocusOnTab: false
                highlightFollowsCurrentItem: true
                highlightMoveDuration: enableAnimation ? Theme.shortDuration : 0
                focus: false

                // highlight: Item {
                //     z: 1000
                //     Rectangle {
                //         anchors.fill: parent
                //         anchors.margins: Theme.spacingXS
                //         color: "transparent"
                //         border.width: 3
                //         border.color: Theme.primary
                //         radius: Theme.cornerRadius
                //     }
                // }

                model: {
                    switch (root.wallpaperSource) {
                    case "unsplash":
                        return root.wallpapers.results == "undefined" ? [] : root.wallpapers.results;
                    }
                    return [];
                }

                onModelChanged: {
                    const clampedIndex = model.length > 0 ? Math.min(Math.max(0, gridIndex), model.length - 1) : 0;
                    if (gridIndex !== clampedIndex) {
                        gridIndex = clampedIndex;
                    }
                }

                onCountChanged: {
                    if (count > 0) {
                        const clampedIndex = Math.min(gridIndex, count - 1);
                        currentIndex = clampedIndex;
                        positionViewAtIndex(clampedIndex, GridView.Contain);
                    }
                    enableAnimation = true;
                }

                Connections {
                    target: root
                    function onGridIndexChanged() {
                        if (wallpaperGrid.count > 0) {
                            wallpaperGrid.currentIndex = gridIndex;
                            if (!enableAnimation) {
                                wallpaperGrid.positionViewAtIndex(gridIndex, GridView.Contain);
                            }
                        }
                    }
                }

                delegate: Item {
                    width: wallpaperGrid.cellWidth
                    height: wallpaperGrid.cellHeight
                    required property var modelData
                    required property int index

                    property string wallpaperPath: {
                        switch (root.wallpaperSource) {
                        case "unsplash":
                            return modelData.urls.regular;
                        }
                        return "";
                    }
                    property bool downloaded: false
                    property bool isSelected: wallpaperGrid.currentIndex === index

                    Rectangle {
                        id: wallpaperCard
                        anchors.fill: parent
                        anchors.margins: Theme.spacingXS
                        color: Theme.surfaceContainerHighest
                        radius: Theme.cornerRadius
                        clip: true

                        Rectangle {
                            anchors.fill: parent
                            color: downloaded ? Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.7) : "transparent"
                            radius: parent.radius

                            Behavior on color {
                                ColorAnimation {
                                    duration: Theme.shortDuration
                                    easing.type: Theme.standardEasing
                                }
                            }
                        }

                        Image {
                            id: thumbnailImage
                            anchors.fill: parent
                            source: wallpaperPath
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            cache: true
                            smooth: true

                            layer.enabled: true
                            layer.effect: MultiEffect {
                                maskEnabled: true
                                maskThresholdMin: 0.5
                                maskSpreadAtMin: 1.0
                                maskSource: ShaderEffectSource {
                                    sourceItem: Rectangle {
                                        width: thumbnailImage.width
                                        height: thumbnailImage.height
                                        radius: Theme.cornerRadius
                                    }
                                }
                            }
                        }

                        BusyIndicator {
                            anchors.centerIn: parent
                            running: thumbnailImage.status === Image.Loading
                            visible: running
                        }

                        MouseArea {
                            id: wallpaperMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            Rectangle {
                                anchors.fill: parent
                                color: wallpaperMouseArea.containsMouse ? Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.7) : "transparent"
                                radius: wallpaperCard.radius
                                clip: true

                                Behavior on color {
                                    ColorAnimation {
                                        duration: Theme.shortDuration
                                        easing.type: Theme.standardEasing
                                    }
                                }

                                DankIcon {
                                    id: downloadIcon
                                    visible: wallpaperMouseArea.containsMouse
                                    anchors.centerIn: parent
                                    name: "download"
                                    color: wallpaperMouseArea.containsMouse ? Theme.primary : Theme.surfaceText
                                    size: Theme.iconSizeLarge * 2
                                }
                            }

                            onClicked: {
                                gridIndex = index;
                                if (modelData) {
                                    switch (root.wallpaperSource) {
                                    case "unsplash":
                                        download(modelData.id, modelData.urls.full);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Process {
        id: wallpaperFetcher
        command: getCommand()
        stdout: StdioCollector {
            onStreamFinished: root.wallpapers = JSON.parse(this.text)
        }
    }
}

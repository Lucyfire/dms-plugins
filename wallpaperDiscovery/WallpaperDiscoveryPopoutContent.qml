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

    enum WallpaperState {
        None,
        Downloaded,
        Downloading
    }

    required property var pluginService
    property bool isLoading: false
    property var wallpapers: {}
    property string wallpaperSource: "unsplash"
    property list<string> wallpaperSources: ["unsplash", "pexels"]
    property string wallpaperQuery: ""

    onWallpaperSourceChanged: {
        pluginService.savePluginData("wallpaperDiscovery", "lastWallpaperUsed", root.wallpaperSource);
    }

    Component.onCompleted: {
        root.wallpaperSource = pluginService.loadPluginData("wallpaperDiscovery", "lastWallpaperUsed", root.wallpaperSource);
    }

    function fetchWallpapers() {
        const source = root.wallpaperSource;
        const query = root.wallpaperQuery;
        switch (source) {
        case "unsplash":
            Proc.runCommand("wallpaperDiscoveryFetch", ["curl", "https://api.unsplash.com/search/photos?per_page=50&query=" + encodeURI(query), "-H", `authorization: Client-ID ${settingsData?.api_unsplash}`], (output, exitCode) => {
                root.isLoading = false;
                if (exitCode !== 0) {
                    ToastService?.showError("Query failed");
                    console.error("Wallpaper Discovery", output);
                    return;
                }
                const raw = output.trim();
                try {
                    root.wallpapers = JSON.parse(raw);
                } catch (e) {}
            });
            break;
        case "pexels":
            Proc.runCommand("wallpaperDiscoveryFetch", ["curl", "https://api.pexels.com/v1/search?page=1&per_page=100&query=" + encodeURI(query), "-H", `authorization: ${settingsData?.api_pexels}`], (output, exitCode) => {
                root.isLoading = false;
                if (exitCode !== 0) {
                    ToastService?.showError("Query failed");
                    console.error("Wallpaper Discovery", output);
                    return;
                }
                const raw = output.trim();
                try {
                    root.wallpapers = JSON.parse(raw);
                } catch (e) {}
            });
            break;
        }
        return {};
    }

    function download(filename: string, url: string): bool {
        const source = root.wallpaperSource;
        const dir = settingsData?.downloadLocation == undefined ? "" : settingsData.downloadLocation;
        if (dir == "") {
            ToastService?.showError("download location is not defined");
            return false;
        }
        const saveDir = Paths.expandTilde(`${dir}/${source}`);
        Paths.mkdir(saveDir);
        switch (source) {
        case "unsplash":
            Proc.runCommand("wallpaperDiscoveryDownload", ["sh", "-c", `curl '${url}' --output ${saveDir}/${filename}.jpeg`], (output, exitCode) => {
                if (exitCode !== 0) {
                    ToastService?.showError("Download Failed");
                    return false;
                }
                ToastService?.showInfo("Wallpaper saved");
            });
            break;
        case "pexels":
            Proc.runCommand("wallpaperDiscoveryDownload", ["sh", "-c", `curl '${url}' --output ${saveDir}/${filename}.jpeg`], (output, exitCode) => {
                if (exitCode !== 0) {
                    ToastService?.showError("Download Failed");
                    return false;
                }
                ToastService?.showInfo("Wallpaper saved");
            });
            break;
        }
        return true;
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
                    root.isLoading = true;
                    root.fetchWallpapers();
                }

                Keys.onEnterPressed: {
                    root.isLoading = true;
                    root.fetchWallpapers();
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
                    root.isLoading = true;
                    root.fetchWallpapers();
                }
            }
        }

        Item {
            width: parent.width - Theme.spacingS * 2
            height: parent.height - options.height

            BusyIndicator {
                z: 1000
                anchors.centerIn: parent
                running: root.isLoading
                visible: running

                contentItem: Spinner {}
                background: Rectangle {
                    width: parent.parent.width
                    height: parent.parent.height
                    anchors.centerIn: parent
                    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.7)
                }
            }

            DankGridView {
                id: wallpaperGrid
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                cellWidth: width / 2
                cellHeight: height / 2
                clip: true
                enabled: !root.isLoading
                interactive: !root.isLoading
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
                        if (root.wallpapers?.results == undefined) {
                            return [];
                        }
                        return root.wallpapers.results;
                    case "pexels":
                        if (root.wallpapers?.photos == undefined) {
                            return [];
                        }
                        return root.wallpapers.photos;
                    }
                    return [];
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
                        case "pexels":
                            return modelData.src.medium;
                        }
                        return "";
                    }
                    property int itemState: WallpaperDiscoveryPopoutContent.WallpaperState.None
                    property bool isSelected: wallpaperGrid.currentIndex === index

                    Rectangle {
                        id: wallpaperCard
                        anchors.fill: parent
                        anchors.margins: Theme.spacingXS
                        color: Theme.surfaceContainerHighest
                        radius: Theme.cornerRadius
                        clip: true

                        Rectangle {
                            z: 2
                            anchors.fill: parent
                            color: itemState == WallpaperDiscoveryPopoutContent.WallpaperState.Downloaded ? Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.7) : "transparent"
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
                            running: thumbnailImage.status === Image.Loading || itemState === WallpaperDiscoveryPopoutContent.WallpaperState.Downloading
                            visible: running
                            contentItem: Spinner {}
                            background: Rectangle {
                                visible: itemState === WallpaperDiscoveryPopoutContent.WallpaperState.Downloading
                                width: parent.parent.width
                                height: parent.parent.height
                                anchors.centerIn: parent
                                color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.7)
                            }
                        }

                        MouseArea {
                            id: wallpaperMouseArea
                            visible: itemState === WallpaperDiscoveryPopoutContent.WallpaperState.None
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
                                itemState = WallpaperDiscoveryPopoutContent.WallpaperState.Downloading;
                                switch (root.wallpaperSource) {
                                case "unsplash":
                                    itemState = download(modelData.id, modelData.urls.full) ? WallpaperDiscoveryPopoutContent.WallpaperState.Downloaded : WallpaperDiscoveryPopoutContent.WallpaperState.None;
                                case "pexels":
                                    itemState = download(modelData.id, modelData.src.original) ? WallpaperDiscoveryPopoutContent.WallpaperState.Downloaded : WallpaperDiscoveryPopoutContent.WallpaperState.None;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    component Spinner: Rectangle {
        implicitWidth: 48
        implicitHeight: 48
        color: "transparent"

        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.lineWidth = 4;
                ctx.strokeStyle = Theme.primary;
                ctx.beginPath();
                ctx.arc(width / 2, height / 2, width / 2 - 4, 0, Math.PI * 1.5);
                ctx.stroke();
            }
            RotationAnimator on rotation {
                from: 0
                to: 360
                duration: 800
                loops: Animation.Infinite
                running: parent.running
            }
        }
    }
}

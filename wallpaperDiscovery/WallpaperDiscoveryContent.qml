pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Modals.FileBrowser
import qs.Services
import qs.Widgets

Item {
    id: root

    required property var settingsData
    required property var pluginService

    enum WallpaperState {
        None,
        Downloaded,
        Downloading
    }

    property int itemHeight: 220

    property bool isLoading: false
    property int page: 1
    property int lastPage: -1
    property string wallpaperSource: settingsData.lastWallpaperUsed || "wallhaven.cc"
    property list<string> wallpaperSources: ["unsplash", "pexels", "wallhaven.cc"]
    property string wallpaperQuery: ""
    property bool enableAnimation: false

    function setSource(s: string) {
        page = 1;
        lastPage = -1;
        wallpaperModel.clear();
        root.wallpaperSource = s;
        pluginService.savePluginData("wallpaperDiscovery", "lastWallpaperUsed", root.wallpaperSource);
    }

    function search() {
        root.isLoading = true;
        root.page = 1;
        wallpaperModel.clear();
        root.fetchWallpapers();
    }

    function fetchWallpapers() {
        const source = root.wallpaperSource;
        const query = root.wallpaperQuery;
        const cmd = ["curl"];
        switch (source) {
        case "unsplash":
            cmd.push(`https://api.unsplash.com/search/photos?page=${root.page}&per_page=10&query=` + encodeURI(query), "-H", `authorization: Client-ID ${settingsData?.api_unsplash}`);
            break;
        case "pexels":
            cmd.push(`https://api.pexels.com/v1/search?page=${root.page}&per_page=30&query=` + encodeURI(query), "-H", `authorization: ${settingsData?.api_pexels}`);
            break;
        case "wallhaven.cc":
            cmd.push(`https://wallhaven.cc/api/v1/search?page=${root.page}&sorting=relevance&q=` + encodeURI(query));
            if (settingsData?.api_wallhavencc !== undefined && settingsData.api_wallhavencc !== "") {
                cmd.push("-H");
                cmd.push(`X-API-Key:${settingsData.api_wallhavencc}`);
            }
            break;
        }
        Proc.runCommand(`wallpaperDiscoveryFetch:${root.wallpaperSource}`, cmd, (output, exitCode) => {
            root.isLoading = false;
            if (exitCode !== 0) {
                ToastService?.showError("Query failed");
                console.error("Wallpaper Discovery", output);
                return;
            }
            const raw = output.trim();
            try {
                const parsedResponse = JSON.parse(raw);
                let tmp, item;
                switch (source) {
                case "unsplash":
                    tmp = parsedResponse.results || [];
                    root.lastPage = (parsedResponse?.total_pages || -1) / 10;
                    break;
                case "pexels":
                    tmp = parsedResponse.photos || [];
                    root.lastPage = (parsedResponse?.total_results || -1) / 30;
                    break;
                case "wallhaven.cc":
                    tmp = parsedResponse.data || [];
                    root.lastPage = parsedResponse?.meta?.last_page || -1;
                    break;
                }
                for (let i = 0; i < tmp.length; i++) {
                    item = wallaperItemComp.createObject(wallpaperModel);
                    item.source = source;
                    item.create(tmp[i]);
                    wallpaperModel.append(item);
                }
            } catch (e) {}
        });
        return;
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

        Proc.runCommand("wallpaperDiscoveryDownload", ["sh", "-c", `curl '${url}' --output ${saveDir}/${filename}.jpeg`], (output, exitCode) => {
            if (exitCode !== 0) {
                ToastService?.showError("Download Failed");
                return false;
            }
            ToastService?.showInfo("Wallpaper saved");
        });
        return true;
    }

    Column {
        anchors.fill: parent
        spacing: Theme.spacingS

        Row {
            id: options

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
                    root.setSource(newValue);
                }
            }

            DankTextField {
                id: wallpaperQuery
                width: parent.width * 0.7
                height: parent.height
                placeholderText: "Search for photos"
                Keys.onReturnPressed: {
                    root.search();
                }

                Keys.onEnterPressed: {
                    root.search();
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
                    root.search();
                }
            }
        }

        ListModel {
            id: wallpaperModel
        }
        Item {
            width: parent.width - Theme.spacingS * 2
            height: parent.height - options.height

            BusyIndicator {
                z: 1000
                anchors.centerIn: parent
                running: root.isLoading
                visible: running

                contentItem: Spinner {
                    width: 50
                    height: 50
                }
                background: Rectangle {
                    width: parent.parent.width
                    height: parent.parent.height
                    anchors.centerIn: parent
                    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.7)
                }
            }

            ColumnLayout {
                id: renderArea
                width: parent.width
                height: parent.height

                DankGridView {
                    id: wallpaperGrid
                    Layout.alignment: Qt.AlignCenter
                    cellWidth: width / 2
                    cellHeight: {
                        const availH = renderArea.height - loadMore.implicitHeight;
                        return availH / (availH % root.itemHeight);
                    }
                    clip: true
                    enabled: !root.isLoading
                    interactive: !root.isLoading
                    boundsBehavior: Flickable.StopAtBounds
                    keyNavigationEnabled: false
                    activeFocusOnTab: false
                    highlightFollowsCurrentItem: true
                    highlightMoveDuration: enableAnimation ? Theme.shortDuration : 0
                    focus: false
                    Layout.fillHeight: true
                    Layout.fillWidth: true

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

                    model: wallpaperModel
                    delegate: Item {
                        width: wallpaperGrid.cellWidth
                        height: wallpaperGrid.cellHeight
                        required property var modelData
                        required property int index

                        property int itemState: WallpaperDiscoveryContent.WallpaperState.None
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
                                color: itemState == WallpaperDiscoveryContent.WallpaperState.Downloaded ? Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.7) : "transparent"
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
                                source: {
                                    return modelData.thumbnail;
                                }
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
                                running: thumbnailImage.status === Image.Loading || itemState === WallpaperDiscoveryContent.WallpaperState.Downloading
                                visible: running
                                contentItem: Spinner {}
                                background: Rectangle {
                                    visible: itemState === WallpaperDiscoveryContent.WallpaperState.Downloading
                                    width: parent.parent.width
                                    height: parent.parent.height
                                    anchors.centerIn: parent
                                    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.7)
                                }
                            }

                            MouseArea {
                                id: wallpaperMouseArea
                                visible: itemState === WallpaperDiscoveryContent.WallpaperState.None
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
                                    itemState = WallpaperDiscoveryContent.WallpaperState.Downloading;
                                    itemState = download(modelData.id, modelData.downloadUrl) ? WallpaperDiscoveryContent.WallpaperState.Downloaded : WallpaperDiscoveryContent.WallpaperState.None;
                                }
                            }
                        }
                    }
                }

                DankButton {
                    id: loadMore

                    visible: {
                        if (root.isLoading) {
                            return false;
                        }
                        return root.lastPage > root.page;
                    }
                    Layout.alignment: Qt.AlignCenter
                    Layout.bottomMargin: 50

                    text: "Load More"
                    onClicked: {
                        root.page++;
                        root.isLoading = true;
                        root.fetchWallpapers();
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

    component WallpaperItem: QtObject {
        property string id: ""
        property string thumbnail: ""
        property string downloadUrl: ""
        property string source: ""

        function create(v: var) {
            id = "" + v.id || "";
            switch (source) {
            case "unsplash":
                thumbnail = v?.urls?.regular || "";
                downloadUrl = v?.urls?.full || "";
                break;
            case "pexels":
                thumbnail = v?.src?.medium || "";
                downloadUrl = v?.src?.original || "";
                break;
            case "wallhaven.cc":
                thumbnail = v?.thumbs?.large || "";
                downloadUrl = v?.path || "";
                break;
            }
        }
    }

    Component {
        id: wallaperItemComp
        WallpaperItem {}
    }
}

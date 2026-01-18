import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: fullRep
    
    Layout.minimumWidth: Kirigami.Units.gridUnit * 20
    Layout.minimumHeight: Kirigami.Units.gridUnit * 15
    Layout.preferredWidth: Kirigami.Units.gridUnit * 25
    Layout.preferredHeight: Kirigami.Units.gridUnit * 20

    spacing: Kirigami.Units.largeSpacing

    // Header with station info
    PlasmaExtras.PlasmoidHeading {
        Layout.fillWidth: true

        ColumnLayout {
            anchors.fill: parent
            spacing: Kirigami.Units.smallSpacing

            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                Kirigami.Icon {
                    source: Plasmoid.rootItem.currentStation && Plasmoid.rootItem.currentStation.favicon ? 
                            Plasmoid.rootItem.currentStation.favicon : "media-album-cover"
                    Layout.preferredWidth: Kirigami.Units.iconSizes.large
                    Layout.preferredHeight: Kirigami.Units.iconSizes.large
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    PlasmaComponents.Label {
                        Layout.fillWidth: true
                        text: Plasmoid.rootItem.currentStation ? Plasmoid.rootItem.currentStation.name : "No Station"
                        font.weight: Font.Bold
                        font.pixelSize: Kirigami.Units.gridUnit * 0.9
                        elide: Text.ElideRight
                    }

                    PlasmaComponents.Label {
                        Layout.fillWidth: true
                        text: {
                            if (!Plasmoid.rootItem.currentStation) return "";
                            let parts = [];
                            if (Plasmoid.rootItem.currentStation.country) parts.push(Plasmoid.rootItem.currentStation.country);
                            if (Plasmoid.rootItem.currentStation.bitrate) parts.push(Plasmoid.rootItem.currentStation.bitrate);
                            if (Plasmoid.rootItem.currentStation.codec) parts.push(Plasmoid.rootItem.currentStation.codec);
                            return parts.join(" • ");
                        }
                        font.pixelSize: Kirigami.Units.gridUnit * 0.7
                        opacity: 0.7
                        elide: Text.ElideRight
                    }
                }
            }

            // Error message
            PlasmaComponents.Label {
                Layout.fillWidth: true
                text: Plasmoid.rootItem.errorMessage
                color: Kirigami.Theme.negativeTextColor
                visible: Plasmoid.rootItem.errorMessage !== ""
                wrapMode: Text.WordWrap
                font.pixelSize: Kirigami.Units.gridUnit * 0.6
            }
        }
    }

    // Main controls
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: Kirigami.Units.largeSpacing

        PlasmaComponents.Button {
            icon.name: "media-skip-backward"
            text: "Roam"
            onClicked: {
                Plasmoid.rootItem.retryCount = 0;
                Plasmoid.rootItem.roamToRandomStation();
            }
            enabled: !Plasmoid.rootItem.isLoading
        }

        PlasmaComponents.Button {
            icon.name: Plasmoid.rootItem.isPlaying ? "media-playback-pause" : "media-playback-start"
            text: Plasmoid.rootItem.isPlaying ? "Pause" : "Play"
            onClicked: Plasmoid.rootItem.togglePlayPause()
            enabled: !Plasmoid.rootItem.isLoading
        }

        PlasmaComponents.Button {
            icon.name: Plasmoid.rootItem.isFavorited() ? "starred-symbolic" : "non-starred-symbolic"
            text: Plasmoid.rootItem.isFavorited() ? "Unfavorite" : "Favorite"
            onClicked: Plasmoid.rootItem.toggleFavorite()
            enabled: Plasmoid.rootItem.currentStation !== null
        }
    }

    // Tabs
    PlasmaComponents.TabBar {
        id: tabBar
        Layout.fillWidth: true

        PlasmaComponents.TabButton {
            text: "Favorites (" + Plasmoid.rootItem.favorites.length + ")"
        }

        PlasmaComponents.TabButton {
            text: "Filters"
        }
    }

    // Tab content
    StackLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        currentIndex: tabBar.currentIndex

        // Favorites tab
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            PlasmaComponents.ScrollView {
                anchors.fill: parent

                ListView {
                    id: favoritesListView
                    model: Plasmoid.rootItem.favorites
                    spacing: Kirigami.Units.smallSpacing

                    delegate: PlasmaExtras.ListItem {
                        width: favoritesListView.width

                        RowLayout {
                            anchors.fill: parent
                            spacing: Kirigami.Units.smallSpacing

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                PlasmaComponents.Label {
                                    Layout.fillWidth: true
                                    text: modelData.name
                                    font.weight: Font.Bold
                                    elide: Text.ElideRight
                                }

                                PlasmaComponents.Label {
                                    Layout.fillWidth: true
                                    text: {
                                        let parts = [];
                                        if (modelData.country) parts.push(modelData.country);
                                        if (modelData.bitrate) parts.push(modelData.bitrate + " kbps");
                                        return parts.join(" • ");
                                    }
                                    font.pixelSize: Kirigami.Units.gridUnit * 0.7
                                    opacity: 0.7
                                    elide: Text.ElideRight
                                }
                            }

                            PlasmaComponents.Button {
                                icon.name: "media-playback-start"
                                text: "Play"
                                onClicked: Plasmoid.rootItem.playFavorite(modelData)
                            }

                            PlasmaComponents.Button {
                                icon.name: "edit-delete"
                                onClicked: {
                                    Plasmoid.rootItem.favorites = Favorites.removeFavorite(Plasmoid.rootItem.favorites, modelData.uuid);
                                    Plasmoid.rootItem.saveFavorites();
                                }
                            }
                        }
                    }

                    PlasmaExtras.PlaceholderMessage {
                        anchors.centerIn: parent
                        width: parent.width - (Kirigami.Units.largeSpacing * 4)
                        visible: Plasmoid.rootItem.favorites.length === 0
                        text: "No favorites yet"
                        explanation: "Click the star button to add the current station to favorites"
                        iconName: "starred-symbolic"
                    }
                }
            }
        }

        // Filters tab
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.largeSpacing

                PlasmaComponents.Label {
                    text: "Excluded Languages"
                    font.weight: Font.Bold
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    PlasmaComponents.TextField {
                        id: languageInput
                        Layout.fillWidth: true
                        placeholderText: "e.g., english, spanish"
                        onAccepted: {
                            if (text.trim() !== "") {
                                Plasmoid.rootItem.addLanguageFilter(text.trim());
                                text = "";
                            }
                        }
                    }

                    PlasmaComponents.Button {
                        icon.name: "list-add"
                        text: "Add"
                        onClicked: {
                            if (languageInput.text.trim() !== "") {
                                Plasmoid.rootItem.addLanguageFilter(languageInput.text.trim());
                                languageInput.text = "";
                            }
                        }
                    }
                }

                Flow {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    Repeater {
                        model: Plasmoid.rootItem.excludedLanguages

                        PlasmaComponents.Button {
                            text: modelData
                            icon.name: "edit-delete"
                            onClicked: Plasmoid.rootItem.removeLanguageFilter(modelData)
                        }
                    }
                }

                PlasmaComponents.Label {
                    text: "Quality Settings"
                    font.weight: Font.Bold
                    Layout.topMargin: Kirigami.Units.largeSpacing
                }

                RowLayout {
                    Layout.fillWidth: true

                    PlasmaComponents.Label {
                        text: "Minimum Bitrate:"
                    }

                    QQC2.Slider {
                        id: bitrateSlider
                        Layout.fillWidth: true
                        from: 64
                        to: 320
                        stepSize: 64
                        value: Plasmoid.rootItem.minBitrate
                        snapMode: QQC2.Slider.SnapAlways
                        onMoved: {
                            plasmoid.configuration.minBitrate = value;
                            Plasmoid.rootItem.fetchStations();
                        }
                    }

                    PlasmaComponents.Label {
                        text: bitrateSlider.value + " kbps"
                        Layout.minimumWidth: Kirigami.Units.gridUnit * 4
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }
}

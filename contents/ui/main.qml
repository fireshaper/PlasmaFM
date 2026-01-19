import QtQuick
import QtQuick.Layouts
import QtMultimedia
import Qt5Compat.GraphicalEffects
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami
import "../code/radiobrowser.js" as RadioBrowser
import "../code/favorites.js" as Favorites
import "../code/countries.js" as Countries

PlasmoidItem {
    id: root

    // Properties
    property var stationCache: []
    property var currentStation: null
    property bool isPlaying: false
    property bool isLoading: false
    property string errorMessage: ""
    property var favorites: []
    property int retryCount: 0

    // Config bindings
    property int minBitrate: plasmoid.configuration.minBitrate
    property bool skipDeadStations: plasmoid.configuration.skipDeadStations
    property int maxRetries: plasmoid.configuration.maxRetries
    property var excludedLanguages: []

    // UI sizing
    Layout.minimumWidth: Kirigami.Units.gridUnit * 20
    Layout.minimumHeight: Kirigami.Units.gridUnit * 15
    // Compact representation (icon in panel)
    Plasmoid.icon: {
        if (root.isLoading) return "media-playlist-shuffle";
        if (root.isPlaying) return "media-playback-playing";
        return "media-playback-start";
    }

    // Full representation (expanded view)
    fullRepresentation: Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumWidth: Kirigami.Units.gridUnit * 20
        Layout.minimumHeight: Kirigami.Units.gridUnit * 15

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.largeSpacing

        // Header with controls
        RowLayout {
        Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            PlasmaComponents.Label {
                text: "PlasmaFM"
                font.pixelSize: Kirigami.Units.gridUnit * 1.2
                font.weight: Font.Bold
                color: Kirigami.Theme.textColor
            }

            Item { Layout.fillWidth: true }

            PlasmaComponents.ToolButton {
                icon.name: "media-playback-start"
                enabled: !root.isLoading
                onClicked: root.togglePlayPause()
            }

            PlasmaComponents.ToolButton {
                icon.name: "media-skip-forward"
                enabled: !root.isLoading
                onClicked: root.roamToRandomStation()
            }

            PlasmaComponents.ToolButton {
                icon.name: "media-playback-stop"
                enabled: root.isPlaying
                onClicked: root.stop()
            }
        }

        // Status and station name
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Kirigami.Units.smallSpacing

                Rectangle {
                    width: Kirigami.Units.gridUnit * 0.6
                    height: width
                    radius: width / 2
                    color: root.isPlaying ? "#4CAF50" : "#9E9E9E"
                }

                PlasmaComponents.Label {
                    text: root.isPlaying ? "Now Playing" : (root.isLoading ? "Loading..." : "Not Playing")
                    font.pixelSize: Kirigami.Units.gridUnit * 0.8
                    color: Kirigami.Theme.textColor
                    opacity: 0.7
                }
            }

            PlasmaComponents.Label {
                Layout.fillWidth: true
                text: root.currentStation ? root.currentStation.name : "Click skip to start"
                font.pixelSize: Kirigami.Units.gridUnit * 1.1
                font.weight: Font.Bold
                color: Kirigami.Theme.textColor
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                maximumLineCount: 1
            }
        }

        // Globe visualization - 2D map behind circular mask
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter

            // Circular container
            Item {
                id: globeContainer
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height) * 0.7
                height: width

                // Container for tiled maps
                Item {
                    id: mapContainer
                    width: parent.width * 2.5 * 3  // 3 copies side by side
                    height: parent.height * 2.5
                    
                    // Calculate base position for center tile
                    property real baseX: {
                        if (!root.currentStation || root.currentStation.geo_long === null) {
                            return -(width / 3 - parent.width) / 2; // Default to center (0,0)
                        }
                        var lon = root.currentStation.geo_long;
                        var normalizedLon = (lon + 180) / 360;
                        var mapX = normalizedLon * (width / 3);
                        return parent.width / 2 - mapX - (width / 3);
                    }
                    
                    property real baseY: {
                        if (!root.currentStation || root.currentStation.geo_lat === null) {
                            return -(height - parent.height) / 2;
                        }
                        var lat = root.currentStation.geo_lat;
                        var normalizedLat = (90 - lat) / 180;
                        var mapY = normalizedLat * height;
                        return parent.height / 2 - mapY;
                    }
                    
                    x: baseX
                    y: baseY
                    
                    Behavior on x {
                        NumberAnimation {
                            duration: 1500
                            easing.type: Easing.InOutCubic
                        }
                    }
                    
                    Behavior on y {
                        NumberAnimation {
                            duration: 1500
                            easing.type: Easing.InOutCubic
                        }
                    }
                    
                    // Left tile
                    Image {
                        x: 0
                        width: parent.width / 3
                        height: parent.height
                        source: "../images/earth.jpg"
                        fillMode: Image.Stretch
                        smooth: true
                    }
                    
                    // Center tile
                    Image {
                        x: parent.width / 3
                        width: parent.width / 3
                        height: parent.height
                        source: "../images/earth.jpg"
                        fillMode: Image.Stretch
                        smooth: true
                    }
                    
                    // Right tile
                    Image {
                        x: parent.width / 3 * 2
                        width: parent.width / 3
                        height: parent.height
                        source: "../images/earth.jpg"
                        fillMode: Image.Stretch
                        smooth: true
                    }
                }

                // Circular border
                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: "transparent"
                    border.color: Kirigami.Theme.textColor
                    border.width: 2
                    opacity: 0.3
                }

                // Clip to circle using layer
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: globeContainer.width
                        height: globeContainer.height
                        radius: width / 2
                    }
                }
            }

            // Station location marker (red dot in center)
            Rectangle {
                visible: root.currentStation && root.currentStation.geo_lat !== null && root.currentStation.geo_long !== null
                anchors.centerIn: globeContainer
                width: Kirigami.Units.gridUnit * 0.8
                height: width
                radius: width / 2
                color: "#FF5252"
                border.color: "white"
                border.width: 2
                z: 10
                
                // Pulsing animation
                SequentialAnimation on scale {
                    running: root.isPlaying && root.currentStation !== null
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.3; duration: 800; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
                }
            }
        }

        // Bottom info
        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            PlasmaComponents.ToolButton {
                icon.name: "configure"
                onClicked: plasmoid.action("configure").trigger()
            }

            RowLayout {
                spacing: Kirigami.Units.smallSpacing

                Kirigami.Icon {
                    source: "flag"
                    width: Kirigami.Units.iconSizes.small
                    height: Kirigami.Units.iconSizes.small
                }

                PlasmaComponents.Label {
                    text: root.currentStation ? root.shortenCountryName(root.currentStation.country) : ""
                    font.pixelSize: Kirigami.Units.gridUnit * 0.9
                    color: Kirigami.Theme.textColor
                }
            }

            Item { Layout.fillWidth: true }

            PlasmaComponents.ToolButton {
                icon.name: root.isFavorited() ? "starred-symbolic" : "non-starred-symbolic"
                enabled: root.currentStation !== null
                onClicked: root.toggleFavorite()
            }
        }
        }
    }

    // Config change handlers
    onMinBitrateChanged: {
        if (minBitrate !== plasmoid.configuration.minBitrate) {
            fetchStations();
        }
    }

    Connections {
        target: plasmoid.configuration
        function onExcludedLanguagesChanged() {
            loadExcludedLanguages();
            fetchStations();
        }
    }

    // Audio player
    MediaPlayer {
        id: audioPlayer
        audioOutput: AudioOutput {}

        onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.PlayingState) {
                root.isPlaying = true;
                root.isLoading = false;
                root.retryCount = 0;
            } else if (playbackState === MediaPlayer.StoppedState) {
                root.isPlaying = false;
            }
        }

        onErrorOccurred: {
            console.error("Playback error:", errorString);
            root.errorMessage = errorString;
            root.isLoading = false;
            
            // Retry with next station if enabled
            if (root.skipDeadStations && root.retryCount < root.maxRetries) {
                root.retryCount++;
                console.log("Retrying... attempt", root.retryCount);
                retryTimer.start();
            } else {
                root.isPlaying = false;
            }
        }
    }

    // Retry timer
    Timer {
        id: retryTimer
        interval: 500
        repeat: false
        onTriggered: {
            root.roamToRandomStation();
        }
    }

    // Initialize
    Component.onCompleted: {
        loadFavorites();
        loadExcludedLanguages();
        fetchStations();
    }

    // Functions
    function loadFavorites() {
        const favString = plasmoid.configuration.favorites;
        favorites = Favorites.loadFavorites(favString);
    }

    function saveFavorites() {
        const favString = Favorites.saveFavorites(favorites);
        plasmoid.configuration.favorites = favString;
    }

    function loadExcludedLanguages() {
        try {
            const langString = plasmoid.configuration.excludedLanguages;
            if (langString && langString !== "[]") {
                excludedLanguages = JSON.parse(langString);
            } else {
                excludedLanguages = [];
            }
        } catch (e) {
            console.error("Failed to load excluded languages:", e);
            excludedLanguages = [];
        }
    }

    function saveExcludedLanguages() {
        try {
            plasmoid.configuration.excludedLanguages = JSON.stringify(excludedLanguages);
        } catch (e) {
            console.error("Failed to save excluded languages:", e);
        }
    }

    function fetchStations() {
        root.isLoading = true;
        RadioBrowser.fetchRandomStations(
            root.minBitrate,
            root.excludedLanguages,
            100,
            function(stations, error) {
                root.isLoading = false;
                if (error) {
                    console.error("Failed to fetch stations:", error);
                    root.errorMessage = "Failed to fetch stations: " + error;
                    return;
                }
                root.stationCache = stations;
                console.log("Fetched", stations.length, "stations");
            }
        );
    }

    function roamToRandomStation() {
        if (root.stationCache.length === 0) {
            console.log("No stations in cache, fetching...");
            fetchStations();
            return;
        }

        const station = RadioBrowser.getRandomStation(root.stationCache);
        if (!station) {
            console.error("Failed to get random station");
            return;
        }

        playStation(station);
    }

    // Shorten long country names for display
    function shortenCountryName(country) {
        if (!country) return "";
        
        // Map of long names to short names
        var nameMap = {
            "The United Kingdom of Great Britain and Northern Ireland": "The United Kingdom",
            "United Kingdom of Great Britain and Northern Ireland": "United Kingdom",
            "The United States of America": "United States",
            "United States of America": "United States"
        };
        
        return nameMap[country] || country;
    }

    function playStation(station) {
        if (!station || !station.url_resolved) {
            console.error("Invalid station");
            return;
        }

        const info = RadioBrowser.getStationInfo(station);
        
        // If no coordinates from station, try country lookup
        if ((info.geo_lat === null || info.geo_long === null) && info.country) {
            const countryCoords = Countries.getCountryCoordinates(info.country);
            if (countryCoords) {
                info.geo_lat = countryCoords.lat;
                info.geo_long = countryCoords.lon;
            }
        }
        
        root.currentStation = info;
        root.isLoading = true;
        root.errorMessage = "";

        console.log("Playing:", info.name, "-", info.url);
        
        audioPlayer.stop();
        audioPlayer.source = info.url;
        audioPlayer.play();
    }

    function togglePlayPause() {
        if (!root.currentStation) {
            roamToRandomStation();
            return;
        }

        if (root.isPlaying) {
            audioPlayer.pause();
        } else {
            audioPlayer.play();
        }
    }

    function stop() {
        audioPlayer.stop();
        root.isPlaying = false;
    }

    function isFavorited() {
        if (!root.currentStation) return false;
        return Favorites.isFavorite(favorites, root.currentStation.uuid);
    }

    function toggleFavorite() {
        if (!root.currentStation) return;
        
        if (isFavorited()) {
            favorites = Favorites.removeFavorite(favorites, root.currentStation.uuid);
        } else {
            favorites = Favorites.addFavorite(favorites, root.currentStation);
        }
        saveFavorites();
    }
}
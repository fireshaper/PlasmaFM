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

    // Get reference to root item
    property var root: parent.parent.parent

    PlasmaExtras.PlasmoidHeading {
        Layout.fillWidth: true
        
        RowLayout {
            anchors.fill: parent
            
            PlasmaComponents.Label {
                Layout.fillWidth: true
                text: "PlasmaFM Radio"
                font.weight: Font.Bold
                font.pixelSize: Kirigami.Units.gridUnit * 1.2
            }
            
            PlasmaComponents.Label {
                text: root && root.isLoading ? "Loading..." : (root && root.currentStation ? root.currentStation.name : "Not playing")
                elide: Text.ElideRight
                opacity: 0.7
            }
        }
    }

    // Station info
    ColumnLayout {
        Layout.fillWidth: true
        visible: root && root.currentStation !== null
        spacing: Kirigami.Units.smallSpacing

        PlasmaComponents.Label {
            Layout.fillWidth: true
            text: root && root.currentStation ? root.currentStation.name : ""
            font.weight: Font.Bold
            elide: Text.ElideRight
        }

        PlasmaComponents.Label {
            Layout.fillWidth: true
            text: root && root.currentStation ? (root.currentStation.country + " • " + root.currentStation.bitrate + " kbps") : ""
            opacity: 0.7
            font.pixelSize: Kirigami.Units.gridUnit * 0.8
        }
    }

    // Control buttons
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: Kirigami.Units.largeSpacing

        PlasmaComponents.Button {
            icon.name: "media-skip-backward"
            text: "Roam"
            onClicked: {
                console.log("Roam button clicked! Root:", root);
                if (root && root.roamToRandomStation) {
                    root.roamToRandomStation();
                } else {
                    console.error("roamToRandomStation not found on root");
                }
            }
        }

        PlasmaComponents.Button {
            icon.name: root && root.isPlaying ? "media-playback-pause" : "media-playback-start"
            text: root && root.isPlaying ? "Pause" : "Play"
            enabled: root && root.currentStation !== null
            onClicked: {
                console.log("Play/Pause clicked!");
                if (root && root.togglePlayPause) {
                    root.togglePlayPause();
                }
            }
        }

        PlasmaComponents.Button {
            icon.name: "media-playback-stop"
            text: "Stop"
            enabled: root && root.currentStation !== null
            onClicked: {
                console.log("Stop clicked!");
                if (root && root.stop) {
                    root.stop();
                }
            }
        }

        PlasmaComponents.Button {
            icon.name: root && root.isFavorited && root.isFavorited() ? "starred-symbolic" : "non-starred-symbolic"
            text: "Favorite"
            enabled: root && root.currentStation !== null
            onClicked: {
                console.log("Favorite clicked!");
                if (root && root.toggleFavorite) {
                    root.toggleFavorite();
                }
            }
        }
    }

    Item {
        Layout.fillHeight: true
    }
}

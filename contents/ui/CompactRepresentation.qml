import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

Item {
    id: compact

    Layout.minimumWidth: Kirigami.Units.gridUnit * 3
    Layout.minimumHeight: Kirigami.Units.gridUnit * 3
    Layout.preferredWidth: Layout.minimumWidth
    Layout.preferredHeight: Layout.minimumHeight

    MouseArea {
        anchors.fill: parent
        onClicked: Plasmoid.expanded = !Plasmoid.expanded
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            id: icon
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: Kirigami.Units.iconSizes.medium
            Layout.preferredHeight: Kirigami.Units.iconSizes.medium
            source: {
                if (Plasmoid.rootItem.isLoading) return "media-playlist-shuffle";
                if (Plasmoid.rootItem.isPlaying) return "media-playback-playing";
                return "media-playback-start";
            }
            
            // Pulse animation when loading
            SequentialAnimation on opacity {
                running: Plasmoid.rootItem.isLoading
                loops: Animation.Infinite
                NumberAnimation { to: 0.3; duration: 600 }
                NumberAnimation { to: 1.0; duration: 600 }
            }
        }

        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignHCenter
            text: {
                if (Plasmoid.rootItem.isLoading) return "...";
                if (Plasmoid.rootItem.currentStation) {
                    return Plasmoid.rootItem.currentStation.name.substring(0, 12) + 
                           (Plasmoid.rootItem.currentStation.name.length > 12 ? "..." : "");
                }
                return "Roam";
            }
            font.pixelSize: Kirigami.Units.gridUnit * 0.6
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            visible: Plasmoid.rootItem.currentStation !== null || Plasmoid.rootItem.isLoading
        }
    }
}

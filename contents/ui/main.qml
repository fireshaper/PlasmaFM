import QtQuick
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    width: Kirigami.Units.gridUnit * 10
    height: Kirigami.Units.gridUnit * 10

    Plasmoid.backgroundHints: "StandardBackground"

    fullRepresentation: Item {
        Layout.minimumWidth: Kirigami.Units.gridUnit * 15
        Layout.minimumHeight: Kirigami.Units.gridUnit * 10

        Text {
            anchors.centerIn: parent
            text: "Roam Radio Test\nWidget is working!"
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
        }
    }
}

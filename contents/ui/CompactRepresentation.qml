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
        onClicked: plasmoid.expanded = !plasmoid.expanded
    }

    Kirigami.Icon {
        anchors.centerIn: parent
        width: Kirigami.Units.iconSizes.medium
        height: Kirigami.Units.iconSizes.medium
        source: "media-playback-start"
    }
}

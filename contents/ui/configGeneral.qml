import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: generalPage

    property alias cfg_minBitrate: bitrateSlider.value
    property alias cfg_skipDeadStations: skipDeadCheckbox.checked
    property alias cfg_maxRetries: retriesSpinBox.value

    RowLayout {
        Kirigami.FormData.label: i18n("Minimum Bitrate:")
        
        QQC2.Slider {
            id: bitrateSlider
            from: 64
            to: 320
            stepSize: 64
            snapMode: QQC2.Slider.SnapAlways
        }
        
        QQC2.Label {
            text: bitrateSlider.value + " kbps"
        }
    }

    QQC2.CheckBox {
        id: skipDeadCheckbox
        Kirigami.FormData.label: i18n("Skip Dead Stations:")
        text: i18n("Automatically retry if stream fails")
    }

    QQC2.SpinBox {
        id: retriesSpinBox
        Kirigami.FormData.label: i18n("Max Retries:")
        from: 1
        to: 10
        enabled: skipDeadCheckbox.checked
    }

    Item {
        Kirigami.FormData.isSection: true
    }

    QQC2.Label {
        text: i18n("Language filters and favorites are managed in the widget UI")
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }
}

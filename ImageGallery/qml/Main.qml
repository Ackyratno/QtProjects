import QtQuick
import QtQuick.Window
import QtQuick.Controls
import "pages"

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("Image Gallery")
    
    // Временно убрали Style.backgroundColor, чтобы избежать ошибки undefined
    color: "#121212"

    GalleryPage {
        anchors.fill: parent
    }
}

import QtQuick
import QtQuick.Controls
import NotesApp

Button {
    id: control

    property color normalColor: Theme.primaryColor
    property color hoverColor: Theme.primaryHoverColor
    property color pressedColor: Theme.primaryHoverColor
    property color textColor: Theme.textPrimary
    property int borderRadius: Theme.radiusMd

    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeBody
    font.bold: true

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        radius: control.borderRadius
        color: control.down ? control.pressedColor : (control.hovered ? control.hoverColor : control.normalColor)

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: (mouse) => mouse.accepted = false
    }
}

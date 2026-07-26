import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    width: ListView.view ? ListView.view.width : 200
    height: 60
    radius: 8
    
   
    color: mainWindow.surfaceColor
    border.color: mainWindow.borderColor
    border.width: 1

    Behavior on color { ColorAnimation { duration: 300 } }
    Behavior on border.color { ColorAnimation { duration: 300 } }

    property string text: ""
    property bool completed: false

    signal removeClicked()
    signal toggled()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

        CheckBox {
            checked: root.completed
            onClicked: root.toggled()
        }

        Label {
            text: root.text
            Layout.fillWidth: true
            font.strikeout: root.completed
            color: mainWindow.textColor
            font.pixelSize: 16
            elide: Label.ElideRight
            

            opacity: root.completed ? 0.5 : 1.0
            
            Behavior on color { ColorAnimation { duration: 300 } }
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }

        Button {
            text: "❌"
            onClicked: root.removeClicked()
            flat: true
            font.pixelSize: 14
        }
    }
}

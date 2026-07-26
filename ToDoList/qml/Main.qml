import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"
import com.mycompany.todo 1.0

ApplicationWindow {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("To-Do List")
    
    property bool isLight: themeSwitch.checked
    
    // Единая палитра для всего приложения
    property color bgColor: isLight ? "#F5F5F5" : "#121212"
    property color surfaceColor: isLight ? "#FFFFFF" : "#1E1E1E"
    property color textColor: isLight ? "#212121" : "#E0E0E0"

    property color accentColor: isLight ? "#007AFF" : "#0A84FF"
    property color borderColor: isLight ? "#E0E0E0" : "#333333"

    color: bgColor


    Behavior on color { ColorAnimation { duration: 300 } }

    ToDoModel {
        id: todoModel
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Шапка со счетчиком и переключателем
        RowLayout {
            Layout.fillWidth: true
            
            Label {
                text: "Всего задач: " + todoModel.rowCount()
                font.pixelSize: 16
                color: mainWindow.textColor
                opacity: 0.7
                Layout.fillWidth: true
                Behavior on color { ColorAnimation { duration: 300 } }
            }

            Image {
                source: mainWindow.isLight ? "icons/moon.svg" : "icons/sun.svg"
                sourceSize.width: 24
                sourceSize.height: 24
            }

            Switch {
                id: themeSwitch
                checked: true 
            }
        }

       
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            TextField {
                id: inputField
                placeholderText: qsTr("Что нужно сделать?")
                placeholderTextColor: mainWindow.isLight ? "#9e9e9e" : "#757575"
                color: mainWindow.textColor
                Layout.fillWidth: true
                font.pixelSize: 16
                onAccepted: addButton.clicked()
                
                background: Rectangle {
                    radius: 8
                    color: mainWindow.surfaceColor
                    border.color: mainWindow.borderColor
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 300 } }
                    Behavior on border.color { ColorAnimation { duration: 300 } }
                }
            }

            Button {
                id: addButton
                text: qsTr("Добавить")
                palette.buttonText: "#FFFFFF"
                font.bold: true
                onClicked: {
                    if (inputField.text.trim() !== "") {
                        todoModel.addTask(inputField.text.trim())
                        inputField.text = ""
                    }
                }
                background: Rectangle {
                    radius: 8
                    color: mainWindow.accentColor
                    Behavior on color { ColorAnimation { duration: 300 } }
                }
            }
        }

       
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

           
            Label {
                text: "Нет задач. Добавьте новую!"
                color: mainWindow.textColor
                opacity: 0.5
                font.pixelSize: 18
                anchors.centerIn: parent
                visible: todoModel.rowCount() === 0
                Behavior on color { ColorAnimation { duration: 300 } }
            }

            ListView {
                id: listView
                anchors.fill: parent
                model: todoModel
                clip: true
                spacing: 8

               
                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 300 }
                    NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 300 }
                }
                remove: Transition {
                    NumberAnimation { property: "opacity"; to: 0; duration: 300 }
                    NumberAnimation { property: "scale"; to: 0.9; duration: 300 }
                }
                displaced: Transition {
                    NumberAnimation { properties: "x,y"; duration: 300; easing.type: Easing.OutQuad }
                }

                delegate: TodoDelegate {
                    text: model.description
                    completed: model.done
                    onToggled: model.done = !model.done
                    onRemoveClicked: todoModel.removeItem(index)
                }
            }
        }
    }
}

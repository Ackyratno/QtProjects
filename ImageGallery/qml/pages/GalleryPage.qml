import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../components"

Rectangle {
    color: "#121212"

    // Верхняя панель (Header)
    Rectangle {
        id: header
        width: parent.width
        height: 50
        color: "#1E1E1E"
        z: 2 // чтобы быть поверх сетки

        Button {
            id: selectFolderBtn
            text: "Выбрать папку"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16
            
            // Чтобы курсор становился "рукой" при наведении
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton // Пропускаем клик к самой кнопке Button
            }
            
            // Кастомный дизайн кнопки (Premium UI)
            contentItem: Text {
                text: selectFolderBtn.text
                color: "white"
                font.bold: true
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                implicitWidth: 150
                implicitHeight: 36
                // Цвет индиго с изменением при наведении
                color: selectFolderBtn.hovered ? "#4F46E5" : "#6366F1"
                radius: 18 // Закругленные края (pill shape)
                
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            
            onClicked: folderDialog.open()
        }
    }

    // Диалог выбора папки
    FolderDialog {
        id: folderDialog
        title: "Выберите папку с картинками"
        onAccepted: {
            // Передаем URL выбранной папки в твой C++ метод
            // currentFolder имеет тип url (например, "file:///home/user/Images")
            // Мы конвертируем его в строку и отрезаем "file://" если нужно будет в C++
            gallerymodel.setDirectory(currentFolder.toString())
        }
    }

    GridView {
        id: grid
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 16
        
        property int columns: Math.max(1, Math.floor(width / 160))
        cellWidth: width / columns
        cellHeight: cellWidth
        
        model: gallerymodel 
        
        delegate: ImageCardDelegate {
            imagePath: model.path
            imageName: model.name
            
            // Ловим клик из делегата и открываем фуллскрин
            onClicked: (path) => {
                fullScreenViewer.imageSource = path
                fullScreenViewer.open()
            }
        }

        add: Transition {
            NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 300 }
            NumberAnimation { properties: "scale"; from: 0.8; to: 1; duration: 300 }
        }
    }

    // Просмотр на весь экран
    Popup {
        id: fullScreenViewer
        width: parent.width
        height: parent.height
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        property string imageSource: ""

        // Магия плавного открытия (скейл + прозрачность)
        enter: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 300; easing.type: Easing.OutQuart }
                NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 300; easing.type: Easing.OutBack }
            }
        }
        
        // Магия плавного закрытия
        exit: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 250; easing.type: Easing.InQuart }
                NumberAnimation { property: "scale"; from: 1.0; to: 0.9; duration: 250; easing.type: Easing.InQuart }
            }
        }

        background: Rectangle {
            color: "#E6000000" // полупрозрачный черный (90%)
        }

        Image {
            anchors.fill: parent
            anchors.margins: 20
            source: fullScreenViewer.imageSource
            fillMode: Image.PreserveAspectFit
            asynchronous: true
        }

        // Красивая кнопка закрытия
        Button {
            id: closeBtn
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20
            text: "Закрыть"

            // Чтобы курсор становился "рукой" при наведении
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton // Пропускаем клик к самой кнопке Button
            }
            
            contentItem: Text {
                text: closeBtn.text
                color: "white"
                font.bold: true
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 36
                // Красный цвет с эффектом наведения
                color: closeBtn.hovered ? "#DC2626" : "#EF4444" 
                radius: 18
                
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            
            onClicked: fullScreenViewer.close()
        }
    }
}

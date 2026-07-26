import QtQuick
import QtQuick.Controls

Item {
    id: root
    // Размер берем от ячейки GridView, чтобы карточка растягивалась вместе с ней
    width: GridView.view.cellWidth
    height: GridView.view.cellHeight

    property string imagePath: ""
    property string imageName: ""

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: "#1E1E1E"
        radius: 8
        clip: true

        // Само изображение с ленивой загрузкой
        Image {
            id: img
            anchors.fill: parent
            source: root.imagePath
            fillMode: Image.PreserveAspectCrop
            
            // МАГИЯ ЛЕНИВОЙ ЗАГРУЗКИ: картинка читается с диска в фоне
            asynchronous: true 
            
            // Плавное появление картинки после её загрузки
            opacity: status === Image.Ready ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 250 } }
        }

        // Индикатор загрузки (показывает спиннер, пока тяжелое фото грузится в фоне)
        BusyIndicator {
            anchors.centerIn: parent
            running: img.status === Image.Loading
        }

        // Текст поверх картинки (имя файла)
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 30
            color: "#80000000" // Полупрозрачный черный
            
            Text {
                anchors.centerIn: parent
                text: root.imageName
                color: "white"
                font.pixelSize: 12
                elide: Text.ElideRight
                width: parent.width - 8
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}

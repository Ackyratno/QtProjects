import QtQuick
import QtQuick.Controls

Item {
    id: root
    // Размер берем от ячейки GridView, чтобы карточка растягивалась вместе с ней
    width: GridView.view.cellWidth
    height: GridView.view.cellHeight

    property string imagePath: ""
    property string imageName: ""

    // Сигнал, который мы отправим при клике на карточку
    signal clicked(string path)

    Rectangle {
        id: cardRect
        anchors.fill: parent
        anchors.margins: 4
        
        // Подсветка фона при наведении
        color: mouseArea.containsMouse ? "#2A2A2A" : "#1E1E1E"
        radius: 8
        clip: true
        
        // Анимация увеличения карточки при наведении
        scale: mouseArea.containsMouse ? 1.05 : 1.0
        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }
        Behavior on color {
            ColorAnimation { duration: 150 }
        }

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

        // Кликабельная зона
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.clicked(root.imagePath)
            
            // Чтобы курсор менялся на "руку" при наведении
            cursorShape: Qt.PointingHandCursor
        }
    }
}

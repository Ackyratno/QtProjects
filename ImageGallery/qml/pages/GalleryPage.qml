import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    color: "#121212"

    GridView {
        id: grid
        anchors.fill: parent
        anchors.margins: 16
        
        // Динамический расчет (Адаптивный дизайн)
        // Вычисляем, сколько колонок по 160px влезет, и растягиваем ячейки на оставшееся место
        property int columns: Math.max(1, Math.floor(width / 160))
        cellWidth: width / columns
        cellHeight: cellWidth
        
        // Подключаем модель, которую ты экспортировал из C++ (с маленькой буквы "m", как у тебя в main.cpp)
        model: gallerymodel 
        
        delegate: ImageCardDelegate {
            // Передаем данные из C++ модели (model.path, model.name) в делегат
            imagePath: model.path
            imageName: model.name
        }

        // Плавная анимация при добавлении новых элементов в сетку
        add: Transition {
            NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 300 }
            NumberAnimation { properties: "scale"; from: 0.8; to: 1; duration: 300 }
        }
    }
}

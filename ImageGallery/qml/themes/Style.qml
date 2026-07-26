pragma Singleton
import QtQuick

// МОЯ ЗОНА ОТВЕТСТВЕННОСТИ (QML)
// Назначение: Единая точка для хранения стилей (цвета, отступы, шрифты)

QtObject {
    readonly property color backgroundColor: "#121212"
    readonly property color primaryColor: "#BB86FC"
    readonly property color textColor: "#FFFFFF"
    readonly property color secondaryTextColor: "#B3B3B3"
    
    readonly property int paddingSmall: 8
    readonly property int paddingMedium: 16
    readonly property int paddingLarge: 24
}

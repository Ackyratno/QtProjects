import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    // --- Публичные свойства ---
    property string btnText: ""
    // Тип кнопки задаёт цветовую схему: "digit", "op", "equal", "action"
    property string btnType: "digit"
    // Сигнал клика, который будет ловить родитель
    signal clicked()

    // --- Базовые размеры (переопределяются из GridLayout через Layout.fillWidth) ---
    width: 72
    height: 72
    radius: 20

    // --- Цветовая схема по типу ---
    color: {
        if (btnType === "op")     return "#2c2c3e"
        if (btnType === "equal")  return "#6c63ff"
        if (btnType === "action") return "#1e1e2e"
        return "#1a1a2e"   // digit
    }

    // --- Рамка для «равно» и операций ---
    border.color: {
        if (btnType === "equal")  return "#9d97ff"
        if (btnType === "op")     return "#3d3d5c"
        return "transparent"
    }
    border.width: btnType === "equal" ? 1.5 : (btnType === "op" ? 1 : 0)

    // --- Тень / свечение ---
    layer.enabled: true
    layer.effect: null   // простое решение без ShaderEffect

    // --- Анимации цвета ---
    Behavior on color {
        ColorAnimation { duration: 120 }
    }

    // --- Надпись ---
    Text {
        id: label
        anchors.centerIn: parent
        text: root.btnText
        font.pixelSize: root.btnText.length > 1 ? 22 : 28
        font.weight: Font.Medium
        font.family: "Inter, sans-serif"
        color: {
            if (btnType === "equal")  return "#ffffff"
            if (btnType === "op")     return "#b0aaff"
            if (btnType === "action") return "#8888aa"
            return "#e0e0f0"   // digit
        }

        Behavior on font.pixelSize {
            NumberAnimation { duration: 80 }
        }
    }

    // --- MouseArea ---
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            root.clicked()
        }
    }

    // --- Hover: подсветка ---
    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse && !mouseArea.pressed
            PropertyChanges {
                target: root
                color: {
                    if (btnType === "op")     return "#3a3a55"
                    if (btnType === "equal")  return "#7d75ff"
                    if (btnType === "action") return "#2a2a40"
                    return "#22223a"
                }
                scale: 1.04
            }
        },
        State {
            name: "pressed"
            when: mouseArea.pressed
            PropertyChanges {
                target: root
                color: {
                    if (btnType === "op")     return "#232335"
                    if (btnType === "equal")  return "#5a52dd"
                    if (btnType === "action") return "#14142a"
                    return "#111126"
                }
                scale: 0.95
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { properties: "scale"; duration: 100; easing.type: Easing.OutQuad }
            ColorAnimation  { duration: 100 }
        }
    ]
}
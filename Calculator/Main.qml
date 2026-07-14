import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: root
    width: 340
    height: 580
    minimumWidth: 340
    maximumWidth: 340
    minimumHeight: 580
    maximumHeight: 580
    visible: true
    title: qsTr("Calculator")
    color: '#190d1a'


    // ─── DISPLAY ───────────────────────────────────────────────────────────────
    Rectangle {
        id: displayArea
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 140
        color: "transparent"

        Text {
            id: operatorDisplay
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 20
                leftMargin: 24
            }
            text: backend.currentOperand
            font.pixelSize: 28
            font.family: "Inter, sans-serif"
            color: "#a78bfa"
            
            Behavior on text {
                SequentialAnimation {
                    NumberAnimation { target: operatorDisplay; property: "opacity"; to: 0; duration: 60 }
                    PropertyAction  { target: operatorDisplay; property: "text" }
                    NumberAnimation { target: operatorDisplay; property: "opacity"; to: 1; duration: 100 }
                }
            }
        }

        // Градиентная линия снизу
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.3; color: "#6c63ff" }
                GradientStop { position: 0.7; color: "#a78bfa" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Column {
            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin: 24
                bottomMargin: 16
            }
            spacing: 4

            // Строка предыдущей операции (подсказка) — будет заполняться из C++
            Text {
                id: subDisplay
                anchors.right: parent.right
                text: ""
                font.pixelSize: 16
                font.family: "Inter, sans-serif"
                color: "#5a5a8a"

                Behavior on text {
                    SequentialAnimation {
                        NumberAnimation { target: subDisplay; property: "opacity"; to: 0; duration: 80 }
                        PropertyAction  { target: subDisplay; property: "text" }
                        NumberAnimation { target: subDisplay; property: "opacity"; to: 1; duration: 80 }
                    }
                }
            }

            // Главный дисплей — будет привязан к backend.displayValue в Этапе 3
            Text {
                id: mainDisplay
                anchors.right: parent.right
                text: backend.displayValue
                font.pixelSize: 52
                font.weight: Font.Light
                font.family: "Inter, sans-serif"
                color: "#e8e8ff"

                Behavior on text {
                    SequentialAnimation {
                        NumberAnimation { target: mainDisplay; property: "opacity"; to: 0.4; duration: 60 }
                        PropertyAction  { target: mainDisplay; property: "text" }
                        NumberAnimation { target: mainDisplay; property: "opacity"; to: 1.0; duration: 100 }
                    }
                }

                Behavior on font.pixelSize {
                    NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
                }
            }
        }
    }

    // ─── КНОПОЧНАЯ СЕТКА ───────────────────────────────────────────────────────
    GridLayout {
        id: keypad
        columns: 4
        rowSpacing: 10
        columnSpacing: 10
        anchors {
            top: displayArea.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 16
            topMargin: 20
        }

        // ─── Строка 1 ───────────────────────────────
        CalcButton {
            btnText: "C"
            btnType: "action"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: backend.clearAll()
        }
        CalcButton {
            btnText: "CE"
            btnType: "action"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: backend.clearLast()
        }
        CalcButton {
            btnText: "+/-"
            btnType: "action"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: backend.changeSign()
        }
        CalcButton {
            btnText: "÷"
            btnType: "op"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: backend.operatorPressed(btnText)
        }

        // ─── Строка 2 ───────────────────────────────
        CalcButton { btnText: "7"; btnType: "digit"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: backend.digitPressed(btnText) }
        CalcButton { btnText: "8"; btnType: "digit"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: backend.digitPressed(btnText) }
        CalcButton { btnText: "9"; btnType: "digit"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: backend.digitPressed(btnText) }
        CalcButton {
            btnText: "×"
            btnType: "op"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: backend.operatorPressed(btnText)
        }

        // ─── Строка 3 ───────────────────────────────
        CalcButton { btnText: "4"; btnType: "digit"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: backend.digitPressed(btnText) }
        CalcButton { btnText: "5"; btnType: "digit"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: backend.digitPressed(btnText) }
        CalcButton { btnText: "6"; btnType: "digit"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: backend.digitPressed(btnText) }
        CalcButton {
            btnText: "−"
            btnType: "op"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: backend.operatorPressed(btnText)
        }

        // ─── Строка 4 ───────────────────────────────
        CalcButton { btnText: "1"; btnType: "digit"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: backend.digitPressed(btnText) }
        CalcButton { btnText: "2"; btnType: "digit"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: backend.digitPressed(btnText) }
        CalcButton { btnText: "3"; btnType: "digit"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: backend.digitPressed(btnText) }
        CalcButton {
            btnText: "+"
            btnType: "op"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: backend.operatorPressed(btnText)
        }

        // ─── Строка 5 ───────────────────────────────
        CalcButton {
            btnText: "0"
            btnType: "digit"
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: backend.digitPressed(btnText)
        }
        CalcButton {
            btnText: "."
            btnType: "digit"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: backend.dotPressed()
        }
        CalcButton {
            btnText: "="
            btnType: "equal"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: backend.equalPressed();
        }
    }
}

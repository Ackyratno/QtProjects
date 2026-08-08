import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NotesApp

ApplicationWindow {
    id: root
    width: 900
    height: 600
    minimumWidth: 600
    minimumHeight: 400
    visible: true
    title: qsTr("Notes App")

    color: Theme.backgroundColor

    // Главный контейнер макета
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacingLg
        spacing: Theme.spacingMd

        // Верхняя панель (Header)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: Theme.surfaceHeaderColor
            radius: Theme.radiusMd

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacingMd
                anchors.rightMargin: Theme.spacingMd

                Text {
                    text: "📝 Notes App"
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeHeading
                    font.bold: true
                }

                Item { Layout.fillWidth: true } // Заполнитель

                Rectangle {
                    width: 110
                    height: 36
                    color: statusMouseArea.containsMouse ? Theme.primaryHoverColor : Theme.primaryColor
                    radius: Theme.radiusSm

                    Text {
                        anchors.centerIn: parent
                        text: "Этап 1: Ready"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSm
                        font.bold: true
                    }

                    MouseArea {
                        id: statusMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }

        // Центральная область (Приветственный экран / Базовый каркас)
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.surfaceColor
            radius: Theme.radiusLg
            border.color: Theme.borderColor
            border.width: 1

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Theme.spacingMd

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "🚀 Базовый каркас приложения создан!"
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeTitle
                    font.bold: true
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Этап 1 успешно инициализирован: CMake + Qt 6 Quick / QML + Theme System"
                    color: Theme.textSecondary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeBody
                }

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 320
                    Layout.preferredHeight: 48
                    color: Theme.cardBackgroundColor
                    radius: Theme.radiusMd
                    border.color: Theme.borderColor
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Следующий шаг: Этап 2 (Note & INoteRepository)"
                        color: Theme.accentColor
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSm
                        font.bold: true
                    }
                }
            }
        }
    }
}

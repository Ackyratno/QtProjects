import QtQuick
import QtQuick.Layouts
import NotesApp

Rectangle {
    id: delegateRoot

    width: ListView.view ? ListView.view.width : 300
    height: 120
    color: mouseArea.containsMouse ? Theme.cardHoverColor : Theme.cardBackgroundColor
    radius: Theme.radiusMd
    border.color: mouseArea.containsMouse ? Theme.borderFocusColor : Theme.borderColor
    border.width: 1

    signal editRequested(var noteId, var noteTitle, var noteContent)
    signal deleteRequested(var noteId, var noteTitle)

    Behavior on color { ColorAnimation { duration: 180 } }
    Behavior on border.color { ColorAnimation { duration: 180 } }

    // Тонкая левая полоска — акцент цвета
    Rectangle {
        width: 4
        height: parent.height - 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 0
        radius: 2
        color: Theme.primaryColor
        opacity: mouseArea.containsMouse ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 180 } }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacingMd
        anchors.rightMargin: Theme.spacingSm
        anchors.topMargin: Theme.spacingMd
        anchors.bottomMargin: Theme.spacingMd
        spacing: Theme.spacingMd

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.spacingXs

            Text {
                text: model.title
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSubheading
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: model.content || "Без описания"
                color: model.content ? Theme.textSecondary : Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeBody
                font.italic: !model.content
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Text {
                text: model.createdAt ? "🕐 " + model.createdAt : ""
                color: Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSm
            }
        }

        // Кнопки действий (появляются при наведении)
        ColumnLayout {
            spacing: Theme.spacingXs
            opacity: mouseArea.containsMouse ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 180 } }

            // Кнопка редактирования
            Rectangle {
                width: 32
                height: 32
                radius: Theme.radiusSm
                color: editMouse.containsMouse ? Theme.primaryColor : Theme.cardHoverColor
                Layout.alignment: Qt.AlignTop

                Text {
                    anchors.centerIn: parent
                    text: "✏️"
                    font.pixelSize: 14
                }

                MouseArea {
                    id: editMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: delegateRoot.editRequested(model.id, model.title, model.content)
                }

                Behavior on color { ColorAnimation { duration: 150 } }
            }

            // Кнопка удаления
            Rectangle {
                id: deleteBtn
                width: 32
                height: 32
                radius: Theme.radiusSm
                color: deleteMouse.containsMouse ? Theme.dangerColor : Theme.cardHoverColor
                Layout.alignment: Qt.AlignTop

                Text {
                    anchors.centerIn: parent
                    text: "🗑"
                    font.pixelSize: 14
                }

                MouseArea {
                    id: deleteMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: delegateRoot.deleteRequested(model.id, model.title)
                }

                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        z: -1
        onClicked: delegateRoot.editRequested(model.id, model.title, model.content)
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NotesApp
import NotesApp

Dialog {
    id: dialog

    title: noteId > 0 ? "Редактировать заметку" : "Новая заметка"
    modal: true
    focus: true
    anchors.centerIn: parent
    width: 480
    height: 400

    property var noteId: 0
    property alias titleText: titleInput.text
    property alias contentText: contentInput.text

    signal saved(var id, string title, string content)

    background: Rectangle {
        color: Theme.surfaceColor
        radius: Theme.radiusLg
        border.color: Theme.borderColor
        border.width: 1
    }

    header: Rectangle {
        color: Theme.surfaceHeaderColor
        height: 50
        radius: Theme.radiusLg

        Text {
            anchors.centerIn: parent
            text: dialog.title
            color: Theme.textPrimary
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSubheading
            font.bold: true
        }
    }

    contentItem: ColumnLayout {
        spacing: Theme.spacingMd
        anchors.margins: Theme.spacingMd

        TextField {
            id: titleInput
            placeholderText: "Заголовок заметки..."
            placeholderTextColor: Theme.textMuted
            color: Theme.textPrimary
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeBody
            font.bold: true
            Layout.fillWidth: true

            background: Rectangle {
                color: Theme.cardBackgroundColor
                radius: Theme.radiusSm
                border.color: titleInput.activeFocus ? Theme.borderFocusColor : Theme.borderColor
                border.width: 1
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            TextArea {
                id: contentInput
                placeholderText: "Введите текст заметки..."
                placeholderTextColor: Theme.textMuted
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeBody
                wrapMode: TextEdit.Wrap
                selectByMouse: true

                background: Rectangle {
                    color: Theme.cardBackgroundColor
                    radius: Theme.radiusSm
                    border.color: contentInput.activeFocus ? Theme.borderFocusColor : Theme.borderColor
                    border.width: 1
                }
            }
        }
    }

    footer: RowLayout {
        spacing: Theme.spacingMd
        anchors.margins: Theme.spacingMd

        Item { Layout.fillWidth: true }

        CustomButton {
            text: "Отмена"
            normalColor: Theme.cardBackgroundColor
            hoverColor: Theme.cardHoverColor
            onClicked: dialog.reject()
        }

        CustomButton {
            text: "Сохранить"
            normalColor: Theme.primaryColor
            hoverColor: Theme.primaryHoverColor
            onClicked: {
                if (titleInput.text.trim().length > 0) {
                    dialog.saved(dialog.noteId, titleInput.text.trim(), contentInput.text.trim())
                    dialog.accept()
                }
            }
        }
    }

    function openForAdd() {
        dialog.noteId = 0
        dialog.titleText = ""
        dialog.contentText = ""
        dialog.open()
    }

    function openForEdit(id, title, content) {
        dialog.noteId = id
        dialog.titleText = title
        dialog.contentText = content
        dialog.open()
    }
}


import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NotesApp

ApplicationWindow {
    id: root
    width: 900
    height: 650
    minimumWidth: 620
    minimumHeight: 480
    visible: true
    title: qsTr("Notes App")

    color: Theme.backgroundColor



    // ── Страница списка заметок ──────────────────────────────────
    NoteListPage {
        anchors.fill: parent
        anchors.margins: Theme.spacingLg

        onAddRequested: editorDialog.openForAdd()
        onEditRequested: (id, title, content) => editorDialog.openForEdit(id, title, content)
        onDeleteRequested: (id, title) => {
            deleteConfirmDialog.targetId = id
            deleteConfirmDialog.targetTitle = title
            deleteConfirmDialog.open()
        }
    }

    // ── Диалог создания / редактирования ────────────────────────
    NoteEditorDialog {
        id: editorDialog

        onSaved: (id, title, content) => {
            if (id > 0) {
                noteModel.updateNote(id, title, content)
            } else {
                noteModel.addNote(title, content)
            }
        }
    }

    // ── Попап подтверждения удаления ─────────────────────────────
    Dialog {
        id: deleteConfirmDialog
        modal: true
        anchors.centerIn: parent
        width: 400
        padding: 0

        property var targetId: 0
        property string targetTitle: ""

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200; easing.type: Easing.OutCubic }
            NumberAnimation { property: "scale"; from: 0.92; to: 1; duration: 200; easing.type: Easing.OutBack }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 150; easing.type: Easing.InCubic }
        }

        background: Rectangle {
            color: Theme.surfaceColor
            radius: Theme.radiusLg
            border.color: Theme.dangerColor
            border.width: 1

            // Тень
            layer.enabled: true
            layer.effect: null
        }

        contentItem: ColumnLayout {
            spacing: 0

            // Заголовок
            Rectangle {
                Layout.fillWidth: true
                height: 52
                color: Theme.surfaceHeaderColor
                radius: Theme.radiusLg

                // Нижние углы не скруглять
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.radius
                    color: parent.color
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacingMd
                    spacing: Theme.spacingSm

                    Text { text: "🗑️"; font.pixelSize: 18 }

                    Text {
                        text: "Удаление заметки"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSubheading
                        font.bold: true
                    }
                }
            }

            // Тело
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingMd
                Layout.margins: Theme.spacingLg

                Text {
                    text: "Вы собираетесь удалить заметку:"
                    color: Theme.textSecondary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeBody
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: quoteText.implicitHeight + Theme.spacingMd * 2
                    color: Theme.cardBackgroundColor
                    radius: Theme.radiusSm
                    border.color: Theme.dangerColor
                    border.width: 1

                    Text {
                        id: quoteText
                        anchors {
                            left: parent.left; right: parent.right
                            verticalCenter: parent.verticalCenter
                            margins: Theme.spacingMd
                        }
                        text: "\"" + deleteConfirmDialog.targetTitle + "\""
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeBody
                        font.bold: true
                        wrapMode: Text.Wrap
                    }
                }

                Text {
                    text: "Это действие нельзя отменить."
                    color: Theme.dangerColor
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSm
                    Layout.fillWidth: true
                }

                // Кнопки
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingSm

                    Item { Layout.fillWidth: true }

                    CustomButton {
                        text: "Отмена"
                        normalColor: Theme.cardBackgroundColor
                        hoverColor: Theme.cardHoverColor
                        onClicked: deleteConfirmDialog.reject()
                    }

                    CustomButton {
                        text: "🗑 Удалить"
                        normalColor: Theme.dangerColor
                        hoverColor: Theme.dangerHoverColor
                        onClicked: {
                            noteModel.deleteNote(deleteConfirmDialog.targetId)
                            deleteConfirmDialog.accept()
                        }
                    }
                }

                Item { height: Theme.spacingSm }
            }
        }
    }
}

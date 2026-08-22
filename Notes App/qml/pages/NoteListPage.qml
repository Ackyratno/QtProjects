import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NotesApp

Item {
    id: pageRoot

    signal addRequested()
    signal editRequested(var id, var title, var content)
    signal deleteRequested(var id, var title)

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.spacingMd

        // ── Верхняя панель ──────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            color: Theme.surfaceHeaderColor
            radius: Theme.radiusMd

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacingMd
                anchors.rightMargin: Theme.spacingMd
                spacing: Theme.spacingMd

                // Иконка + заголовок
                RowLayout {
                    spacing: Theme.spacingSm

                    Text {
                        text: "📝"
                        font.pixelSize: 22
                    }

                    ColumnLayout {
                        spacing: 0
                        Text {
                            text: "Мои заметки"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSubheading
                            font.bold: true
                        }
                        Text {
                            text: noteListView.count + " " + noteCountLabel(noteListView.count)
                            color: Theme.textMuted
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSm
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                CustomButton {
                    text: "+ Новая заметка"
                    onClicked: pageRoot.addRequested()
                }
            }
        }

        // ── Строка поиска ────────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            color: Theme.cardBackgroundColor
            radius: Theme.radiusMd
            border.color: searchField.activeFocus ? Theme.borderFocusColor : Theme.borderColor
            border.width: 1

            Behavior on border.color { ColorAnimation { duration: 150 } }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacingMd
                anchors.rightMargin: Theme.spacingSm
                spacing: Theme.spacingSm

                Text {
                    text: "🔍"
                    font.pixelSize: 16
                    color: Theme.textMuted
                }

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: "Поиск по заметкам..."
                    placeholderTextColor: Theme.textMuted
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeBody
                    background: Item {}
                    leftPadding: 0
                }

                // Кнопка очистки поиска
                Rectangle {
                    width: 24
                    height: 24
                    radius: Theme.radiusRound
                    color: clearMouse.containsMouse ? Theme.cardHoverColor : "transparent"
                    visible: searchField.text.length > 0

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 12
                        color: Theme.textMuted
                    }

                    MouseArea {
                        id: clearMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: searchField.text = ""
                    }

                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }
        }

        // ── Список заметок ───────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.surfaceColor
            radius: Theme.radiusLg
            border.color: Theme.borderColor
            border.width: 1
            clip: true

            ListView {
                id: noteListView
                anchors.fill: parent
                anchors.margins: Theme.spacingMd
                spacing: Theme.spacingMd
                model: noteModel
                clip: true

                // Плавная прокрутка
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    contentItem: Rectangle {
                        implicitWidth: 4
                        radius: 2
                        color: Theme.borderFocusColor
                        opacity: 0.5
                    }
                }

                delegate: NoteCardDelegate {
                    visible: searchField.text.length === 0 ||
                             model.title.toLowerCase().includes(searchField.text.toLowerCase()) ||
                             model.content.toLowerCase().includes(searchField.text.toLowerCase())
                    height: visible ? 120 : 0

                    onEditRequested: (id, title, content) => pageRoot.editRequested(id, title, content)
                    onDeleteRequested: (id, title) => pageRoot.deleteRequested(id, title)
                }

                // ── Анимации ────────────────────────────────────
                add: Transition {
                    SequentialAnimation {
                        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300; easing.type: Easing.OutCubic }
                    }
                    NumberAnimation { property: "scale"; from: 0.92; to: 1; duration: 300; easing.type: Easing.OutBack }
                }

                remove: Transition {
                    ParallelAnimation {
                        NumberAnimation { property: "opacity"; to: 0; duration: 200; easing.type: Easing.InCubic }
                        NumberAnimation { property: "scale"; to: 0.88; duration: 200; easing.type: Easing.InCubic }
                    }
                }

                displaced: Transition {
                    NumberAnimation { properties: "x,y"; duration: 280; easing.type: Easing.OutQuad }
                }

                addDisplaced: Transition {
                    NumberAnimation { properties: "x,y"; duration: 280; easing.type: Easing.OutQuad }
                }

                removeDisplaced: Transition {
                    NumberAnimation { properties: "x,y"; duration: 280; easing.type: Easing.OutQuad }
                }

                // ── Пустое состояние ─────────────────────────────
                Item {
                    anchors.centerIn: parent
                    width: parent.width
                    visible: noteListView.count === 0

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Theme.spacingSm

                        Text {
                            text: searchField.text.length > 0 ? "🔍" : "📌"
                            font.pixelSize: 52
                            Layout.alignment: Qt.AlignHCenter

                            SequentialAnimation on font.pixelSize {
                                running: noteListView.count === 0
                                loops: Animation.Infinite
                                NumberAnimation { to: 58; duration: 1200; easing.type: Easing.InOutSine }
                                NumberAnimation { to: 52; duration: 1200; easing.type: Easing.InOutSine }
                            }
                        }

                        Text {
                            text: searchField.text.length > 0
                                  ? "Ничего не найдено"
                                  : "Список заметок пуст"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSubheading
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: searchField.text.length > 0
                                  ? "Попробуйте изменить запрос"
                                  : "Нажмите '+ Новая заметка', чтобы создать первую запись"
                            color: Theme.textMuted
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeBody
                            Layout.alignment: Qt.AlignHCenter
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }
    }

    // Вспомогательная функция: склонение слова "заметка"
    function noteCountLabel(n) {
        if (n % 100 >= 11 && n % 100 <= 19) return "заметок"
        var r = n % 10
        if (r === 1) return "заметка"
        if (r >= 2 && r <= 4) return "заметки"
        return "заметок"
    }
}

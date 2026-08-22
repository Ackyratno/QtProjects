import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PasswordManager
import "themes"

ApplicationWindow {
    id: window
    width: 1024
    height: 680
    minimumWidth: 800
    minimumHeight: 560
    visible: true
    title: qsTr("CipherVault — Password Manager")
    color: Theme.background

    // Background Gradient Glow Effect
    Rectangle {
        anchors.fill: parent
        color: "transparent"

        // Subtle radial ambient lighting in top-left
        Rectangle {
            width: 500
            height: 500
            radius: 250
            x: -150
            y: -150
            color: Theme.primaryGlow
            opacity: 0.12
        }

        // Ambient lighting in bottom-right
        Rectangle {
            width: 400
            height: 400
            radius: 200
            x: window.width - 250
            y: window.height - 250
            color: "#052E16"
            opacity: 0.2
        }
    }

    // Main Container
    Item {
        anchors.fill: parent

        // Top Navigation / Header Bar
        Rectangle {
            id: headerBar
            width: parent.width
            height: 64
            color: Theme.surface
            border.color: Theme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacingXl
                anchors.rightMargin: Theme.spacingXl
                spacing: Theme.spacingMd

                // App Shield Icon / Logo
                Rectangle {
                    width: 38
                    height: 38
                    radius: Theme.radiusMd
                    color: Theme.surfaceElevated
                    border.color: Theme.primary
                    border.width: 1.5

                    Text {
                        anchors.centerIn: parent
                        text: "🛡️"
                        font.pixelSize: 18
                    }
                }

                // App Title & Tagline
                ColumnLayout {
                    spacing: 2
                    Text {
                        text: "CipherVault"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeLg
                        font.bold: true
                    }
                    Text {
                        text: "AES-256 Encrypted Secure Vault"
                        color: Theme.textMuted
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeXs
                    }
                }

                Item { Layout.fillWidth: true }

                // Security Status Badge
                Rectangle {
                    height: 30
                    implicitWidth: statusRow.width + Theme.spacingLg * 2
                    radius: Theme.radiusFull
                    color: Qt.rgba(16/255, 185/255, 129/255, 0.12)
                    border.color: Qt.rgba(16/255, 185/255, 129/255, 0.3)
                    border.width: 1

                    RowLayout {
                        id: statusRow
                        anchors.centerIn: parent
                        spacing: Theme.spacingSm

                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            color: Theme.accent
                        }

                        Text {
                            text: "Stage 1 Ready — Core Initialized"
                            color: Theme.accent
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeXs
                            font.bold: true
                        }
                    }
                }
            }
        }

        // Main Content Area (Ready for UnlockPage / VaultPage)
        Rectangle {
            anchors.top: headerBar.bottom
            anchors.bottom: footerBar.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Theme.spacingXl
            color: Theme.surface
            radius: Theme.radiusLg
            border.color: Theme.border
            border.width: 1

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Theme.spacingXl
                width: Math.min(parent.width - 64, 580)

                // Central Shield Visual
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 84
                    height: 84
                    radius: 42
                    color: Qt.rgba(59/255, 130/255, 246/255, 0.1)
                    border.color: Qt.rgba(59/255, 130/255, 246/255, 0.3)
                    border.width: 2

                    Text {
                        anchors.centerIn: parent
                        text: "🔐"
                        font.pixelSize: 36
                    }
                }

                // Welcome Info
                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Theme.spacingSm

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Этап 1 успешно запущен!"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeH2
                        font.bold: true
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Qt 6 Quick + OpenSSL + QML Design System готовы к разработке"
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeMd
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                // Architecture Checklist Box
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: checkCol.height + Theme.spacingXl * 2
                    color: Theme.surfaceElevated
                    radius: Theme.radiusMd
                    border.color: Theme.border
                    border.width: 1

                    ColumnLayout {
                        id: checkCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: Theme.spacingLg
                        spacing: Theme.spacingMd

                        Text {
                            text: "Статус модулей каркаса:"
                            color: Theme.textAccent
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSm
                            font.bold: true
                        }

                        RowLayout {
                            spacing: Theme.spacingSm
                            Text { text: "✓"; color: Theme.accent; font.bold: true }
                            Text { text: "CMakeLists.txt (Qt6 Core/Gui/Quick/Qml/Sql + OpenSSL)"; color: Theme.textPrimary; font.pixelSize: Theme.fontSizeSm }
                        }

                        RowLayout {
                            spacing: Theme.spacingSm
                            Text { text: "✓"; color: Theme.accent; font.bold: true }
                            Text { text: "main.cpp (QGuiApplication + QQmlApplicationEngine)"; color: Theme.textPrimary; font.pixelSize: Theme.fontSizeSm }
                        }

                        RowLayout {
                            spacing: Theme.spacingSm
                            Text { text: "✓"; color: Theme.accent; font.bold: true }
                            Text { text: "Theme.qml (Cybersecurity Dark Design System Singleton)"; color: Theme.textPrimary; font.pixelSize: Theme.fontSizeSm }
                        }

                        RowLayout {
                            spacing: Theme.spacingSm
                            Text { text: "⏳"; color: Theme.warning; font.bold: true }
                            Text { text: "Следующий шаг: Этап 2 — CryptoService (AES-256 & PBKDF2)"; color: Theme.textSecondary; font.pixelSize: Theme.fontSizeSm }
                        }
                    }
                }
            }
        }

        // Bottom Footer Bar
        Rectangle {
            id: footerBar
            width: parent.width
            height: 36
            anchors.bottom: parent.bottom
            color: Theme.backgroundAlt
            border.color: Theme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacingXl
                anchors.rightMargin: Theme.spacingXl

                Text {
                    text: "CipherVault v1.0.0 • C++17 / Qt 6.8 / QML"
                    color: Theme.textMuted
                    font.family: Theme.fontFamilyMono
                    font.pixelSize: Theme.fontSizeXs
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "SQLite Database & Crypto Ready"
                    color: Theme.textMuted
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeXs
                }
            }
        }
    }
}

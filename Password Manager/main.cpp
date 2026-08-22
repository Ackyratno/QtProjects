#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QIcon>
#include <QDebug>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("PasswordManager");
    app.setApplicationDisplayName("CipherVault - Password Manager");
    app.setOrganizationName("SecureVault");
    app.setApplicationVersion("1.0.0");

    // Use Basic style to allow full custom QML theme styling
    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    // Load QML module root
    engine.loadFromModule("PasswordManager", "Main");

    if (engine.rootObjects().isEmpty()) {
        qCritical() << "Failed to load QML root object.";
        return -1;
    }

    return app.exec();
}

#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName("NotesAppOrg");
    app.setApplicationName("NotesApp");

    QQmlApplicationEngine engine;

    // Реакция на ошибку создания QML объекта
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
    );

    // Загружаем QML модуль NotesApp и корневой компонент Main
    engine.loadFromModule("NotesApp", "Main");

    return app.exec();
}

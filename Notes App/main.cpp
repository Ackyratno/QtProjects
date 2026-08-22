#include "SqliteNoteRepository.h"
#include "NoteModel.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName("NotesAppOrg");
    app.setApplicationName("NotesApp");

    // Инициализация слоя работы с данными и QML модели
    SqliteRepository repo;
    NoteModel noteModel(&repo);

    QQmlApplicationEngine engine;

    // Передаем C++ модель в QML контекст
    engine.rootContext()->setContextProperty("noteModel", &noteModel);

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


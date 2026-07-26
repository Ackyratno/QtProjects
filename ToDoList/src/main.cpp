#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "todomodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
using namespace Qt::StringLiterals;
    const QUrl url(u"qrc:/ToDoList/qml/Main.qml"_s);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);
                     
    qmlRegisterType<ToDoModel>("com.mycompany.todo", 1, 0, "ToDoModel");
    
    engine.load(url);

    return app.exec();
}

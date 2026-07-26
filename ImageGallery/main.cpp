#include "cpp/models/ImageGalleryModel.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);
  QQmlApplicationEngine engine;

  ImageGalleryModel *model = new ImageGalleryModel();
  engine.rootContext()->setContextProperty("gallerymodel", model);

  const QUrl url(u"qrc:/qt/qml/ImageGallery/qml/Main.qml"_qs);
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
  engine.load(url);

  return app.exec();
}

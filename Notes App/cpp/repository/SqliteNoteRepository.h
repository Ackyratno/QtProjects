#include "INoteRepository.h"
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QStandardPaths>
#include <QDir>
#include <optional>
#include <qlogging.h>
#include <qsqldatabase.h>
#include <qsqlquery.h>
#include <qtypes.h>
#include <vector>

class SqliteRepository : public INoteRepository {
public:
  SqliteRepository() {
    // Определяем путь к папке данных приложения и создаём её если нужно
    QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dataDir);
    QString dbPath = dataDir + "/notes.db";

    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbPath);

    if (!db.open()) {
      qDebug() << "Ошибка открытия БД" << db.lastError().text();
    }

    QSqlQuery query;
    if (!query.exec("CREATE TABLE IF NOT EXISTS note("
                    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                    "title TEXT NOT NULL,"
                    "content TEXT,"
                    "createdAt DATETIME DEFAULT CURRENT_TIMESTAMP)")) {
      qDebug() << "Ошибка создания таблицы" << query.lastError().text();
    }
  }

  ~SqliteRepository() override = default;

  std::vector<Note> getAllNotes() override;
  std::optional<Note> getNoteById(quint64 id) override;
  qint64 addNote(const Note &note) override;
  bool updateNote(const Note &note) override;
  bool deleteNote(quint64 id) override;

private:
  QSqlDatabase db;
};
#include "INoteRepository.h"
#include "SqliteNoteRepository.h"
#include <optional>
#include <qsqlquery.h>
#include <qtypes.h>

std::vector<Note> SqliteRepository::getAllNotes() {
  std::vector<Note> notes;

  QSqlQuery query(
      "SELECT id, title, content, createdAt FROM note ORDER BY id DESC");

  while (query.next()) {
    Note note;
    note.id = query.value(0).toLongLong();
    note.title = query.value(1).toString();
    note.content = query.value(2).toString();
    note.createdAt = query.value(3).toDateTime();

    notes.push_back(note);
  }

  return notes;
}

std::optional<Note> SqliteRepository::getNoteById(quint64 id) {

  QSqlQuery query;
  query.prepare(
      "SELECT id, title, content, createdAt FROM note WHERE id = :id");
  query.bindValue(":id", id);
  if (query.exec() && query.next()) {
    Note note;
    note.id = query.value(0).toLongLong();
    note.title = query.value(1).toString();
    note.content = query.value(2).toString();
    note.createdAt = query.value(3).toDateTime();

    return note;
  }

  return std::nullopt;
}

qint64 SqliteRepository::addNote(const Note &note) {
  QSqlQuery query;
  query.prepare("INSERT INTO note (title, content) VALUES (:title, :content)");
  query.bindValue(":title", note.title);
  query.bindValue(":content", note.content);

  if (query.exec()) {

    return query.lastInsertId().toLongLong();
  }
  return -1;
}

bool SqliteRepository::updateNote(const Note &note) {
  QSqlQuery query;

  query.prepare(
      "UPDATE note SET title = :title, content = :content WHERE id = :id");
  query.bindValue(":title", note.title);
  query.bindValue(":content", note.content);
  query.bindValue(":id", note.id);

  if (query.exec()) {
    return query.numRowsAffected() > 0;
  }
  return false;
}

bool SqliteRepository::deleteNote(quint64 id) {
  QSqlQuery query;
  query.prepare("DELETE FROM note WHERE id = :id");
  query.bindValue(":id", id);

  if (query.exec()) {
    return query.numRowsAffected() > 0;
  }
  return false;
}
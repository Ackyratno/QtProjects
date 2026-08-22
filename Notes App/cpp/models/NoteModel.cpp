#include "NoteModel.h"
#include "INoteRepository.h"
#include "Note.h"
#include <qabstractitemmodel.h>
#include <qhash.h>
#include <qobject.h>
#include <qtypes.h>
#include <qvariant.h>

NoteModel::NoteModel(INoteRepository *repository, QObject *parent)
    : QAbstractListModel(parent), m_repository(repository) {
  loadNotes();
}

int NoteModel::rowCount(const QModelIndex &parent) const {
  if (parent.isValid()) {
    return 0;
  }
  return m_notes.size();
}

QVariant NoteModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() < 0 || index.row() >= m_notes.size()) {
    return QVariant();
  }

  const Note &note = m_notes.at(index.row());

  switch (role) {
  case IdRole:
    return note.id;
  case TitleRole:
    return note.title;
  case ContentRole:
    return note.content;
  case CreatedAtRole:
    return note.createdAt.toString("dd.MM.yyyy HH.mm");
  case UpdatedAtRole:
    return note.updateAt;
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> NoteModel::roleNames() const {
  QHash<int, QByteArray> hash;
  hash[IdRole] = "id";
  hash[TitleRole] = "title";
  hash[ContentRole] = "content";
  hash[CreatedAtRole] = "createdAt";
  hash[UpdatedAtRole] = "updatedAt";

  return hash;
}

void NoteModel::loadNotes() {
  if (!m_repository) {
    return;
  }

  beginResetModel();
  m_notes = m_repository->getAllNotes();
  endResetModel();
}

bool NoteModel::addNote(const QString &title, const QString &content) {
  if (!m_repository) {
    return false;
  }

  Note note;
  note.title = title;
  note.content = content;

  qint64 newId = m_repository->addNote(note);
  if (newId != -1) {
    loadNotes();
    return true;
  }
  return false;
}

bool NoteModel::updateNote(qint64 id, const QString &title,
                           const QString &content) {
  if (!m_repository) {
    return false;
  }

  Note note;
  note.id = id;
  note.title = title;
  note.content = content;

  if (m_repository->updateNote(note)) {
    loadNotes();
    return true;
  }
  return false;
}

bool NoteModel::deleteNote(qint64 id) {
  if (!m_repository) {
    return false;
  }

  if (m_repository->deleteNote(id)) {
    loadNotes();
    return true;
  };
  return false;
}
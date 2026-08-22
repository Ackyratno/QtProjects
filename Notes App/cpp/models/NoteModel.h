#pragma once

#include "INoteRepository.h"
#include "Note.h"
#include <QAbstractListModel>
#include <vector>

class NoteModel : public QAbstractListModel {
  Q_OBJECT

public:
  enum NoteRoles {
    IdRole = Qt::UserRole + 1,
    TitleRole,
    ContentRole,
    CreatedAtRole,
    UpdatedAtRole
  };

  explicit NoteModel(INoteRepository *repository, QObject *parent = nullptr);

  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;
  QHash<int, QByteArray> roleNames() const override;

  Q_INVOKABLE void loadNotes();
  Q_INVOKABLE bool addNote(const QString &title, const QString &content);
  Q_INVOKABLE bool updateNote(qint64 id, const QString &title,
                              const QString &content);
  Q_INVOKABLE bool deleteNote(qint64 id);

private:
  INoteRepository *m_repository{nullptr};
  std::vector<Note> m_notes;
};
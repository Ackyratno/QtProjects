#pragma once
#include "cpp/models/Note.h"
#include <optional>
#include <qtypes.h>
#include <vector>

class INoteRepository {
public:
  virtual ~INoteRepository() = default;

  virtual std::vector<Note> getAllNotes() = 0;
  virtual std::optional<Note> getNoteById() = 0;
  virtual qint64 addNote(const Note &note) = 0;
  virtual bool updateNode(const Note &note) = 0;
  virtual quint64 deleteNode(quint64 id) = 0;
};
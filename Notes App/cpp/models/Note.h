#pragma once
#include <QDateTime>
#include <QString>

struct Note {
  qint64 id{-1};
  QString title;
  QString content;
  QDateTime createdAt;
  QDateTime updateAt;
};
#pragma once
#include <QAbstractListModel>
#include <QDir>
#include <QHash>
#include <QUrl>
#include <qabstractitemmodel.h>
#include <qnamespace.h>
#include <qstringview.h>
#include <qvariant.h>

class ImageGalleryModel : public QAbstractListModel {
  Q_OBJECT

public:
  ImageGalleryModel();
  enum Roles { Name = Qt::UserRole + 1, Path };

  int rowCount(const QModelIndex &parent) const override;
  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

private:
  QList<QFileInfo> m_images;
};

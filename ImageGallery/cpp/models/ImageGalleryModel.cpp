#include "ImageGalleryModel.h"
#include <qfileinfo.h>
#include <qstringview.h>

ImageGalleryModel::ImageGalleryModel() {
  QString path = "/home/muslim/Изображения/ForGallery";
  QDir dir(path);

  dir.setNameFilters(QStringList() << "*.png" << "*.jpeg" << "*.jpg");
  dir.setFilter(QDir::Files | QDir::NoDotAndDotDot);
  m_images = dir.entryInfoList();
}

int ImageGalleryModel::rowCount(const QModelIndex &parent) const {
  return m_images.size();
}

QVariant ImageGalleryModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= m_images.size()) {
    return QVariant();
  }

  const QFileInfo &fileInfo = m_images.at(index.row());

  switch (role) {
  case Name:
    return fileInfo.fileName();

  case Path:
    return QUrl::fromLocalFile(fileInfo.absoluteFilePath());

  default:
    return QVariant();
  }
}

QHash<int, QByteArray> ImageGalleryModel::roleNames() const {
  QHash<int, QByteArray> obj;
  obj[Name] = "name";
  obj[Path] = "path";
  return obj;
}

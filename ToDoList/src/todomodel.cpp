#include "todomodel.h"
#include <qabstractitemmodel.h>
#include <qiodevicebase.h>
#include <qjsonarray.h>
#include <qjsondocument.h>
#include <qjsonobject.h>
#include <qobject.h>
#include <qstringview.h>

ToDoModel::ToDoModel(QObject *parent) : QAbstractListModel(parent) {
  loadFromFile();
};

int ToDoModel::rowCount(const QModelIndex &parent) const {
  if (parent.isValid()) {
    return 0;
  };

  return m_items.size();
};

QVariant ToDoModel::data(const QModelIndex &index, const int role) const {
  if (!index.isValid() || index.row() >= m_items.size()) {
    return QVariant();
  };

  const ToDoItem *item = &m_items[index.row()];

  switch (role) {
  case DescriptionRole:
    return item->description;
  case IsDoneRole:
    return item->isDone;

  default:
    return QVariant();
  }
}

QHash<int, QByteArray> ToDoModel::roleNames() const {
  QHash<int, QByteArray> roles;
  roles[DescriptionRole] = "description";
  roles[IsDoneRole] = "done";

  return roles;
}

void ToDoModel::removeItem(int index) {
  if (index < 0 || index >= m_items.size()) {
    return;
  }

  beginRemoveRows(QModelIndex(), index, index);

  m_items.removeAt(index);
  endRemoveRows();
  saveToFile();
}

void ToDoModel::addTask(const QString &description) {
  beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
  m_items.append({description, false});
  endInsertRows();

  saveToFile();
}

bool ToDoModel::setData(const QModelIndex &index, const QVariant &value,
                        int role) {
  if (!index.isValid() || index.row() >= m_items.size())
    return false;

  if (role == IsDoneRole) {
    m_items[index.row()].isDone = value.toBool();
    emit dataChanged(index, index, {role});
    saveToFile();
    return true;
  }
  return false;
}

Qt::ItemFlags ToDoModel::flags(const QModelIndex &index) const {
  if (!index.isValid())
    return Qt::NoItemFlags;
  return Qt::ItemIsEditable | QAbstractListModel::flags(index);
}

void ToDoModel::saveToFile() {
  QJsonArray arr;

  for (const ToDoItem &item : m_items) {
    QJsonObject obj;
    obj["description"] = item.description;
    obj["isDone"] = item.isDone;

    arr.append(obj);
  }
  QJsonDocument doc(arr);

  QFile file("tasks.json");
  if (!file.open(QIODevice::WriteOnly)) {
    return;
  }
  file.write(doc.toJson());
  file.close();
}

void ToDoModel::loadFromFile() {
  QFile file("tasks.json");

  if (!file.open(QIODeviceBase::ReadOnly)) {
    return;
  }

  QByteArray arr = file.readAll();

  file.close();

  QJsonDocument doc = QJsonDocument::fromJson(arr);

  QJsonArray array = doc.array();

  for (auto item : array) {
    QJsonObject obj = item.toObject();

    QString desc = obj["description"].toString();
    bool isDone = obj["isDone"].toBool();
    m_items.append({desc, isDone});
  }
}
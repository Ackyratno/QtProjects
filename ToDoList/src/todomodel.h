#ifndef TODOMODEL_H
#define TODOMODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QList>
#include <QString>
#include <qabstractitemmodel.h>
#include <qfile.h>
#include <qtmetamacros.h>

struct ToDoItem {
  QString description;
  bool isDone;
};

class ToDoModel : public QAbstractListModel {
  Q_OBJECT

public:
  explicit ToDoModel(QObject *parent = nullptr);

  int rowCount(const QModelIndex &parent) const override;

  QVariant data(const QModelIndex &index,
                const int role = Qt::DisplayRole) const override;

  QHash<int, QByteArray> roleNames() const override;

  bool setData(const QModelIndex &index, const QVariant &value,
               int role = Qt::EditRole) override;
  Qt::ItemFlags flags(const QModelIndex &index) const override;

  enum ToDoRoles { DescriptionRole = Qt::UserRole + 1, IsDoneRole };

  Q_INVOKABLE void removeItem(int index);
  Q_INVOKABLE void addTask(const QString &description);

  void saveToFile();
  void loadFromFile();

private:
  QList<ToDoItem> m_items;
};

#endif // TODOMODEL_H

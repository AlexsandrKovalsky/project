#ifndef TASKMODEL_H
#define TASKMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include "task.h"

class TasksModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum TaskRoles{
        Id = 0,
        Description = 1,
        Completed = 2,
        Importance = 3,
        Date = 4
    };
    explicit TasksModel();
    Q_INVOKABLE Task* getTask(int index);
    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    void append(Task* task);
    void clear();
    QHash<int, QByteArray> roleNames() const override;

signals:

private:
    QList<Task*> m_tasks;
};

#endif // TASKMODEL_H

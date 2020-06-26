#include "taskmodel.h"

TasksModel::TasksModel()
{

}

Task *TasksModel::getTask(int index)
{
    if(index<m_tasks.count())
        return m_tasks[index];
    return nullptr;
}

int TasksModel::rowCount(const QModelIndex &parent) const
{
    return m_tasks.count();
}

QVariant TasksModel::data(const QModelIndex &index, int role) const
{
    if(index.row() >=0 && index.row()<m_tasks.count()){
        switch (role) {
            case TaskRoles::Id:
                return m_tasks[index.row()]->id();
            case TaskRoles::Description:
               return m_tasks[index.row()]->description();
            case TaskRoles::Completed:
               return m_tasks[index.row()]->completed();
            case TaskRoles::Importance:
               return m_tasks[index.row()]->importance();
            case TaskRoles::Date:
               return m_tasks[index.row()]->date();
        }
    }
    return QVariant();
}

void TasksModel::append(Task *task)
{
    beginInsertRows(QModelIndex(), m_tasks.count(), m_tasks.count());
    m_tasks.append(task);
    endInsertRows();
}

void TasksModel::clear()
{
    beginResetModel();
    m_tasks.clear();
    endResetModel();
}

QHash<int, QByteArray> TasksModel::roleNames() const
{
    QHash<int , QByteArray> hashset;
    hashset[TaskRoles::Id] = "id";
    hashset[TaskRoles::Description] = "description";
    hashset[TaskRoles::Completed] = "completed";
    hashset[TaskRoles::Importance] = "importance";
    hashset[TaskRoles::Date] = "date";
    return hashset;
}

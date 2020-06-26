#include "task.h"

Task::Task(QObject *parent) : QObject(parent)
{

}

Task::Task(int id, const QString &description, bool completed, int importance, const QString &date)
{
    setId(id);
    setDescription(description);
    setCompleted(completed);
    setImportance(importance);
    setDate(date);
}

int Task::id()
{
    return m_id;
}

QString Task::description()
{
    return m_description;
}

bool Task::completed()
{
    return m_completed;
}

int Task::importance()
{
    return m_importance;
}

QString Task::date()
{
    return m_date;
}

void Task::setId(int id)
{
    m_id = id;
    emit idChanged(id);
}

void Task::setDescription(const QString &description)
{
    m_description = description;
    emit descriptionChanged(description);
}

void Task::setCompleted(bool completed)
{
    m_completed = completed;
    emit completedChanged(completed);
}

void Task::setImportance(int importance)
{
    m_importance = importance;
    emit importanceChanged(importance);
}

void Task::setDate(const QString &date)
{
    m_date = date;
    emit dateChanged(date);
}

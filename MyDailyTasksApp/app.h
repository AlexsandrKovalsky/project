#ifndef APP_H
#define APP_H

#include <QObject>
#include "tasksManager.h"

class App : public QObject
{
    Q_OBJECT
    Q_PROPERTY(TasksManager* tasksManager READ tasksManager WRITE setTasksManager NOTIFY tasksManagerChanged)
public:
    explicit App(QObject *parent = nullptr);

    TasksManager* tasksManager();
    void setTasksManager(TasksManager* tasksManager);

signals:
    void tasksManagerChanged();

private:
    TasksManager* m_tasksManager;
};

#endif // APP_H

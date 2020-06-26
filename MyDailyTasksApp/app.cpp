#include "app.h"

App::App(QObject *parent) : QObject(parent)
{
    setTasksManager(new TasksManager());

}

TasksManager *App::tasksManager()
{
   return m_tasksManager;
}

void App::setTasksManager(TasksManager *tasksManager)
{
    m_tasksManager = tasksManager;
    emit tasksManagerChanged();
}

#ifndef TASKSMANAGER_H
#define TASKSMANAGER_H

#include <QObject>
#include <QtSql>
#include "taskmodel.h"
class TasksManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(TasksModel* calendarDayTasksModel READ calendarDayTasksModel WRITE setCalendarDayTasksModel NOTIFY calendarDayTasksModelChanged)
    Q_PROPERTY(TasksModel* importantTasksModel READ importantTasksModel WRITE setImportantTasksModel NOTIFY importantTasksModelChanged)
    Q_PROPERTY(TasksModel* burningTasksModel READ burningTasksModel WRITE setBurningTasksModel NOTIFY burningTasksModelChanged)
public:
    explicit TasksManager(QObject *parent = nullptr);
    Q_INVOKABLE void addTask(const QString& description,
                             bool completed, int importance, const QString& date);
    Q_INVOKABLE void updateTask(int id, const QString& decsription,
                                int importance, const QString& date);
    Q_INVOKABLE void updateTask(int id, bool completed);
    Q_INVOKABLE void deleteTask(int id);
    Q_INVOKABLE void getTasks();
    Q_INVOKABLE void getTasksSortedByImportance();
    Q_INVOKABLE void getTasksForDay(const QString& date);
    Q_INVOKABLE void getBurningTasks();
    Q_INVOKABLE int getDayTasksProgressPercent(const QString& date);
    Q_INVOKABLE int getAllTasksProgressPercent();


    TasksModel* calendarDayTasksModel();
    TasksModel* importantTasksModel();
    TasksModel* burningTasksModel();
    void setCalendarDayTasksModel(TasksModel* calendarDayTasksModel);
    void setImportantTasksModel(TasksModel* importantTasksModel);
    void setBurningTasksModel(TasksModel* burningTasksModel);

signals:
    void calendarDayTasksModelChanged();
    void importantTasksModelChanged();
    void burningTasksModelChanged();

private:
    QSqlDatabase m_database;
    QSqlQuery m_query;

    TasksModel* m_calendarDayTasksModel;
    TasksModel* m_importantTasksModel;
    TasksModel* m_burningTasksModel;

};

#endif // TASKSMANAGER_H

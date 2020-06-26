#include "tasksManager.h"
#include <QDate>

TasksManager::TasksManager(QObject *parent) : QObject(parent)
{
    setCalendarDayTasksModel(new TasksModel());
    setImportantTasksModel(new TasksModel());
    setBurningTasksModel(new TasksModel());
    m_database = QSqlDatabase::addDatabase("QSQLITE");
    m_database.setDatabaseName("SQLite.db");
    if(m_database.open()){
        m_query = QSqlQuery(m_database);
        m_query.exec("CREATE TABLE IF NOT EXISTS tasks("
                     "id INTEGER PRIMARY KEY,"
                     "description TEXT,"
                     "completed INTEGER,"
                     "importance INTEGER,"
                     "date TEXT)");
    }
}

void TasksManager::addTask(const QString &description, bool completed, int importance, const QString &date)
{
    int completedInt = completed ? 1 : 0;
    if(m_database.open()){
        m_query.exec(QString("INSERT INTO tasks(description, completed, importance, date)"
                     "VALUES ('%1', '%2', '%3', '%4')")
                     .arg(description, QString::number(completedInt), QString::number(importance), date));
    }

}

void TasksManager::updateTask(int id, const QString &description, int importance, const QString &date)
{
    if(m_database.open()){
        bool res = m_query.exec(QString("UPDATE tasks SET description='%1',"
                             "importance='%2', date='%3' where id='%4'")
                            .arg(description, QString::number(importance),
                                 date, QString::number(id)));
        qDebug() << "Full Update result" << res;
        emit calendarDayTasksModelChanged();
        emit importantTasksModelChanged();
        emit burningTasksModelChanged();
    }
}

void TasksManager::updateTask(int id, bool completed)
{
    int completedInt = completed ? 1 : 0;
    if(m_database.open()){
        bool res = m_query.exec(QString("UPDATE tasks SET completed='%1' WHERE id='%2'")
                            .arg(QString::number(completedInt), QString::number(id)));
        qDebug() << "Update result" << res;
    }
}

void TasksManager::deleteTask(int id)
{
    if(m_database.open()){
        m_query.exec(QString("DELETE FROM tasks WHERE id='%1'")
                            .arg(QString::number(id)));
        qDebug() << "updated!";
    }
}

void TasksManager::getTasks()
{
    if(m_database.open()){
        m_calendarDayTasksModel->clear();
        m_query.exec("SELECT * FROM tasks");
        while(m_query.next()){
            int id = m_query.value(0).toInt();
            QString description = m_query.value(1).toString();
            bool completed = m_query.value(2).toBool();
            int importance = m_query.value(3).toInt();
            QString date = m_query.value(4).toString();
            m_calendarDayTasksModel->append(new Task(id, description, completed, importance, date));
            qDebug() << id << description << completed << importance << date;
        }
        emit calendarDayTasksModelChanged();
    }
}

void TasksManager::getTasksSortedByImportance()
{
    if(m_database.open()){
        m_importantTasksModel->clear();
        m_query.exec("SELECT * FROM tasks ORDER BY importance DESC LIMIT 5");
        while(m_query.next()){
            int id = m_query.value(0).toInt();
            QString description = m_query.value(1).toString();
            bool completed = m_query.value(2).toBool();
            int importance = m_query.value(3).toInt();
            QString date = m_query.value(4).toString();
            m_importantTasksModel->append(new Task(id, description, completed, importance, date));
            qDebug() << id << description << completed << importance << date;
        }
        emit importantTasksModelChanged();
    }
}

void TasksManager::getTasksForDay(const QString &date)
{
    if(m_database.open()){
        m_calendarDayTasksModel->clear();
        m_query.exec(QString("SELECT * FROM tasks WHERE date='%1'").arg(date));
        while(m_query.next()){
            int id = m_query.value(0).toInt();
            QString description = m_query.value(1).toString();
            bool completed = m_query.value(2).toBool();
            int importance = m_query.value(3).toInt();
            QString date = m_query.value(4).toString();
            m_calendarDayTasksModel->append(new Task(id, description, completed, importance, date));
            qDebug() << id << description << completed << importance << date;
        }
        emit calendarDayTasksModelChanged();
    }
}

void TasksManager::getBurningTasks()
{
    QDate date = QDate::currentDate().addDays(2);
    QString stringDate = date.toString("dd-MM-yyyy");
    if(m_database.open()){
        m_burningTasksModel->clear();
        m_query.exec(QString("SELECT * FROM tasks WHERE date<='%1' AND completed='0'")
                     .arg(stringDate));
        while(m_query.next()){
            int id = m_query.value(0).toInt();
            QString description = m_query.value(1).toString();
            bool completed = m_query.value(2).toBool();
            int importance = m_query.value(3).toInt();
            QString date = m_query.value(4).toString();
            m_burningTasksModel->append(new Task(id, description, completed, importance, date));
            qDebug() << id << description << completed << importance << date;
        }
        emit burningTasksModelChanged();
    }
}

int TasksManager::getDayTasksProgressPercent(const QString &date)
{
    float percent = 0;
    if(m_database.open()){
        m_query.exec(QString("SELECT * FROM tasks WHERE date='%1'").arg(date));
        int allTasksCount = 0;
        while(m_query.next())
            allTasksCount++;
        qDebug() << "Day all tasks count: " << allTasksCount;

        m_query.exec(QString("SELECT * FROM tasks WHERE date='%1' AND completed='1'").arg(date));
        int completedTasksCount = 0;
        while(m_query.next())
            completedTasksCount++;
        qDebug() << "Day completed tasks count: " << completedTasksCount;
        if(allTasksCount!=0)
            percent = (float) completedTasksCount / allTasksCount * 100;
        else return 100;
        qDebug() << "Percent:" << percent;
    }
    return (int) percent;
}

int TasksManager::getAllTasksProgressPercent()
{
    float percent = 0;
    if(m_database.open()){
        m_query.exec("SELECT * FROM tasks");
        int allTasksCount = 0;
        while(m_query.next())
            allTasksCount++;
        qDebug() << "All all tasks count: " << allTasksCount;

        m_query.exec("SELECT * FROM tasks WHERE completed='1'");
        int completedTasksCount = 0;
        while(m_query.next())
            completedTasksCount++;
        qDebug() << "All completed tasks count: " << completedTasksCount;
        if(allTasksCount!=0)
            percent = (float) completedTasksCount / allTasksCount * 100;
        else return 100;
        qDebug() << "Percent:" << percent;
    }
    return (int) percent;
}

TasksModel *TasksManager::calendarDayTasksModel()
{
    return m_calendarDayTasksModel;
}

TasksModel *TasksManager::importantTasksModel()
{
    return m_importantTasksModel;
}

TasksModel *TasksManager::burningTasksModel()
{
    return m_burningTasksModel;
}

void TasksManager::setCalendarDayTasksModel(TasksModel *tasksModel)
{
    m_calendarDayTasksModel = tasksModel;
    emit calendarDayTasksModelChanged();
}

void TasksManager::setImportantTasksModel(TasksModel *importantTasksModel)
{
    m_importantTasksModel = importantTasksModel;
    emit importantTasksModelChanged();
}

void TasksManager::setBurningTasksModel(TasksModel *burningTasksModel)
{
    m_burningTasksModel = burningTasksModel;
    emit burningTasksModelChanged();
}

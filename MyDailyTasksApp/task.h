#ifndef TASK_H
#define TASK_H

#include <QObject>

class Task : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(bool completed READ completed WRITE setCompleted NOTIFY completedChanged)
    Q_PROPERTY(int importance READ importance WRITE setImportance NOTIFY importanceChanged)
    Q_PROPERTY(QString date READ date WRITE setDate NOTIFY dateChanged)
public:
    explicit Task(QObject *parent = nullptr);
    Task(int id, const QString& description, bool completed, int importance, const QString& date);

    int id();
    QString description();
    bool completed();
    int importance();
    QString date();

    void setId(int id);
    void setDescription(const QString& description);
    void setCompleted(bool completed);
    void setImportance(int importance);
    void setDate(const QString& date);


signals:
    void idChanged(int id);
    void descriptionChanged(const QString& description);
    void completedChanged(bool completed);
    void importanceChanged(int importance);
    void dateChanged(const QString& date);

private:
    int m_id;
    QString m_description;
    bool m_completed;
    int m_importance;
    QString m_date;
};

#endif // TASK_H

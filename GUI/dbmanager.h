#ifndef DBMANAGER_H
#define DBMANAGER_H
#include <includes.h>

#include "pcan.h"

#include "qtmetamacros.h"

class DbManager: public QObject {
    Q_OBJECT
    Q_PROPERTY(QVector < double > load READ getLoad NOTIFY LoadChanged());
    Q_PROPERTY(QVector < double > load2 READ getLoad2 NOTIFY LoadChanged2());
    Q_PROPERTY(QString getlast READ getlast NOTIFY LastChanged());
    Q_PROPERTY(QString deleteFirst READ deleteFirst)
    Q_PROPERTY(int getHours READ getHours WRITE setHours NOTIFY HourChanged())
    Q_PROPERTY(int getMinutes READ getMinutes WRITE setMinutes NOTIFY MinutesChanged())
    Q_PROPERTY(int getSeconds READ getSeconds WRITE setSeconds NOTIFY SecondsChanged())
    Q_PROPERTY(READ updateStandby NOTIFY UpdateStandbyChanged);
    Q_PROPERTY(int output READ getOutput WRITE setOutput NOTIFY OutputChanged());
    Q_PROPERTY(READ updateOutput NOTIFY UpdateOutputChanged());
    Q_PROPERTY(QString language READ getLanguage WRITE setLanguage NOTIFY LanguageChanged());
    Q_PROPERTY(int bypass READ getBypass WRITE setBypass NOTIFY BypassChanged());

public:
    DbManager();
    QString lastOne();
    void newSession();
    void insertSession();
    void createTable();
    void dropOlderTable();
    void keep100rows();
    void insertIntoTable();
    void selectLoad();
    void selectLoad2();
    void selectStandby();
    void selectOutput();
    void selectBypass();
    int getSeconds() const;
    int getMinutes() const;
    int getHours() const;
    void selectSerialNumber();
    QString getLanguage() const;
    QString getlast() const;
    QString deleteFirst();
    Q_INVOKABLE QVector < double > loadParameter(const QString & currentTable);
    Q_INVOKABLE QVector < double > getLoad() const;
    Q_INVOKABLE QVector < double > getLoad2() const;
    Q_INVOKABLE QVector < QString > selectAllTables();

public slots:
    int getOutput() const;
    int getBypass() const;
    void updateStandby();
    void updateOutput();
    void updateLanguage(QString Language);
    void updateBypass();
    void setSeconds(int value);
    void setMinutes(int value);
    void setHours(int value);
    void setOutput(int value);
    void setBypass(int value);
    void setLanguage(QString value);

signals:
    void LanguageChanged();
    void LoadChanged();
    void LoadChanged2();
    void AllTablesChanged();
    void LastChanged();
    void HourChanged();
    void MinutesChanged();
    void SecondsChanged();
    void UpdateStandbyChanged();
    void OutputChanged();
    void UpdateOutputChanged();
    void BypassChanged();
private:
    int serialNumber;
    QSqlDatabase m_db;
    QTime standbyTime;
    QString secondss;
    QString minutess;
    QString hourss;
    QString language;
    int hours;
    int minutes;
    int seconds;
    int output;
    int bypass;
};

#endif // DBMANAGER_H

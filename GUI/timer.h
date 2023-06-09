#ifndef TIMER_H
#define TIMER_H

#include <QObject>

#include <QTimer>

#include <includes.h>

#include <dbmanager.h>

class timer: public QObject {
    Q_OBJECT
    Q_PROPERTY(int seconds READ getSeconds WRITE setSeconds NOTIFY SecondsChanged)
    Q_PROPERTY(int minutes READ getMinutes WRITE setMinutes NOTIFY MinutesChanged)
    Q_PROPERTY(int hours READ getHours WRITE setHours NOTIFY HoursChanged)
public:
    explicit timer(QObject * parent = nullptr);
    int getSeconds() const;
    int getMinutes() const;
    int getHours() const;

    void remainingTimer();
signals:
    void userActivity();
    void SecondsChanged();
    void MinutesChanged();
    void HoursChanged();

public slots:
    void standby();
    void resetTimer();
    void setSeconds(int value);
    void setMinutes(int value);
    void setHours(int value);

private:
    QTimer m_timer;
    int seconds = 0;
    int minutes = 0;
    int hours = 0;
    int totalSeconds = hours * 3600 + minutes * 60 + seconds;
};

#endif // TIMER_H

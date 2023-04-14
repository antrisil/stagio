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
    Q_PROPERTY(int sleepi READ getSleepi WRITE setSleepi NOTIFY SleepiChanged)

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
    void SleepiChanged();

public slots:
    void standby();
    int getSleepi() const;
    void resetTimer();
    void setSeconds(int value);
    void setMinutes(int value);
    void setHours(int value);
    void setSleepi(int value);

private:
    QTimer m_timer;
    int sleepi = 0;
    int seconds = 0;
    int minutes = 0;
    int hours = 0;
    int totalSeconds = hours * 3600 + minutes * 60 + seconds;
};

#endif // TIMER_H

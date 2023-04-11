#ifndef USERACTIVITYDETECTOR_H
#define USERACTIVITYDETECTOR_H
#include "qobject.h"
#include "timer.h"
#include "includes.h"


class UserActivityDetector : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int seconds READ getSeconds WRITE setSeconds NOTIFY SecondsChanged)
    Q_PROPERTY(int minutes READ getMinutes WRITE setMinutes NOTIFY MinutesChanged)
    Q_PROPERTY(int hours READ getHours WRITE setHours NOTIFY HoursChanged)
public:
    UserActivityDetector(QObject *parent = nullptr);
    int getSeconds() const;
    int getMinutes() const;
    int getHours() const;

public slots:
    void setSeconds(int value);
    void setMinutes(int value);
    void setHours(int value);

signals:
    void userActivityDetected();
    void SecondsChanged();
    void MinutesChanged();
    void HoursChanged();

protected:
    bool eventFilter(QObject *obj, QEvent *event) override;

private:
    QTimer m_timer;
    int seconds = 10;
    int minutes = 0;
    int hours = 0;
    int totalSeconds = hours * 3600 + minutes * 60 + seconds;
};

#endif // USERACTIVITYDETECTOR_H

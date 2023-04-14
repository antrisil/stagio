#include "timer.h"

#include <unistd.h>

#include <QProcess>

#include <dbmanager.h>


timer::timer(QObject * parent): QObject(parent) {
    m_timer.setInterval(totalSeconds * 1000);
    m_timer.setSingleShot(true);
    connect( & m_timer, & QTimer::timeout, this, & timer::standby);
}

void timer::remainingTimer() {
    while (1) {
        sleep(1);
        qDebug() << m_timer.interval();
    }
}

void timer::setSeconds(int value) {
    if (seconds != value) {
        seconds = value;
        totalSeconds = hours * 3600 + minutes * 60 + seconds;
        m_timer.setInterval(totalSeconds * 1000);
        emit SecondsChanged();
    }
}

int timer::getSeconds() const {
    return seconds;
}

void timer::setMinutes(int value) {
    if (minutes != value) {
        minutes = value;
        totalSeconds = hours * 3600 + minutes * 60 + seconds;
        m_timer.setInterval(totalSeconds * 1000);
        emit MinutesChanged();
    }
}

void timer::setHours(int value) {
    if (hours != value) {
        hours = value;
        totalSeconds = hours * 3600 + minutes * 60 + seconds;
        m_timer.setInterval(totalSeconds * 1000);
        emit HoursChanged();
    }
}

void timer::setSleepi(int value)
{
    if (sleepi != value){
        sleepi = value;
        emit SleepiChanged();
    }
}

int timer::getMinutes() const {
    return minutes;
}

int timer::getHours() const {
    return hours;
}

int timer::getSleepi() const
{
    return sleepi;
    qDebug() << sleepi;
}

void timer::standby() {
    sleepi = 1;
    system("xset dpms force off");
}

void timer::resetTimer() {
    m_timer.start();
}

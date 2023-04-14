#include "useractivitydetector.h"

#include "qcoreevent.h"

timer *tempo;

UserActivityDetector::UserActivityDetector(QObject * parent): QObject(parent) {
    m_timer.setInterval(totalSeconds * 1000);
    m_timer.setSingleShot(true);
    connect( & m_timer, & QTimer::timeout, this, & UserActivityDetector::userActivityDetected);
}

bool UserActivityDetector::eventFilter(QObject * obj, QEvent * event) {
    switch (event -> type()) {
    case QEvent::MouseButtonDblClick:
    case QEvent::MouseButtonPress:
    case QEvent::MouseButtonRelease:
    case QEvent::MouseMove:
    case QEvent::Wheel:
//        tempo->setSleepi(0);
        m_timer.start();
        break;
    default:
        break;
    }
    return QObject::eventFilter(obj, event);
}

void UserActivityDetector::setSeconds(int value) {
    if (seconds != value) {
        seconds = value;
        totalSeconds = hours * 3600 + minutes * 60 + seconds;
        m_timer.setInterval(totalSeconds * 1000);
        emit SecondsChanged();
    }
}

int UserActivityDetector::getSeconds() const {
    return seconds;
}

void UserActivityDetector::setMinutes(int value) {
    if (minutes != value) {
        minutes = value;
        totalSeconds = hours * 3600 + minutes * 60 + seconds;
        m_timer.setInterval(totalSeconds * 1000);
        emit MinutesChanged();
    }
}

void UserActivityDetector::setHours(int value) {
    if (hours != value) {
        hours = value;
        totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
        m_timer.setInterval(totalSeconds * 1000);
        emit HoursChanged();
    }
}

int UserActivityDetector::getMinutes() const {
    return minutes;
}

int UserActivityDetector::getHours() const {
    return hours;
}

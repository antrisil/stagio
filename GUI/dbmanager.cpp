#include "dbmanager.h"

QVector < double > load;
QVector < double > load2;
pcan * can = new pcan;
QMutex mutex;
QDateTime cdt = QDateTime::currentDateTime();
QVector < QString > dataehora;
QString last = cdt.toString("yyyy/MM/dd_hh:mm:ss");
DbManager::DbManager() {
    mutex.lock();
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName("/home/jonathan/Desktop/GUI/DB/teste.db");
    if (!m_db.open()) {
        qDebug() << "Error: connection with database failed";
    } else {
        qDebug() << "Database: connection ok";
    }
    mutex.unlock();
}

void DbManager::newSession() {

    QSqlQuery query(m_db);
    query.prepare("INSERT INTO startoff(id_sesion,start_reason,end_reason) VALUES (NULL ,'ff','ff');");
    if (query.exec()) {
        qDebug("insertss succesfully added");
    } else {
        qDebug() << "insertss error:" << query.lastError();
    }
}

void DbManager::insertSession() {
    QSqlQuery query(m_db);
    query.prepare("SELECT (id_sesion) from startoff order by id_sesion DESC LIMIT 1");
    if (query.exec()) {
        while (query.next()) {
            int id_sesion = query.value("id_sesion").toInt();
            qDebug() << id_sesion;
            if (id_sesion == 1) {
                query.prepare("insert into def_settings(serial_number, language0, output, standby) values (" + QString::number(can -> getRunSerialNum()) + ", NULL, NULL, NULL)");
                if (query.exec()) {
                    qDebug("insert into def_settings success");
                } else {
                    qDebug() << "def_settings error:" << query.lastError();
                }
                query.prepare("insert into settings(def_serial_number, language0, output, standby) values (" + QString::number(can -> getRunSerialNum()) + ", NULL, NULL, NULL)");
                if (query.exec()) {
                    qDebug("insert into settings success");
                } else {
                    qDebug() << "settings error:" << query.lastError();
                }

            } else {
                qDebug("id_sesion != 1");
            }
        }
    } else {
        qDebug() << "testing error:" << query.lastError();
    }
}

void DbManager::createTable() {
    QSqlQuery query(m_db);
    query.prepare("CREATE TABLE \"" + cdt.toString("yyyy/MM/dd_hh:mm:ss") + "\"(id_sesion_ss int, datatime datetime, serialnumber int, Vil1 int, Vil2 int, vil3 int, iil1 int, iil2 int, iil3 int, vol1 int, vol2 int,"
                                                                            "vol3 int, iol1 int, iol2 int, iol3 int, temp float, timee time, rh float, load float, FOREIGN KEY (serialnumber) REFERENCES def_settings(serial_number), FOREIGN KEY (id_sesion_ss) REFERENCES startoff(id_sesion));");
    if (query.exec()) {
        qDebug("table sucessfully created");
    } else {
        qDebug() << "testing error:" << query.lastError();
    }
}

void DbManager::dropOlderTable() {
    QSqlQuery query(m_db);
    query.prepare("SELECT name FROM sqlite_schema WHERE type='table' AND name like '2%' LIMIT 1");
    if (query.exec()) {
        while (query.next()) {
            QString droping = query.value(0).toString();
            query.prepare("drop table \"" + droping + "\"");
        }
        if (query.exec()) {
            qDebug("droping sucessfully created");
        } else {
            qDebug() << "droping error:" << query.lastError();
        }
    } else {
        qDebug() << "droping error:" << query.lastError();
    }
}

void DbManager::keep100rows() {
    QSqlQuery query(m_db);
    query.prepare("CREATE TRIGGER \"" + cdt.toString("yyyy/MM/dd_hh:mm:ss") + "\" AFTER INSERT ON \"" + cdt.toString("yyyy/MM/dd_hh:mm:ss") + "\" BEGIN delete from \"" + cdt.toString("yyyy/MM/dd_hh:mm:ss") +
                  "\" where datatime =(select min(datatime) from \"" + cdt.toString("yyyy/MM/dd_hh:mm:ss") + "\" ) and (select count(*) from \"" + cdt.toString("yyyy/MM/dd_hh:mm:ss") + "\" )= 253200; END;");
    if (query.exec()) {
        qDebug("trigger succesfully added");
    } else {
        qDebug() << "trigger error:" << query.lastError();
    }
}

void DbManager::updateStandby() {
    QSqlQuery query(m_db);
    query.prepare("update settings set standby = \'" + standbyTime.toString("hh:mm:ss") + "\' where def_serial_number = " + QString::number(serialNumber));
    if (query.exec()) {
        qDebug() << "update" << standbyTime.toString("hh:mm:ss");
    } else {
        qDebug() << "update error:" << query.lastError();
    }
}

void DbManager::updateOutput() {
    QSqlQuery query(m_db);
    query.prepare("update settings set output = " + QString::number(output) + " where def_serial_number = " + QString::number(serialNumber));
    if (query.exec()) {
        qDebug() << "update" << standbyTime.toString("hh:mm:ss");
    } else {
        qDebug() << "update error:" << query.lastError();
    }
}

void DbManager::updateLanguage(QString Language) {
    QSqlQuery query(m_db);
    query.prepare("update settings set language0 = \"" + language + "\" where def_serial_number = " + QString::number(serialNumber));
    if (query.exec()) {
        qDebug() << "update" << language;
    } else {
        qDebug() << "update error:" << query.lastError();
    }
}

void DbManager::updateBypass() {
    QSqlQuery query(m_db);
    query.prepare("update settings set bypass = " + QString::number(bypass) + " where def_serial_number = " + QString::number(serialNumber));
    if (query.exec()) {
        qDebug() << "bypass" << bypass;
    } else {
        qDebug() << "bypass error:" << query.lastError();
    }
}

QVector < QString > DbManager::selectAllTables() {
    QSqlQuery query(m_db);
    query.prepare("SELECT name FROM sqlite_schema  WHERE type='table' AND name like '2%' order by name DESC");
    if (query.exec()) {
        while (query.next()) {
            dataehora.append(query.value(0).toString());
            emit AllTablesChanged();
        }
    } else {
        qDebug() << "all_tables" << query.lastError();
    }
    return dataehora;
}

void DbManager::setSeconds(int value) {
    if (seconds != value) {
        seconds = value;
        qDebug() << "seconds" << seconds;
        standbyTime.setHMS(hours, minutes, seconds);
        emit SecondsChanged();
    }
}

void DbManager::setMinutes(int value) {
    if (minutes != value) {
        minutes = value;
        qDebug() << "minutes" << minutes;
        standbyTime.setHMS(hours, minutes, seconds);
        emit MinutesChanged();
    }
}

void DbManager::setHours(int value) {
    if (hours != value) {
        hours = value;
        qDebug() << "hours" << hours;
        standbyTime.setHMS(hours, minutes, seconds);
        emit HourChanged();
    }
}

void DbManager::setOutput(int value) {
    if (output != value) {
        output = value;
        qDebug() << "output" << output;
        emit OutputChanged();
    }
}

void DbManager::setBypass(int value) {
    if (bypass != value) {
        bypass = value;
        emit BypassChanged();
    }
}

void DbManager::setLanguage(QString value) {
    if (language != value) {
        language = value;
        qDebug() << "language" << language;
        emit LanguageChanged();
    }
}

void DbManager::insertIntoTable() {
    QSqlQuery query(m_db);
    while (1) {
        QDateTime cdt2 = QDateTime::currentDateTime();
        QTime timee(0, 0, 0);
        timee = timee.addSecs(can -> getUnitRunTime());
        int x = QRandomGenerator::global() -> bounded(100);
        query.prepare("INSERT INTO \"" + cdt.toString("yyyy/MM/dd_hh:mm:ss") + "\"(datatime, id_sesion_ss, serialnumber, Vil1, Vil2, vil3, iil1, iil2, iil3, vol1, vol2, vol3, iol1, iol2, iol3, timee, temp, rh, load) "
                                                                               "VALUES(\"" + cdt2.toString("yyyy/MM/dd_hh:mm:ss") + "\", (SELECT (id_sesion) from startoff order by id_sesion DESC LIMIT 1), " + QString::number(can -> getRunSerialNum()) + ", " + QString::number(can -> getAB() / 10.0) + ", " +
                      QString::number(can -> getBC() / 10.0) + ", " + QString::number(can -> getCA() / 10.0) + ", " + QString::number(can -> getRectPhaseACur() / 10.0) + ", " + QString::number(can -> getRectPhaseBCur() / 10.0) + ", " +
                      QString::number(can -> getRectPhaseCCur() / 10.0) + ", " + QString::number(can -> getInvPhaseAVolt() / 10.0) + ", " + QString::number(can -> getInvPhaseBVolt() / 10.0) + ", " + QString::number(can -> getInvPhaseCVolt() / 10.0) +
                      ", " + QString::number(can -> getInvPhaseACur()) + ", " + QString::number(can -> getInvPhaseBCur()) + ", " + QString::number(can -> getInvPhaseCCur()) + ", \"" + timee.toString("hh:mm:ss") +
                      "\"," + QString::number(can -> getTemp() / 10.0) + ", " + QString::number(can -> getHumidity() / 10.0) + ", " + QString::number(x) + ");");
        if (query.exec()) {
            qDebug("row succesfully added");
        } else {
            qDebug() << "insertInto error:" << query.lastError();
        }
        sleep(1);
    }
}

void DbManager::selectLoad() {
    QSqlQuery query(m_db);
    while (1) {
        sleep(1);
        query.prepare("SELECT load from \"" + cdt.toString("yyyy/MM/dd_hh:mm:ss") + "\" order by datatime DESC limit 1; ");
        if (query.exec()) {
            while (query.next()) {
                load.append(query.value(0).toFloat());
                emit LoadChanged();
            }
        } else {
            qDebug() << "select error: " << query.lastError();
        }
    }
}

QString DbManager::lastOne() {
    last = cdt.toString("yyyy/MM/dd_hh:mm:ss");
    return last;
}

QString DbManager::deleteFirst() {
    load.takeFirst();
    return "1";
}

QVector < double > DbManager::loadParameter(const QString & currentTable) {
    QSqlQuery query(m_db);
    query.prepare("SELECT load from \"" + currentTable + "\" order by datatime DESC");
    load2.clear();
    if (query.exec()) {
        while (query.next()) {
            load2.append(query.value(0).toFloat());
        }
        emit LoadChanged2();
    } else {
        qDebug() << "getting load error: " << query.lastError();
    }
    return load2;
}

void DbManager::selectStandby() {
    QSqlQuery query(m_db);
    query.prepare("select standby from settings");
    if (query.exec()) {
        while (query.next()) {
            standbyTime = query.value(0).toTime();
        }
    } else {
        qDebug() << "selectStanby error: " << query.lastError();
    }
    hourss = standbyTime.toString("hh");
    minutess = standbyTime.toString("mm");
    secondss = standbyTime.toString("ss");
    hours = hourss.toInt();
    minutes = minutess.toInt();
    seconds = secondss.toInt();
}

void DbManager::selectOutput() {
    QSqlQuery query(m_db);
    query.prepare("select output from settings");
    if (query.exec()) {
        while (query.next()) {
            output = query.value(0).toInt();
        }
    } else {
        qDebug() << "selectStanby error: " << query.lastError();
    }
}

void DbManager::selectBypass() {
    QSqlQuery query(m_db);
    query.prepare("select bypass from settings");
    if (query.exec()) {
        while (query.next()) {
            bypass = query.value(0).toInt();
        }
    } else {
        qDebug() << "bypass error: " << query.lastError();
    }
}

int DbManager::getOutput() const {
    qDebug() << output;
    return output;
    qDebug() << output;
}

int DbManager::getSeconds() const {
    return secondss.toInt();
}

int DbManager::getMinutes() const {
    return minutess.toInt();
}

int DbManager::getHours() const {
    return hourss.toInt();
}

void DbManager::selectSerialNumber() {
    QSqlQuery query(m_db);
    query.prepare("select def_serial_number from settings");
    if (query.exec()) {
        while (query.next()) {
            serialNumber = query.value(0).toInt();
            qDebug() << "serial number " << serialNumber;
        }
    } else {
        qDebug() << "bypass error: " << query.lastError();
    }
}

int DbManager::getBypass() const {
    return bypass;
}

QString DbManager::getLanguage() const {
    return language;
}

QVector < double > DbManager::getLoad() const {
    qDebug() << load;
    return load;
}

QVector < double > DbManager::getLoad2() const {
    return load2;
}

QString DbManager::getlast() const {
    return last;

}

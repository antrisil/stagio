#include "pcan.h"

using namespace std;
bool frameWritten;
float a = 1, rectNomVolt, rectNomCur, runSerialNum, invNomVolt, invNomCur, invNomFreq, temp, humidity, AB, BC, CA, rectPhaseACur, rectPhaseBCur, rectPhaseCCur, rectMainFreq, unitRunTime,
    invPhaseAVolt, invPhaseBVolt, invPhaseCVolt, invPhaseACur, invPhaseBCur, invPhaseCCur, invFreq, rectDCBusV, pn, poi, load_;
QString error_sfc, error_n, unitSerialNum;

QMutex data_mutex;

pcan::pcan() {}
void pcan::write(QCanBusDevice * device) {
    QString errorString;
    if (!device) {
        qDebug() << errorString;
    }
    QCanBusFrame roxFrame;
    roxFrame.setFrameId(0x100);
    roxFrame.setFrameType(QCanBusFrame::RemoteRequestFrame);
    frameWritten = device -> writeFrame(roxFrame);
}

bool pcan::receive(QCanBusDevice * device) {
    QString str;

    while (true) {

        data_mutex.lock();
        if (device -> framesAvailable() > 0) {
            const QCanBusFrame frame = device -> readFrame();
            qDebug() << "  Received CAN frame:";
            qDebug() << "  ID          : " << QString::number(frame.frameId(), 16).rightJustified(3, '0');
            qDebug() << "  DLC         : " << QString::number(frame.payload().size());
            qDebug() << "  MESSAGE     : " << QString(frame.payload().toHex());
            switch (frame.frameId()) {
            case 0x100:
                if (frame.payload().at(0) == 0) {
                    if (frame.payload().at(1) == 0) {
                        qDebug() << "  Rectifier is a 3 phase type rectifier";
                    } else if (frame.payload().at(1) == 1) {
                        qDebug("  Rectifier is a single phase type rectifier");
                    }
                    rectNomVolt = ((uint8_t) frame.payload().at(2) << 8 | (uint8_t) frame.payload().at(3));
                    qDebug() << "  rectNomVolt : " << QString::number(rectNomVolt / 10.0) + " V";

                    rectNomCur = ((uint8_t) frame.payload().at(4) << 8 | (uint8_t) frame.payload().at(5));
                    qDebug() << "  rectNomCur  : " << QString::number(rectNomCur / 10.0) + " A";

                    runSerialNum = ((uint8_t) frame.payload().at(6) << 8 | (uint8_t) frame.payload().at(7));
                    qDebug() << "  runSerialNum:  " << QString::number(runSerialNum);
                } else if (frame.payload().at(0) == 1) {
                    if (frame.payload().at(1) == 0) {
                        qDebug("  Inverter is a 3 phase type inverter");
                    }
                    if (frame.payload().at(1) == 1) {
                        qDebug("  Inverter is a single phase type inverter");
                    }
                    invNomVolt = ((uint8_t) frame.payload().at(2) << 8 | (uint8_t) frame.payload().at(3));
                    qDebug() << "  invNomVolt  : " << QString::number(invNomVolt / 10.0) + "V";

                    invNomCur = ((uint8_t) frame.payload().at(4) << 8 | (uint8_t) frame.payload().at(5));
                    qDebug() << "  invNomCur  : " << QString::number(invNomCur / 10.0) + "A";

                    invNomFreq = ((uint8_t) frame.payload().at(6) << 8 | (uint8_t) frame.payload().at(7));
                    qDebug() << "  invNomFreq  : " << QString::number(invNomFreq / 10.0) + "A";
                } else if (frame.payload().at(0) == 2) {
                    int unitSerialNum1 = (frame.payload().at(1));
                    int unitSerialNum2 = (frame.payload().at(2));
                    unitSerialNum = str.setNum(unitSerialNum1) + "." + str.setNum(unitSerialNum2);
                    qDebug() << unitSerialNum;

                }
                break;
            case 0x101:
                if (frame.payload().at(0) == 0) {
                    qDebug() << "Do not reset main borad error logic";
                } else if (frame.payload().at(0) == 1) {
                    qDebug() << "Reset main board error logic";
                }
                if (frame.payload().at(1) == 0) {
                    qDebug() << "Stop Inverter";
                } else if (frame.payload().at(1) == 1) {
                    qDebug() << "Start Inverter";
                }
                break;
            case 0x102:
                //Sfc_State
                switch (frame.payload().at(0)) {
                case 0x0:
                    error_sfc = "SFC_INIT = 0";
                    qDebug() << error_sfc;
                    break;
                case 0x1:
                    error_sfc = "SFC_INV_STOP";
                    qDebug() << error_sfc;
                    break;
                case 0x2:
                    error_sfc = "SFC_WAITH_FOR_DC_PRECH";
                    qDebug() << error_sfc;
                    break;
                case 0x3:
                    error_sfc = "SFC_WAITH_FOR_DC_PRECH";
                    qDebug() << error_sfc;
                    qDebug("SFC_INV_STARTING");
                    break;
                case 0x4:
                    error_sfc = "SFC_INV_RUNNING";
                    qDebug() << error_sfc;
                    break;
                case 0x5:
                    error_sfc = "SFC_INV_RUNNING_OVL";
                    qDebug() << error_sfc;
                    break;
                case 0x6:
                    error_sfc = "SFC_ERROR";
                    qDebug() << error_sfc;
                    break;
                case 0x7:
                    error_sfc = "SFC_ERROR_BLOCKED";
                    qDebug() << error_sfc;
                    break;
                }
                //Error
                switch (frame.payload().at(1)) {
                case 0x0:
                    error_n = "ERROR_NO_ERROR";
                    qDebug() << error_n;
                    break;
                case 0x1:
                    error_n = "ERROR_EEPROM_FAIL";
                    qDebug() << error_n;
                    break;
                case 0x2:
                    error_n = "ERROR_RH_HIGH";
                    qDebug() << error_n;
                    break;
                case 0x3:
                    error_n = "ERROR_SATP_INV";
                    qDebug() << error_n;
                    break;
                case 0x4:
                    error_n = "ERROR_OVT_PWR";
                    qDebug() << error_n;
                    break;
                case 0x5:
                    error_n = "ERROR_OVT_SHT";
                    qDebug() << error_n;
                    break;
                case 0x6:
                    error_n = "ERROR_EXT_EPO";
                    qDebug() << error_n;
                    break;
                case 0x7:
                    error_n = "ERROR_RCT_SW_DCOV";
                    qDebug() << error_n;
                    break;
                case 0x8:
                    error_n = "ERROR_RCT_HW_DCOV";
                    qDebug() << error_n;
                    break;
                case 0x9:
                    error_n = "ERROR_RCT_DC_UNDER_BALANCE";
                    qDebug() << error_n;
                    break;
                case 0x0A:
                    error_n = "ERROR_RCT_MAINS_PH_ROTATION";
                    qDebug() << error_n;
                    break;
                case 0x0B:
                    error_n = "ERROR_RCT_SW_MAINS_LOW";
                    qDebug() << error_n;
                    break;
                case 0x0C:
                    error_n = "ERROR_RCT_SW_MAINS_HIGH";
                    qDebug() << error_n;
                    break;
                case 0x0D:
                    error_n = "ERROR_RCT_HW_MAINS_HIGH";
                    qDebug() << error_n;
                    break;
                case 0x0E:
                    error_n = "ERROR_RCT_MAINS_TIMEOUT";
                    qDebug() << error_n;
                    break;
                case 0xF:
                    error_n = "ERROR_RCT_DC_PRECH_TIMEOUT";
                    qDebug() << error_n;
                    break;
                case 0x10:
                    error_n = "ERROR_RCT_START_TIMEOUT";
                    qDebug() << error_n;
                    break;
                case 0x11:
                    error_n = "ERROR_RCT_SDR1";
                    qDebug() << error_n;
                    break;
                case 0x12:
                    error_n = "ERROR_RCT_SDR2";
                    qDebug() << error_n;
                    break;
                case 0x13:
                    error_n = "SFC_ERROR_BLOCKED";
                    qDebug() << error_n;
                    qDebug("ERROR_INV_SD2");
                    break;
                case 0x14:
                    error_n = "ERROR_INV_START_TIMEOUT";
                    qDebug() << error_n;
                    break;
                case 0x15:
                    error_n = "ERROR_INV_SW_UNDER_VOLT";
                    qDebug() << error_n;
                    break;
                case 0x16:
                    error_n = "ERROR_INV_HW_OVER_VOLT";
                    qDebug() << error_n;
                    break;
                case 0x17:
                    error_n = "ERROR_INV_SW_OVER_VOLT";
                    qDebug() << error_n;
                    break;
                case 0x18:
                    error_n = "ERROR_INV_HW_OVER_VOLT";
                    qDebug() << error_n;
                    break;
                case 0x19:
                    error_n = "ERROR_INV_DC_OFFSET";
                    qDebug() << error_n;
                    break;
                case 0x1A:
                    error_n = "ERROR_INV_EARTH_LEAK";
                    qDebug() << error_n;
                    break;
                case 0x1B:
                    error_n = "ERROR_INV_OVER_CURR";
                    qDebug() << error_n;
                    break;
                case 0x1C:
                    error_n = "ERROR_INV_SHCCT";
                    qDebug() << error_n;
                    break;
                case 0x1D:
                    error_n = "ERROR_INV_OVL";
                    qDebug() << error_n;
                    break;
                }
                temp = ((uint8_t) frame.payload().at(2) << 8) | (uint8_t) frame.payload().at(3);
                qDebug() << "  temp        : " << QString::number(temp / 10.0) + " ºC";
                                                      emit TempChanged();

                humidity = ((uint8_t) frame.payload().at(4) << 8) | (uint8_t) frame.payload().at(5);
                qDebug() << "  humidity    : " << QString::number(humidity / 10.0) + " %";
                emit RHChanged();

                if (frame.payload().at(6) == 0) {
                    qDebug("  Reset Not Done");
                } else if (frame.payload().at(6) == 1) {
                    qDebug("  Reset Done");
                }
                break;

            case 0x103:
                if (frame.payload().at(0) == 0) {
                    AB = ((uint8_t) frame.payload().at(1) << 8 | (uint8_t) frame.payload().at(2));
                    qDebug() << "  AB          : " << QString::number(AB / 10.0) + " V";

                    BC = ((uint8_t) frame.payload().at(3) << 8 | (uint8_t) frame.payload().at(4));
                    qDebug() << "  BC          : " << QString::number(BC / 10.0) + " V";

                    CA = ((uint8_t) frame.payload().at(5) << 8 | (uint8_t) frame.payload().at(6));
                    qDebug() << "  CA          : " << QString::number(CA / 10.0) + " V";
                } else if (frame.payload().at(0) == 1) {
                    rectPhaseACur = ((uint8_t) frame.payload().at(1) << 8 | (uint8_t) frame.payload().at(2));
                    qDebug() << " rectPhaseACur: " << QString::number(rectPhaseACur / 10.0) + " A";

                    rectPhaseBCur = ((uint8_t) frame.payload().at(3) << 8 | (uint8_t) frame.payload().at(4));
                    qDebug() << " rectPhaseBCur: " << QString::number(rectPhaseBCur / 10.0) + " A";

                    rectPhaseCCur = ((uint8_t) frame.payload().at(5) << 8 | (uint8_t) frame.payload().at(6));
                    qDebug() << " rectPhaseCCur: " << QString::number(rectPhaseCCur / 10.0) + " A";

                    pn = ((invNomVolt * invNomCur));

                    poi = ((invPhaseAVolt * invPhaseACur) + (invPhaseBVolt * invPhaseBCur) + (invPhaseCVolt * invPhaseCCur) / 3);

                    load_ = (poi / pn);
                    qDebug() << " load :  " << load_;
                    emit LoadChanged();
                } else if (frame.payload().at(0) == 2) {
                    rectDCBusV = ((uint8_t) frame.payload().at(1) << 8 | (uint8_t) frame.payload().at(2));
                    qDebug() << "  rectDCBusV  : " << QString::number(rectDCBusV / 10.0) + " A";

                    rectMainFreq = ((uint8_t) frame.payload().at(3) << 8 | (uint8_t) frame.payload().at(4));
                    qDebug() << "  rectMainFreq: " << QString::number(rectMainFreq / 10.0) + " A";
                } else if (frame.payload().at(0) == 3) {
                    unitRunTime = ((uint8_t) frame.payload().at(1) << 24 | (uint8_t) frame.payload().at(2) << 16 | (uint8_t) frame.payload().at(3) << 8 | (uint8_t) frame.payload().at(4));
                    qDebug() << "  unitRunTime:  " << QString::number(unitRunTime);
                }
                break;
            case 0x104:
                if (frame.payload().at(0) == 0) {
                    invPhaseAVolt = ((uint8_t) frame.payload().at(1) << 8 | (uint8_t) frame.payload().at(2));
                    qDebug() << " invPhaseAVolt: " << QString::number(invPhaseAVolt / 10.0) + " V";
                    emit InvPhaseAVoltChanged();

                    invPhaseBVolt = ((uint8_t) frame.payload().at(3) << 8 | (uint8_t) frame.payload().at(4));
                    qDebug() << " invPhaseBVolt: " << QString::number(invPhaseBVolt / 10.0) + " V";
                    emit InvPhaseBVoltChanged();

                    invPhaseCVolt = ((uint8_t) frame.payload().at(5) << 8 | (uint8_t) frame.payload().at(6));
                    qDebug() << " invPhaseCVolt: " << QString::number(invPhaseCVolt / 10.0) + " V";
                    emit InvPhaseCVoltChanged();
                } else if (frame.payload().at(0) == 1) {
                    invPhaseACur = ((uint8_t) frame.payload().at(1) << 8 | (uint8_t) frame.payload().at(2));
                    qDebug() << " invPhaseACur : " << QString::number(invPhaseACur / 10.0) + " A";

                    invPhaseBCur = ((uint8_t) frame.payload().at(3) << 8 | (uint8_t) frame.payload().at(4));
                    qDebug() << " invPhaseBCur : " << QString::number(invPhaseBCur / 10.0) + " A";

                    invPhaseCCur = ((uint8_t) frame.payload().at(5) << 8 | (uint8_t) frame.payload().at(6));
                    qDebug() << " invPhaseCCur : " << QString::number(invPhaseCCur / 10.0) + " A";
                } else if (frame.payload().at(0) == 2) {
                    invFreq = ((uint8_t) frame.payload().at(1) << 8 | (uint8_t) frame.payload().at(2));
                    qDebug() << "  invFreq     : " << QString::number(invFreq / 10.0) + " Hz";
                }
                break;
            }
        }
        QCoreApplication::processEvents();
        data_mutex.unlock();
    }
    return a;
}

int pcan::getRectNomVolt() const {
    return rectNomVolt;
}

int pcan::getRectNomCur() const {
    return rectNomCur;
}

int pcan::getRunSerialNum() const {
    return runSerialNum;
}

int pcan::getInvNomVolt() const {
    return invNomVolt;
}

int pcan::getInvNomCur() const {
    return invNomCur;
}

int pcan::getInvNomFreq() const {
    return invNomFreq;
}

QString pcan::getUnitSerialNum() const {
    return unitSerialNum;
}

int pcan::getTemp() const {
    return temp;
}

int pcan::getHumidity() const {
    return humidity;
}

int pcan::getAB() const {
    return AB;
}

int pcan::getBC() const {
    return BC;
}

int pcan::getCA() const {
    return CA;
}

int pcan::getRectPhaseACur() const {
    return rectPhaseACur;
}

int pcan::getRectPhaseBCur() const {
    return rectPhaseBCur;
}

int pcan::getRectPhaseCCur() const {
    return rectPhaseCCur;
}

int pcan::getRectMainFreq() const {
    return rectMainFreq;
}

int pcan::getUnitRunTime() const {
    return unitRunTime;
}

int pcan::getInvPhaseAVolt() const {
    return invPhaseAVolt;
}

int pcan::getInvPhaseBVolt() const {
    return invPhaseBVolt;
}

int pcan::getInvPhaseCVolt() const {
    return invPhaseCVolt;
}

int pcan::getInvPhaseACur() const {
    return invPhaseACur;
}

int pcan::getInvPhaseBCur() const {
    return invPhaseBCur;
}

int pcan::getInvPhaseCCur() const {
    return invPhaseCCur;
}

int pcan::getInvFreq() const {
    return invFreq;
}

int pcan::getRectDCBusV() const {
    return rectDCBusV;
}

float pcan::getLoad() const {
    return load_;
}

QString pcan::getError_sfc() const {
    return error_sfc;
}

QString pcan::getError_n() const {
    return error_n;
}

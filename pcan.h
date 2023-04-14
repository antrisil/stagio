#ifndef PCAN_H
#define PCAN_H
#include <includes.h>


extern QMutex data_mutex;

class pcan: public QObject {
    Q_OBJECT

    Q_PROPERTY(int getLoad READ getLoad NOTIFY LoadChanged)
    Q_PROPERTY(int getAB READ getAB NOTIFY ABChanged)
    Q_PROPERTY(int getBC READ getBC NOTIFY BCChanged)
    Q_PROPERTY(int getCA READ getCA NOTIFY CAChanged)
    Q_PROPERTY(int getInvPhaseAVolt READ getInvPhaseAVolt NOTIFY InvPhaseAVoltChanged)
    Q_PROPERTY(int getInvPhaseBVolt READ getInvPhaseBVolt NOTIFY InvPhaseBVoltChanged)
    Q_PROPERTY(int getInvPhaseCVolt READ getInvPhaseCVolt NOTIFY InvPhaseCVoltChanged)
    Q_PROPERTY(int getHumidity READ getHumidity NOTIFY RHChanged)
    Q_PROPERTY(int getTemp READ getTemp NOTIFY TempChanged)

public:
    pcan();

    void write(QCanBusDevice * device);

    bool receive(QCanBusDevice * device);

    float getLoad() const;

    int getRectNomVolt() const;

    int getRectNomCur() const;

    int getRunSerialNum() const;

    int getInvNomVolt() const;

    int getInvNomCur() const;

    int getInvNomFreq() const;

    QString getUnitSerialNum() const;

    int getTemp() const;

    int getHumidity() const;

    int getAB() const;

    int getBC() const;

    int getCA() const;

    int getRectPhaseACur() const;

    int getRectPhaseBCur() const;

    int getRectPhaseCCur() const;

    int getRectMainFreq() const;

    int getUnitRunTime() const;

    int getInvPhaseAVolt() const;

    int getInvPhaseBVolt() const;

    int getInvPhaseCVolt() const;

    int getInvPhaseACur() const;

    int getInvPhaseBCur() const;

    int getInvPhaseCCur() const;

    int getInvFreq() const;

    int getRectDCBusV() const;

    QString getError_sfc() const;

    QString getError_n() const;

    void setInvPhaseAVolt(int newInvPhaseAVolt);

signals:
    void LoadChanged();
    void ABChanged();
    void BCChanged();
    void CAChanged();
    void InvPhaseAVoltChanged();
    void InvPhaseBVoltChanged();
    void InvPhaseCVoltChanged();
    void RHChanged();
    void TempChanged();
private:

};

#endif // PCAN_H

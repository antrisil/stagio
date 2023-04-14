#ifndef MYTRANSLATOR_H
#define MYTRANSLATOR_H

#include <QObject>
#include <QTranslator>
#include <QDebug>
#include <QGuiApplication>
#include <QDir>
#include <QQmlEngine>

class MyTranslator : public QObject
{
    Q_OBJECT
public:
    MyTranslator(QQmlEngine *engine);
    Q_PROPERTY(QString language WRITE selectLanguage NOTIFY languageChanged)

public slots:
    void selectLanguage(const QString &language);

signals:
    void languageChanged();

private:
    QTranslator *_translator;
    QQmlEngine *_engine;
    QString p_language;
};

#endif // MYTRANSLATOR_H

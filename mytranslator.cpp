#include "mytranslator.h"

MyTranslator::MyTranslator(QQmlEngine *engine)
{
    _translator = new QTranslator(this);
    _engine = engine;
}

void MyTranslator::selectLanguage(const QString &language)
{
    if(language != p_language)
    {
        QDir dir = QDir(qApp->applicationDirPath()).absolutePath(); //get directory path where app is running
        //Adjust file names and directories
        qDebug() << "Translation files directory: " << dir.path();

        if (!_translator->load(QString("GUI_%1").arg(language),QString("").arg(dir.path())))
        {
            qDebug() << "Failed to load translation file";
        } else {
            qDebug() << "Translation file loaded successfully for language:" << language;
        }

        qApp->installTranslator(_translator);
        _engine->retranslate();
        p_language = language;
        qDebug() << "Language changed to: " + language;
        emit languageChanged();
    }
    else
    {
        qDebug() << "Language al ready selected";
    }
}

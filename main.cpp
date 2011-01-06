#include <QtCore/QCoreApplication>
#include <QtScript/QScriptEngine>
#include <QFile>
#include <QFileInfo>
#include <qtextstream.h>
#include <QDebug>
#include "scriptfunctions.h"


int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QString fileName = "helloworld.qs";

    QFile scriptFile(fileName);
    if (!scriptFile.open(QIODevice::ReadOnly))
    {
        // handle error
        qDebug()<<"File open error";
    }
    else
    {
        QFileInfo info(scriptFile);
        qDebug()<< "File Path" + info.absoluteFilePath();
    }
    QTextStream stream(&scriptFile);
    QString contents = stream.readAll();
    scriptFile.close();
    ScriptFunctions functions;
    QScriptEngine myEngine;
    QScriptValue scriptFunctions = myEngine.newQObject(&functions);
    myEngine.globalObject().setProperty("nativeFunctions", scriptFunctions);
    QScriptValue value = scriptFunctions.property("isReady").call();
    qDebug()<< "Value called from script" + QString::number(value.toBool());

    QScriptValue result = myEngine.evaluate(contents, fileName);
    //QScriptValue result = myEngine.evaluate("nativeFunctions. = true");
     if (myEngine.hasUncaughtException()) {
         int line = myEngine.uncaughtExceptionLineNumber();
         qDebug() << "uncaught exception at line" << line << ":" << result.toString();
     }

    return a.exec();
}



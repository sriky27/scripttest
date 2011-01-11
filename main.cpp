#include <QtCore/QCoreApplication>
#include <QtScript/QScriptEngine>
#include <QFile>
#include <QFileInfo>
#include <qtextstream.h>
#include <QDebug>
#include "scriptfunctions.h"


static QScriptValue loadScripts(QScriptContext *context, QScriptEngine *engine)
{
    for (int i = 0; i < context->argumentCount(); ++i) {
        QString fileName = context->argument(0).toString();
        QFile file(fileName);
        if (!file.open(QIODevice::ReadOnly))
            return context->throwError(QString::fromLatin1("could not open %0 for reading").arg(fileName));
        QTextStream ts(&file);
        QString contents = ts.readAll();
        file.close();
        QScriptContext *pc = context->parentContext();
        context->setActivationObject(pc->activationObject());
        context->setThisObject(pc->thisObject());
        QScriptValue ret = engine->evaluate(contents);
        if (engine->hasUncaughtException())
            return ret;
    }
    return engine->undefinedValue();
}


int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QString fileName = "load.qs";

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
    myEngine.globalObject().setProperty("load", myEngine.newFunction(loadScripts, /*length=*/1));


    QScriptValue result = myEngine.evaluate(contents, fileName);
     if (myEngine.hasUncaughtException()) {
         int line = myEngine.uncaughtExceptionLineNumber();
         qDebug() << "uncaught exception at line" << line << ":" << result.toString();
     }

    return a.exec();
}



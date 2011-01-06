#include "scriptfunctions.h"
#include <QStringList>
#include <QDebug>
#include <QDir>
#include <QProcess>
#include <QFile>
#include <QTextStream>

ScriptFunctions::ScriptFunctions()
{

}

QStringList ScriptFunctions::readFile(QString aFileName)
{
    QStringList returnValue;
    QFile file(aFileName);
    if (file.open(QIODevice::ReadOnly))
    {
        QTextStream stream(&file);
        QString fileContent = stream.readAll();
        QString test = QRegExp::escape(fileContent);
        fileContent = fileContent.replace(QRegExp("\\s+") , ";");
        returnValue = fileContent.split(";");
        // removing empty strings
    }
    return returnValue;
}

QStringList ScriptFunctions::listDirectory(QString aFileName)
{
    QDir executableDir(".");
    QDir dir(aFileName);

    QStringList returnList;
    QStringList filters;
    filters << "*.*";

    QFileInfoList fileInfoList = dir.entryInfoList(filters);
    foreach (const QFileInfo& info, fileInfoList) {
        QString relativeFilePath = executableDir.relativeFilePath(info.absoluteFilePath());
        //returnList.append(info.absoluteFilePath());
        returnList.append(relativeFilePath);
    }
    return returnList;
}

QVariant ScriptFunctions::compareArrays(QStringList aArray1, QStringList aArray2)
{
    QVariant returnValue;
    QStringList found;
    QStringList notfound;
    bool equal = false;
    foreach(const QString& array1, aArray1)
    {
        bool foundItem = false;
        foreach(const QString& array2, aArray2)
        {
            if(array1 == array2)
            {
                foundItem = true;
                found.append(array2);
                break;
            }
        }
        if (!foundItem)
        {
            notfound.append(array1);
        }
    }

}

QString ScriptFunctions::replace(QString actual, QString lookFor, QString replaceWith)
{
    QString returnValue = actual.replace(lookFor, replaceWith);
    return returnValue;
}

QString ScriptFunctions::removeBefore(QString actual, QString lookFor)
{
    QString returnValue;
    int pos = actual.indexOf(lookFor);
    returnValue = actual.remove(0, pos);
    return returnValue;
}

void ScriptFunctions::callProcess(QString aProcess, QStringList aArguments)
{
    QProcess::startDetached(aProcess, aArguments);
}

bool ScriptFunctions::isReady()
{
    return true;
}

void ScriptFunctions::printValue(QStringList aMessageList)
{
    foreach (const QString& message, aMessageList) {
        printValue(message);
    }
}

void ScriptFunctions::printValue(QString aMessage)
{
    qDebug()<<aMessage;
}


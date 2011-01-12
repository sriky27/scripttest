#include "scriptfunctions.h"
#include <QStringList>
#include <QDebug>
#include <QDir>
#include <QProcess>
#include <QFile>
#include <QTextStream>
#include <QMap>
#include <QScopedPointer>

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
        //QString test = QRegExp::escape(fileContent);
        //QString separator = "::::";
        //fileContent = fileContent.replace(QRegExp("\\n+") , separator);
        //returnValue = fileContent.split(separator);
        returnValue = removeNewLine(fileContent);
        // removing empty strings
        file.close();
    }
    else
    {
        printValue(aFileName + " cannot be opened");
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

bool ScriptFunctions::createFile(QString aFileName)
{
    bool success = false;
    QFile file(aFileName);
    if (file.open(QIODevice::ReadWrite))
    {
        success = true;
        file.close();
    }
    return success;
}

bool ScriptFunctions::appendTextToFile(QString aFileName, QString aText)
{
    QFile file(aFileName);
    if (file.open(QIODevice::Append))
    {
        QTextStream stream(&file);
        stream << aText << "\n";
    }
    file.close();
}

bool ScriptFunctions::removeFile(QString aFileName)
{
    QDir dir(".");
    return dir.remove(aFileName);
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
    QString returnValue = actual.replace(QRegExp(lookFor), replaceWith);
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

QString ScriptFunctions::callProcessReadStdOut(QString aProcess, QStringList aArguments)
{
    // complete synchronous -- TODO: to make asynchronous
    QString returnValue = "";
    QScopedPointer<QProcess> process(new QProcess(this));
    process->setProcessChannelMode(QProcess::MergedChannels);
    process->setReadChannel(QProcess::StandardOutput);
    process->start(aProcess, aArguments);
    bool startWait = process->waitForStarted();
    if(startWait) {
    bool waitRead = process->waitForReadyRead();
    if(waitRead) {
        returnValue = process->readAllStandardOutput();
        }
    }
    process->waitForFinished();
    return returnValue;
}


bool ScriptFunctions::isReady()
{
    return true;
}

QVariant ScriptFunctions::findAndExtract(QString string, QString regExp)
{
    QRegExp rx(regExp);
    int pos = rx.indexIn(string);
    QStringList list = rx.capturedTexts();
    printValue(list);
    QMap<QString, QVariant> map;
    map["pos"] = QVariant(pos);
    map["captureList"] = QVariant(list);
    QVariant returnValue(map);
    return returnValue;
}

QStringList ScriptFunctions::removeDuplicates(QStringList array)
{
    array.removeDuplicates();
    return array;
}

QString ScriptFunctions::join(QStringList aList, QString separator)
{
    return aList.join(separator);
}

QStringList ScriptFunctions::split(QString string, QString separator)
{
    return string.split(separator);
}

QStringList ScriptFunctions::removeNewLine(QString actual)
{
    QStringList returnValue;
    QString separator = "::::";
    actual = actual.replace(QRegExp("\\n+") , separator);
    returnValue = actual.split(separator);
    return returnValue;
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


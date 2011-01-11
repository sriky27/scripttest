#ifndef SCRIPTFUNCTIONS_H
#define SCRIPTFUNCTIONS_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QVariant>

class ScriptFunctions : public QObject
{
    Q_OBJECT
public:
    ScriptFunctions();

public slots:

    // File related functions
    QStringList readFile(QString aFileName);
    QStringList listDirectory(QString aFileName);
    bool createFile(QString aFileName);
    bool appendTextToFile(QString aFileName, QString aText);
    bool removeFile(QString aFileName);

    // Handy String related functions
    QVariant compareArrays(QStringList aArray1, QStringList aArray2);
    QString replace(QString actual, QString lookFor, QString replaceWith);
    QString removeBefore(QString actual, QString lookFor);
    QVariant findAndExtract(QString string, QString regExp);
    QStringList removeDuplicates(QStringList array);
    QString join(QStringList list, QString separator);
    QStringList split(QString string, QString separator);

    // Calling process
    void callProcess(QString aProcessArg, QStringList aArguments);
    QString callProcessReadStdOut(QString aProcess, QStringList aArguments);
    bool isReady();

    // Debugging functions
    void printValue(QStringList aMessageArray);
    void printValue(QString aMessage);
};

#endif // SCRIPTFUNCTIONS_H

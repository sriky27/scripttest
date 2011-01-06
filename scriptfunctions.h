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

    // Handy String related functions
    QVariant compareArrays(QStringList aArray1, QStringList aArray2);
    QString replace(QString actual, QString lookFor, QString replaceWith);
    QString removeBefore(QString actual, QString lookFor);

    // Calling process
    void callProcess(QString aProcessArg, QStringList aArguments);
    bool isReady();

    // Debugging functions
    void printValue(QStringList aMessageArray);
    void printValue(QString aMessage);
};

#endif // SCRIPTFUNCTIONS_H
